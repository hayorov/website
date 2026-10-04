{{- /* YAML front matter for <page>/index.md */ -}}
{{- $p := . -}}
{{- $md := "" }}{{ with $p.OutputFormats.Get "markdown" }}{{ $md = .Permalink }}{{ end -}}
{{- $js := "" }}{{ with $p.OutputFormats.Get "json" }}{{ $js = .Permalink }}{{ end -}}
---
title: {{ jsonify (dict "noHTMLEscape" true) ($p.Title | plainify) }}
{{- with $p.Description }}
description: {{ jsonify (dict "noHTMLEscape" true) . }}
{{- end }}
url: {{ $p.Permalink }}
{{- with $md }}
markdown_url: {{ . }}
{{- end }}
{{- with $js }}
json_url: {{ . }}
{{- end }}
type: {{ if $p.IsSection }}section{{ else if eq $p.Section "posts" }}article{{ else }}page{{ end }}
author: {{ site.Params.Author.name }}
author_url: {{ site.BaseURL }}
{{- if not $p.Date.IsZero }}
date: {{ $p.Date.Format "2006-01-02" }}
{{- end }}
{{- if not $p.Lastmod.IsZero }}
lastmod: {{ $p.Lastmod.Format "2006-01-02" }}
{{- end }}
{{- with $p.Params.tags }}
tags: {{ jsonify . }}
{{- end }}
language: {{ site.Language.Lang }}
{{- if not $p.IsSection }}
word_count: {{ $p.WordCount }}
{{- end }}
---
