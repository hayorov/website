# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project Overview

Personal website of Alex Khaerov (<https://hayorov.me/>), built with **Hugo** and the **Blowfish v3** theme (git submodule at `themes/blowfish`, pinned to a release tag — currently `v3.8.0`). Deployed to Netlify. Content: blog posts, resume, talks, publications, academic profile, and hobbies (cycling, FPV/UAV).

## Commands

```bash
npm run dev                # Hugo dev server with drafts (hugo server -D)
npm run build              # Build site to public/
npm run clean              # Remove public/
hugo new posts/my-post.md  # Create a new blog post
./generate-academic-pdf.sh # Generate academic CV PDF from /academic/ via headless Chrome
```

## Architecture

### Configuration

- `hugo.toml` — single source of config: site params, Blowfish theme settings (`colorScheme = "congo"`, `defaultAppearance = "dark"`, background homepage layout), author profile, menus, GA4 ID (`[services.googleAnalytics]`), `[markup]` block (Blowfish's required Goldmark/highlight settings — Hugo does not merge a theme's markup config, so they must live here), `[mediaTypes]`/`[outputFormats]`/`[outputs]` for the machine-readable outputs (see [LLM-friendly outputs](#llm-friendly-outputs)); `config/_default/` exists but is empty
- `netlify.toml` — Hugo 0.166.0 (the max version Blowfish v3.8.0 declares; a newer local Hugo only prints an advisory "not compatible" warning), Node 22, build `hugo --minify --gc`, `HUGO_ENV=production`, `HUGO_ENABLEGITINFO=true`; deploy previews build with `--buildFuture`; security headers (CSP, HSTS), 1-year immutable caching for assets, CORS + `text/markdown` + revalidate caching for `llms*.txt`, `*.md`, `*.json`, `*.xml`, `hayorov.ru → hayorov.me` redirects, Lighthouse plugin

### Content (`content/`)

- `posts/` — blog posts; `_index.md` plus one file per post
- Pages: `about.md`, `resume.md`, `talks.md`, `publications.md`, `academic.md`, `fpv.md`, `cycling.md`, `ai.md` (guide to the machine-readable endpoints). `about.md`, `talks.md`, `publications.md` carry `dataset = "profile" | "talks" | "publications"` so their `index.json` embeds the matching data file
- `academic/` (repo root) — working documents for the academic CV (not site content)

### Data (`data/`) — single source of truth for structured facts

- `talks.yaml` — every talk/panel/workshop; renders the `/talks/` table (via `{{% talks-table %}}`), `/talks/index.json`, `/talks/index.md`, `/llms.txt`
- `publications.yaml` — `articles` + `offline` (books/registrations); renders `/publications/` (via `{{% publications-table %}}` / `{{% publications-offline %}}`) and the JSON/Markdown/llms outputs
- `profile.yaml` — role, experience, education, certifications, patents, memberships, links; served under `data` in `/about/index.json` and used for the "Key facts" block of `/llms.txt`. Keep in sync with `content/resume.md` / `content/academic.md` (prose stays there)

### Layouts (`layouts/`, override Blowfish defaults)

- `shortcodes/`: `include-resume.html`, `include-talks.html`, `strava.html`, `foldergallery.html`, `biketimeline.html`, plus the data-driven Markdown shortcodes `talks-table.html`, `publications-table.html`, `publications-offline.html` (must be invoked with `{{% %}}`, they emit Markdown)
- Machine-readable templates (Hugo ≥ 0.146 naming, the theme itself still uses legacy `_default/` names): `page.md`, `section.md` (Markdown twins), `page.json`, `section.json` (JSON twins), `home.llms.txt`, `home.llms-full.txt`, `home.jsonfeed.json`, `home.openapi.json`
- `partials/llm/body.md` (page body → clean Markdown: inlines `include-resume`/`include-talks`, expands data shortcodes, turns `figure`/`youtube`/`button`/`strava`/galleries into Markdown, resolves `ref`, absolutises links) and `partials/llm/frontmatter.md`; `partials/data/*.md` build the Markdown tables from `data/`. These partials are `.md` on purpose: that maps to the plain-text `markdown` output format, so Hugo uses `text/template` and does not HTML-escape `&` in URLs (a `.txt` partial is ambiguous between two text/plain formats and gets escaped)
- `index.html` — home layout; same as Blowfish's but without the trailing recent-articles section (the background partial already renders that list at the top)
- `partials/`: `analytics/ga.html` (GA4, lazy-loaded on first interaction), `head.html` (Blowfish's with a `summary_large_image` Twitter-card block), `extend-head.html` (SEO/geo meta), `extend-head-uncached.html`, `favicons.html` (points at `static/favico/`), `gallery-deps.html` (shared jQuery 3.4.1 + Fancybox 3.5.7 loader), `schema.html` (JSON-LD), `home/background.html`, `recent-articles/`
- `head.html`, `home/background.html`, `recent-articles/*`, `schema.html` are modified copies of Blowfish partials. When bumping the theme, diff each against `themes/blowfish/layouts/...` and re-port the site's customisations onto the new upstream version
- `robots.txt`

### Assets & Static Files

- `assets/` — Hugo pipes: `css/custom.css` (loaded via `customCSS` param), `ava_gen4.jpg`, `background.svg`. `lib/fuse/` is an unused legacy copy of Fuse.js (the theme bundles its own) and can be deleted
- `static/` — images per topic (`cycling/`, `fpv/`, `rides/`, etc.), `favico/` (favicon set + `manifest.json`, wired in via `layouts/partials/favicons.html`; `static/favicon.ico` is a copy so `/favicon.ico` isn't the theme's default), `files/` (PDFs), `stl-models/`
- `public/` — generated output (gitignored)

## Content Authoring

Blog posts use TOML front matter:

```toml
+++
title = "Post Title"
date = "2026-02-19"
description = "One-line summary for SEO."
tags = ["tag1", "tag2"]
+++
```

Standalone pages (e.g. `academic.md`) use YAML front matter with Blowfish display options (`showDate`, `showTableOfContents`, `layout: "simple"`, etc.).

### Shortcodes

- `{{< include-resume >}}` / `{{< include-talks >}}` — embed resume/talks content
- `{{< strava activity_id token >}}` — Strava activity widget + heatmap; `{{< strava >}}` for heatmap only
- `{{< foldergallery "path/to/images" >}}` — Fancybox gallery from a static folder
- `{{< biketimeline src="folder" >}}` — bike photo timeline; filenames must follow `##BikeNameMonYY.jpg` (e.g. `00BigBlueJul21.jpg`). Supported date tokens (Jul21 … Jan26) are hardcoded in `layouts/shortcodes/biketimeline.html` — add new ones there.
- `{{% talks-table %}}`, `{{% publications-table %}}`, `{{% publications-offline %}}` — render `data/talks.yaml` / `data/publications.yaml` as Markdown tables/lists (percent syntax is required)
- Adding a new shortcode? Also teach `layouts/partials/llm/body.md` how to turn it into Markdown, otherwise it is silently stripped from the `.md`/JSON/llms outputs.

## LLM-friendly outputs

Everything is generated by Hugo at build time; nothing is hand-maintained.

| URL | Template | Purpose |
| --- | --- | --- |
| `/llms.txt` | `layouts/home.llms.txt` | llms.txt index: profile key facts, endpoints, every page/post with description, talks, publications, patents, links |
| `/llms-full.txt` | `layouts/home.llms-full.txt` | every page concatenated as Markdown (skips `/resume`, which is embedded in `/about`) |
| `<page>/index.md` | `layouts/page.md`, `layouts/section.md` | Markdown twin with YAML front matter; advertised via `<link rel="alternate" type="text/markdown">` |
| `<page>/index.json` | `layouts/page.json`, `layouts/section.json` | JSON twin (`content_markdown`, `content_text`, metadata; `data` when the page has `dataset`) |
| `/feed.json` | `layouts/home.jsonfeed.json` | JSON Feed 1.1 with full post content |
| `/openapi.json` | `layouts/home.openapi.json` | OpenAPI 3.1 for the read-only endpoints; slug enums are generated from the content |
| `/index.json` | theme `_default/index.json` | Blowfish search index (unchanged) |
| `/robots.txt` | `layouts/robots.txt` | allows all, lists AI user agents explicitly, points at llms.txt |
| `/ai/` | `content/ai.md` | human-readable guide to the above |

Rules: edit `data/*.yaml` rather than tables in Markdown; add `dataset = "<name>"` to a page's front matter to embed `data/<name>.yaml` in its JSON; after changing templates run `npm run build` and confirm `python3 -c 'import json,glob;[json.load(open(f)) for f in glob.glob("public/**/*.json",recursive=True)]'` passes and `grep -rl '{{' public --include=index.md` is empty. Do not use `hugo --quiet` when verifying — it suppresses build errors, not just noise.

## Analytics

GA4 (`G-757Y123ZRP`) configured in `hugo.toml` (`[services.googleAnalytics]`) and rendered via `layouts/partials/analytics/ga.html` with privacy settings (IP anonymization, no Google Signals, no ad personalization). Loads in production only.

## Deployment

Auto-deploys to Netlify on push to `master`. Deploy previews use a staging environment with future-dated content enabled.

`hugo server` (`npm run dev`) renders into `public/` too ("Serving pages from disk"), so re-run `npm run build` before inspecting production output, and never run the dev server while verifying a build.

Pre-deploy check: `npm run build` must complete without errors or warnings (other than the Hugo version-window notice when the local Hugo is newer than the theme's declared max); spot-check pages and shortcodes with `npm run dev`, and spot-check `public/llms.txt`, `public/about/index.json` and one post's `index.md`.

Theme upgrade: `git -C themes/blowfish fetch --tags && git -C themes/blowfish checkout vX.Y.Z`, then diff the overridden partials (see Layouts) against upstream, rebuild, and bump `HUGO_VERSION` in `netlify.toml` to the max in `themes/blowfish/config.toml`. `./generate-academic-pdf.sh` should be re-run whenever `content/academic.md` changes.

## Conventions

- Styles live in `assets/css/custom.css` — no inline CSS in shortcodes
- jQuery/Fancybox loaded only via `gallery-deps.html`, never duplicated
- Maintain accessibility (semantic HTML, ARIA labels, alt text) and lazy loading on gallery images
- Strava heatmaps: `static/rides/static-DD-MM-YYYY.jpg`
- Talks, publications and profile facts live in `data/*.yaml`; the Markdown pages only hold prose and the `{{% … %}}` shortcodes

## Secrets

- Never commit secrets; local secrets go in `.env` (gitignored), production secrets in the Netlify UI
- No secrets in `hugo.toml` or `netlify.toml`; if a secret lands in git history, treat it as compromised and rotate it
