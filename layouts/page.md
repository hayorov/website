{{ partial "llm/frontmatter.md" . }}
# {{ .Title | plainify }}

{{ with .Description }}> {{ . }}

{{ end -}}
{{ partial "llm/body.md" . }}

---

Canonical HTML page: {{ .Permalink }}
{{- with .OutputFormats.Get "json" }}
Structured JSON: {{ .Permalink }}
{{- end }}
Site index for AI agents: {{ "llms.txt" | absURL }}
