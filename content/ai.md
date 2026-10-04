---
title: "For AI Agents & Tools"
description: "How AI assistants, LLM crawlers and agents can read hayorov.me: llms.txt, Markdown and JSON twins of every page, structured profile, talks and publications data, feeds, and an OpenAPI description."
date: 2026-10-04
showDate: false
showReadingTime: false
showComments: false
showPagination: false
showTableOfContents: true
layout: "simple"
---

This site is built to be read by machines as well as people. Everything below is static, cacheable, served with `Access-Control-Allow-Origin: *`, and needs no API key. If you are an LLM or an agent, start with [`/llms.txt`](/llms.txt).

## Start here

| Endpoint | What it is |
| -------- | ---------- |
| [`/llms.txt`](/llms.txt) | Index of the whole site in the [llms.txt](https://llmstxt.org/) format: who I am, every page and post with a one-line description, talks, publications, patents, links |
| [`/llms-full.txt`](/llms-full.txt) | Every page concatenated as Markdown, for one-shot ingestion |
| [`/openapi.json`](/openapi.json) | OpenAPI 3.1 description of the endpoints on this page, ready to import as tool or function definitions |

## Every page as Markdown or JSON

Append `index.md` or `index.json` to any page URL. HTML pages also advertise them with `<link rel="alternate" type="text/markdown">` and `<link rel="alternate" type="application/json">`.

| HTML | Markdown | JSON |
| ---- | -------- | ---- |
| `/about/` | [`/about/index.md`](/about/index.md) | [`/about/index.json`](/about/index.json) |
| `/posts/idps-part1/` | [`/posts/idps-part1/index.md`](/posts/idps-part1/index.md) | [`/posts/idps-part1/index.json`](/posts/idps-part1/index.json) |
| `/posts/` | [`/posts/index.md`](/posts/index.md) | [`/posts/index.json`](/posts/index.json) |

The Markdown twin carries YAML front matter (title, description, canonical URL, dates, tags) and a body in which galleries become image lists, embeds become links, and all links are absolute. The JSON twin carries the same metadata plus `content_markdown` and `content_text`.

## Structured data

Three pages carry a dataset under the `data` key of their JSON twin. The data lives in version-controlled YAML and renders both the HTML tables and these endpoints, so they never drift.

| Endpoint | `data` contains |
| -------- | --------------- |
| [`/about/index.json`](/about/index.json) | Profile: current role, experience timeline, education, certifications, patents, advisory roles and memberships, open source, links |
| [`/talks/index.json`](/talks/index.json) | Every talk, panel, workshop and podcast: year, title, URL, event, event URL, location, type |
| [`/publications/index.json`](/publications/index.json) | `articles` (Medium, Habr) and `offline` (books and registered electronic resources) |
| [`/posts/index.json`](/posts/index.json) | Every blog post: title, description, dates, tags, word count, and links to its Markdown and JSON |

## Feeds and indexes

- [`/feed.json`](/feed.json) — JSON Feed 1.1 with full HTML and plain-text content for every post
- [`/index.xml`](/index.xml) — RSS 2.0 with full content
- [`/sitemap.xml`](/sitemap.xml) — XML sitemap
- [`/index.json`](/index.json) — the client-side search index (title, section, summary, plain text, permalink for every page)

## Semantics in the HTML

Every HTML page embeds JSON-LD (`Person` and `WebSite` on the home page, `Article` and `BreadcrumbList` elsewhere), Open Graph and Twitter Card metadata, `rel="me"` links to my profiles, and a `rel="describedby"` link to `/llms.txt`.

## Crawling, quoting and contact

AI crawlers and assistants are explicitly allowed in [`/robots.txt`](/robots.txt). You are welcome to read, index, summarise and quote this site; please link back to the canonical page URL when you do. Something missing or wrong in the machine-readable data? Email [alex@hayorov.me](mailto:alex@hayorov.me).
