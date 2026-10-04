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

- `hugo.toml` — single source of config: site params, Blowfish theme settings (`colorScheme = "congo"`, `defaultAppearance = "dark"`, background homepage layout), author profile, menus, GA4 ID (`[services.googleAnalytics]`), `[markup]` block (Blowfish's required Goldmark/highlight settings — Hugo does not merge a theme's markup config, so they must live here), search/outputs (`config/_default/` exists but is empty)
- `netlify.toml` — Hugo 0.166.0 (the max version Blowfish v3.8.0 declares; a newer local Hugo only prints an advisory "not compatible" warning), Node 22, build `hugo --minify --gc`, `HUGO_ENV=production`, `HUGO_ENABLEGITINFO=true`; deploy previews build with `--buildFuture`; security headers (CSP, HSTS), 1-year immutable caching for assets, `hayorov.ru → hayorov.me` redirects, Lighthouse plugin

### Content (`content/`)

- `posts/` — blog posts; `_index.md` plus one file per post
- Pages: `about.md`, `resume.md`, `talks.md`, `publications.md`, `academic.md`, `fpv.md`, `cycling.md`
- `academic/` (repo root) — working documents for the academic CV (not site content)

### Layouts (`layouts/`, override Blowfish defaults)

- `shortcodes/`: `include-resume.html`, `include-talks.html`, `strava.html`, `foldergallery.html`, `biketimeline.html`
- `index.html` — home layout; same as Blowfish's but without the trailing recent-articles section (the background partial already renders that list at the top)
- `partials/`: `analytics/ga.html` (GA4, lazy-loaded on first interaction), `head.html` (Blowfish's with a `summary_large_image` Twitter-card block), `extend-head.html` (SEO/geo meta), `extend-head-uncached.html`, `favicons.html` (points at `static/favico/`), `gallery-deps.html` (shared jQuery 3.4.1 + Fancybox 3.5.7 loader), `schema.html` (JSON-LD), `home/background.html`, `recent-articles/`
- `head.html`, `home/background.html`, `recent-articles/*`, `schema.html` are modified copies of Blowfish partials. When bumping the theme, diff each against `themes/blowfish/layouts/...` and re-port the site's customisations onto the new upstream version
- `robots.txt`

### Assets & Static Files

- `assets/` — Hugo pipes: `css/custom.css` (loaded via `customCSS` param), `ava_gen4.jpg`, `background.svg`. `lib/fuse/` is an unused legacy copy of Fuse.js (the theme bundles its own) and can be deleted
- `static/` — images per topic (`cycling/`, `fpv/`, `rides/`, etc.), `favico/` (favicon set + `manifest.json`, wired in via `layouts/partials/favicons.html`; `static/favicon.ico` is a copy so `/favicon.ico` isn't the theme's default), `files/` (PDFs), `stl-models/`, `llms.txt`
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

## Analytics

GA4 (`G-757Y123ZRP`) configured in `hugo.toml` (`[services.googleAnalytics]`) and rendered via `layouts/partials/analytics/ga.html` with privacy settings (IP anonymization, no Google Signals, no ad personalization). Loads in production only.

## Deployment

Auto-deploys to Netlify on push to `master`. Deploy previews use a staging environment with future-dated content enabled.

Pre-deploy check: `npm run build` must complete without errors or warnings (other than the Hugo version-window notice when the local Hugo is newer than the theme's declared max); spot-check pages and shortcodes with `npm run dev`.

Theme upgrade: `git -C themes/blowfish fetch --tags && git -C themes/blowfish checkout vX.Y.Z`, then diff the overridden partials (see Layouts) against upstream, rebuild, and bump `HUGO_VERSION` in `netlify.toml` to the max in `themes/blowfish/config.toml`. `./generate-academic-pdf.sh` should be re-run whenever `content/academic.md` changes.

## Conventions

- Styles live in `assets/css/custom.css` — no inline CSS in shortcodes
- jQuery/Fancybox loaded only via `gallery-deps.html`, never duplicated
- Maintain accessibility (semantic HTML, ARIA labels, alt text) and lazy loading on gallery images
- Strava heatmaps: `static/rides/static-DD-MM-YYYY.jpg`

## Secrets

- Never commit secrets; local secrets go in `.env` (gitignored), production secrets in the Netlify UI
- No secrets in `hugo.toml` or `netlify.toml`; if a secret lands in git history, treat it as compromised and rotate it
