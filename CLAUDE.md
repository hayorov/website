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
- **Netlify**: `netlify.toml` - Specifies Hugo version (0.151.2 extended), build commands, and redirects (.ru → .me)
- **Base URL**: <https://hayorov.me/>

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
  - `strava.html` - Embeds Strava activity widget and heatmap
  - `foldergallery.html` - Creates image galleries from folder contents
  - `biketimeline.html` - Creates an elegant timeline visualization for bike photos
- `layouts/partials/` - Template overrides:
  - `ga4.html` - Google Analytics 4 integration with privacy settings
  - `header.html` - Custom header template
  - `sidebar.html` - Custom sidebar template
  - `page-list/` - Custom list page templates
  - `page-single/` - Custom single page templates
- `layouts/_default/` - Default layout overrides:
  - `baseof.html` - Base template that includes GA4 on all pages (production only)

### Theme

Uses `hyde-hyde` theme (in `themes/hyde-hyde/`). Custom layouts in root `layouts/` directory override theme defaults.

### Static Assets

- `static/` - Images, favicons, and other static files served at site root
  - `static/css/custom-responsive.css` - Custom responsive CSS for tables, galleries, Strava widgets, and mobile optimizations
  - `static/cycling/` - Bike photos for timeline (format: `##BikeNameMonYY.jpg`)
  - `static/rides/` - Strava heatmap images
  - `static/favico/` - Favicon files for all platforms
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
- `{{< strava activity_id token >}}` - Embed Strava activity widget with heatmap
- `{{< strava >}}` - Embed Strava heatmap only (without activity widget)
- `{{< foldergallery "path/to/images" >}}` - Create image gallery from a folder
- `{{< biketimeline src="folder" >}}` - Create timeline from bike photos (photos must follow naming: `##BikeNameMonYY.jpg`)

## Deployment

The site auto-deploys to Netlify on push to master branch:

- **Build command**: `hugo --minify --gc` (with garbage collection and minification)
- **Publish directory**: `public`
- **Hugo version**: 0.151.2 (extended)
- **Node version**: 20
- **Production environment**: `HUGO_ENV=production`, `HUGO_ENABLEGITINFO=true`

### Modern Netlify Features

The `netlify.toml` configuration includes:

- **Build Optimization**: Minification and garbage collection enabled
- **Deploy Previews**: Separate staging environment with future content enabled
- **Security Headers**:
  - X-Frame-Options, X-XSS-Protection, X-Content-Type-Options
  - Content Security Policy (CSP) for HTML pages
  - Referrer-Policy and FLoC blocking
- **Performance**:
  - Aggressive caching (1 year) for static assets with `immutable` flag
  - Separate cache rules for CSS, JS, images, and favicons
- **Redirects**: HTTP and HTTPS redirects from hayorov.ru to hayorov.me with `:splat` pattern
- **Quality Monitoring**: Netlify Lighthouse plugin for automated performance audits

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

## Code Quality & Maintenance

### Best Practices

- **No duplicate code**: Styles are centralized - responsive rules in `custom-responsive.css`, component-specific styles in shortcode files
- **Clean repository**: `.DS_Store` files are gitignored and regularly removed
- **Optimized CSS**: Redundant rules removed, properties consolidated
- **Consistent formatting**: Use `0` instead of `0px`, remove unnecessary units
- **Responsive design**: Mobile-first approach with breakpoints at 767px (mobile), 768-991px (tablet), 992px+ (desktop)

### File Naming Conventions

- **Bike timeline photos**: `##BikeNameMonYY.jpg` (e.g., `00BigBlueJul21.jpg`, `01BigBlueNov21.jpg`)
  - First 2 digits: sorting order
  - Name: descriptive bike name
  - Month/Year: abbreviated (e.g., Jul21, Nov21, Apr23)
- **Strava heatmaps**: `static-DD-MM-YYYY.jpg` (e.g., `static-31-12-2021.jpg`)

### Dependencies

- **Fancybox 3.5.7**: Used for image lightbox galleries (loaded via CDN in shortcodes)
- **jQuery 3.4.1**: Required for Fancybox (loaded via CDN in shortcodes)
- **Custom CSS**: All custom styles in `/static/css/custom-responsive.css`

### Supported Date Formats in Bike Timeline

The biketimeline shortcode parses dates from filenames. Currently supported:

- `Jul21` → July 2021
- `Nov21` → November 2021
- `Apr23` → April 2023
- `Apr25` → April 2025
- `Jul25` → July 2025

To add new dates, update the date parsing logic in `layouts/shortcodes/biketimeline.html`.

## Analytics & Tracking

### Google Analytics 4

The site uses Google Analytics 4 (GA4) with privacy-focused settings:

- **GA4 ID**: Configured in `config.toml` as `ga4_id = "G-757Y123ZRP"`
- **Production Only**: GA4 only loads when `hugo.Environment == "production"`
- **Privacy Settings**:
  - IP anonymization enabled (`anonymize_ip: true`)
  - Secure cookies with SameSite flag
  - Google Signals disabled (no cross-device tracking)
  - Ad personalization disabled

**Implementation**: GA4 is loaded via `layouts/_default/baseof.html` and implemented in `layouts/partials/ga4.html`, ensuring tracking on all pages (not just homepage).
