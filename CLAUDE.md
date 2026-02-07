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

## Security & Environment Variables

### Environment Variables (.env)

**CRITICAL**: `.env` files contain private development secrets and **MUST NEVER** be:
- Committed to the repository
- Shared publicly or via chat/email
- Exposed in screenshots or documentation
- Pushed to remote repositories

### Best Practices

1. **Local Development Secrets**
   - Store sensitive values (API keys, tokens, passwords) in `.env` files
   - `.env` is already in `.gitignore` - verify it stays there
   - Use `.env.example` (without actual values) to document required variables

2. **Production Secrets**
   - Use Netlify UI to set environment variables for production
   - Never store production secrets in `netlify.toml` or any committed file
   - Access via `process.env.VARIABLE_NAME` in build scripts

3. **What Belongs in .env**
   - API keys (Google Analytics, Strava, external services)
   - Authentication tokens
   - Database credentials (if applicable)
   - Any sensitive configuration values

4. **What NOT to Put in .env**
   - Public configuration (use `hugo.toml` or `netlify.toml`)
   - Non-sensitive build settings
   - Hugo version numbers or public URLs

### Verification Checklist

Before committing:
- ✅ Run `git status` and ensure `.env` is NOT listed
- ✅ Check `.gitignore` includes `.env`
- ✅ Verify no secrets in `hugo.toml` or `netlify.toml`
- ✅ Use Netlify UI for production environment variables

**Remember**: Once a secret is committed to git, it's in the history forever. Even if deleted later, it can be retrieved from commit history. Treat all secrets as compromised if accidentally committed and rotate them immediately.

## Code Quality & Maintenance

### Best Practices

- **No duplicate code**: All styles centralized in `custom-responsive.css` (no inline styles in shortcodes)
- **Shared dependencies**: jQuery and Fancybox loaded once via shared partial `layouts/partials/gallery-deps.html`
- **Clean repository**: `.DS_Store` files are gitignored and regularly removed
- **Optimized CSS**: Redundant rules removed, properties consolidated
- **Consistent formatting**: Use `0` instead of `0px`, remove unnecessary units
- **Responsive design**: Mobile-first approach with breakpoints at 767px (mobile), 768-991px (tablet), 992px+ (desktop)
- **Accessibility**: WCAG 2.1 AA compliant with skip links, ARIA labels, semantic HTML, and proper focus indicators

### File Naming Conventions

- **Bike timeline photos**: `##BikeNameMonYY.jpg` (e.g., `00BigBlueJul21.jpg`, `01BigBlueNov21.jpg`)
  - First 2 digits: sorting order
  - Name: descriptive bike name
  - Month/Year: abbreviated (e.g., Jul21, Nov21, Apr23)
- **Strava heatmaps**: `static-DD-MM-YYYY.jpg` (e.g., `static-31-12-2021.jpg`)

### Dependencies

- **Fancybox 3.5.7**: Image lightbox galleries (loaded via shared partial `gallery-deps.html`)
- **jQuery 3.4.1**: Required for Fancybox (loaded with `defer` attribute for performance)
- **Custom CSS**: `/static/css/custom-responsive.css` (includes all shortcode styles, no inline CSS)
- **CDN Resource Hints**: Preconnect to `cdn.jsdelivr.net` and `www.googletagmanager.com` for faster loading

### Supported Date Formats in Bike Timeline

The biketimeline shortcode parses dates from filenames. Currently supported:

- `Jul21` → July 2021
- `Nov21` → November 2021
- `Apr23` → April 2023
- `Apr25` → April 2025
- `Jul25` → July 2025
- `Oct25` → October 2025

To add new dates, update the date parsing logic in `layouts/shortcodes/biketimeline.html`.

## Known Issues & Technical Debt

### Resolved in Recent Refactor (2025-12)
- ✅ Duplicate GA4 loading on homepage (now loads once in baseof.html)
- ✅ Inline CSS in shortcodes (352 lines extracted to custom-responsive.css)
- ✅ Duplicate jQuery/Fancybox loading (consolidated to shared partial `gallery-deps.html`)
- ✅ Missing accessibility attributes (added ARIA labels, skip links, semantic HTML)
- ✅ Missing SEO meta descriptions (added site-wide and page-specific support)
- ✅ Missing structured data (added JSON-LD Schema.org Person markup)
- ✅ No lazy loading on gallery images (added with `decoding="async"`)
- ✅ Typo: "botton-right-text" → "bottom-right-text"
- ✅ Deprecated Google Analytics UA references removed
- ✅ Color contrast issues fixed (timeline dates, sidebar opacity)
- ✅ Missing Open Graph images (added default and page-specific support)
- ✅ No resource hints for CDN (added dns-prefetch and preconnect)
- ✅ Poor alt text quality (improved to be descriptive, not just filenames)
- ✅ No documentation in shortcodes (added comprehensive usage docs)

## Testing & Quality Assurance

### Pre-deployment Checklist
1. Run `npm run build` - ensure no Hugo errors
2. Run `npm run dev` - verify pages render correctly
3. Test Lighthouse (Performance, SEO, Accessibility, Best Practices)
4. Cross-browser testing (Chrome, Firefox, Safari)
5. Mobile responsive testing (320px, 768px, 1024px viewports)
6. Verify GA4 tracking (production only)
7. Check all shortcodes render correctly

### Accessibility Standards
- WCAG 2.1 AA compliance
- Skip navigation link present (`<a href="#main-content" class="skip-link">`)
- Semantic HTML landmarks (`<main>`, `<nav>`, `<aside>`)
- ARIA labels on interactive elements (menu toggle, sidebar)
- Color contrast ratio ≥ 4.5:1 (timeline dates: #545454, sidebar: opacity 0.85)
- Alt text on all images (descriptive, uses `humanize` filter for gallery images)
- Keyboard navigation support with visible focus indicators (2px #4A9EFF outline)
- Iframe titles for screen readers

### Performance Optimizations
- Lazy loading on all gallery images (`loading="lazy" decoding="async"`)
- Deferred JavaScript loading (`defer` attribute on jQuery and Fancybox)
- CDN resource hints (dns-prefetch and preconnect)
- CSS caching enabled (all styles in external file)
- No inline styles (all extracted to custom-responsive.css)

### SEO Best Practices
- Meta descriptions on all pages (site-wide fallback + page-specific)
- Structured data (JSON-LD Schema.org Person type)
- Open Graph images (default + page-specific)
- Meta keywords configured
- Semantic HTML structure

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

**Implementation**: GA4 is loaded via `layouts/_default/baseof.html` only (previously had duplicate in index.html) and implemented in `layouts/partials/ga4.html`, ensuring site-wide tracking without duplication.

## Site Version Footer

The site includes a fixed footer bar at the bottom of every page showing build and version information.

### Displayed Information

- **Built**: Timestamp when the site was built (e.g., "2025-10-19 00:06:32 +08")
- **Commit**: Git commit hash with link to GitHub (production only, requires `HUGO_ENABLEGITINFO=true`)
- **Updated**: Last git commit date (production only)
- **Hugo**: Hugo version used to build the site (e.g., "0.151.2")
- **Environment**: Shows dev/staging environment when not in production

### Implementation

- **Partial**: `layouts/partials/site-version.html` - Generates version info from Hugo and Git data
- **Styling**: `static/css/custom-responsive.css` - Fixed footer with dark theme and monospace font
- **Position**: Fixed at bottom of page, auto-adjusts on mobile (stacks vertically)

The footer uses git commit information when `HUGO_ENABLEGITINFO=true` is set in the build environment (configured in `netlify.toml`).
