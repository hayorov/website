# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal website built with **Hugo**, a static site generator. The site is deployed to Netlify and uses the `hyde-hyde` theme. The website showcases blog posts, professional resume, talks, publications, and personal interests (cycling, FPV/UAV).

## Common Commands

### Development

```bash
npm run dev           # Start Hugo development server with drafts (-D flag)
npm run build         # Build the site (outputs to public/)
npm run clean         # Remove public/ directory
```

### Hugo-specific operations

```bash
hugo server -D        # Start development server with drafts
hugo new posts/my-post.md  # Create a new blog post
hugo                  # Build site for production
```

## Site Architecture

### Configuration

- **Main config**: `config.toml` - Contains site settings, menu structure, social links, and theme parameters
- **Netlify**: `netlify.toml` - Specifies Hugo version (0.147.9 extended), build commands, and redirects (.ru → .me)
- **Base URL**: https://hayorov.me/

### Content Structure

All content is in `content/` directory:

- `content/posts/` - Blog posts (markdown files with TOML front matter)
- `content/about.md` - About page (uses shortcodes to include resume and talks)
- `content/resume.md` - Professional experience, education, certifications, patents
- `content/talks.md` - Conference presentations and speaking engagements
- `content/publications.md` - Publications and articles
- `content/fpv.md` - FPV/UAV hobby content
- `content/cycling.md` - Cycling-related content

### Custom Layouts

Located in `layouts/`:

- `layouts/shortcodes/` - Custom Hugo shortcodes:
  - `include-resume.html` - Embeds content from `/resume` page
  - `include-talks.html` - Embeds content from `/talks` page
  - `strava.html` - Embeds Strava activity widget
  - `foldergallery.html` - Creates image galleries from folder contents
- `layouts/partials/` - Template overrides:
  - `ga4.html` - Google Analytics 4 integration
  - `header.html` - Custom header template
  - `sidebar.html` - Custom sidebar template
  - `page-list/` - Custom list page templates
  - `page-single/` - Custom single page templates

### Theme

Uses `hyde-hyde` theme (in `themes/hyde-hyde/`). Custom layouts in root `layouts/` directory override theme defaults.

### Static Assets

- `static/` - Images, favicons, and other static files served at site root
- `public/` - Generated site output (gitignored, created by Hugo build)

## Content Authoring

### Creating New Blog Posts

Blog posts use TOML front matter (+++):

```toml
+++
title = "Post Title"
date = "2025-10-18"
+++

Content here...
```

### Using Custom Shortcodes

- `{{< include-resume >}}` - Include resume content
- `{{< include-talks >}}` - Include talks list
- `{{< strava activity_id token >}}` - Embed Strava activity
- `{{< foldergallery "path/to/images" >}}` - Create image gallery

## Deployment

The site auto-deploys to Netlify on push to master branch:

- Build command: `hugo`
- Publish directory: `public`
- Hugo version: 0.147.9 (extended)
- Production environment variables set in `netlify.toml`

## Menu Structure

Site navigation is configured in `config.toml` with weighted menu items:

1. About Me (weight: 10)
2. FPV & UAV (weight: 15)
3. Cycling (weight: 16)
4. My Talks (weight: 20)
5. Publications (weight: 30)
6. Blog Posts (weight: 40)
7. COVID sign (weight: 100)

## Node Dependencies

Minimal Node.js setup (requires Node >= 20):

- `mdpdf` - For generating PDFs from markdown
- Other dependencies are utilities for the build process

## Git Workflow

- Main branch: `master`
- Clean working directory (no uncommitted changes)
- Standard commit messages based on recent history
