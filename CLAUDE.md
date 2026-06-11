# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project Overview

Personal website of Alex Khaerov (<https://hayorov.me/>), built with **Hugo** and the **Blowfish** theme (git submodule at `themes/blowfish`). Deployed to Netlify. Content: blog posts, resume, talks, publications, academic profile, and hobbies (cycling, FPV/UAV).

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

- `hugo.toml` — single source of config: site params, Blowfish theme settings (`colorScheme = "congo"`, dark theme, background homepage layout), author profile, menus, GA4 ID, search/outputs (`config/_default/` exists but is empty)
- `netlify.toml` — Hugo 0.160.1, Node 20, build `hugo --minify --gc`, `HUGO_ENV=production`, `HUGO_ENABLEGITINFO=true`; deploy previews build with `--buildFuture`; security headers (CSP, HSTS), 1-year immutable caching for assets, `hayorov.ru → hayorov.me` redirects, Lighthouse plugin

### Content (`content/`)

- `posts/` — blog posts; `_index.md` plus one file per post
- Pages: `about.md`, `resume.md`, `talks.md`, `publications.md`, `academic.md`, `fpv.md`, `cycling.md`
- `academic/` (repo root) — working documents for the academic CV (not site content)

### Layouts (`layouts/`, override Blowfish defaults)

- `shortcodes/`: `include-resume.html`, `include-talks.html`, `strava.html`, `foldergallery.html`, `biketimeline.html`
- `partials/`: `analytics/ga.html` (GA4), `head.html`, `extend-head.html` (SEO/geo meta), `extend-head-uncached.html`, `gallery-deps.html` (shared jQuery 3.4.1 + Fancybox 3.5.7 loader), `schema.html` (JSON-LD), `home/background.html`, `recent-articles/`
- `robots.txt`

### Assets & Static Files

- `assets/` — Hugo pipes: `css/custom.css` (loaded via `customCSS` param), `lib/fuse/` (Fuse.js for Blowfish search — required, build fails without it), `ava_gen4.jpg`, `background.svg`
- `static/` — images per topic (`cycling/`, `fpv/`, `rides/`, etc.), `favico/`, `files/` (PDFs), `stl-models/`, `llms.txt`
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

GA4 (`G-757Y123ZRP`) configured in `hugo.toml` and rendered via `layouts/partials/analytics/ga.html` with privacy settings (IP anonymization, no Google Signals, no ad personalization). Loads in production only.

## Deployment

Auto-deploys to Netlify on push to `master`. Deploy previews use a staging environment with future-dated content enabled.

Pre-deploy check: `npm run build` must complete without errors; spot-check pages and shortcodes with `npm run dev`.

## Conventions

- Styles live in `assets/css/custom.css` — no inline CSS in shortcodes
- jQuery/Fancybox loaded only via `gallery-deps.html`, never duplicated
- Maintain accessibility (semantic HTML, ARIA labels, alt text) and lazy loading on gallery images
- Strava heatmaps: `static/rides/static-DD-MM-YYYY.jpg`

## Secrets

- Never commit secrets; local secrets go in `.env` (gitignored), production secrets in the Netlify UI
- No secrets in `hugo.toml` or `netlify.toml`; if a secret lands in git history, treat it as compromised and rotate it
