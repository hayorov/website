{{ partial "llm/frontmatter.md" . }}
# {{ .Title | plainify }}

{{ with .Description }}> {{ . }}

{{ end -}}
{{ len .RegularPages }} entries, newest first. Each link points at the Markdown version of the page; drop the trailing `index.md` for the HTML page, or replace it with `index.json` for structured data.

{{ range .RegularPages }}
{{- $md := .Permalink }}{{ with .OutputFormats.Get "markdown" }}{{ $md = .Permalink }}{{ end }}
- [{{ .Title | plainify }}]({{ $md }}) — {{ .Date.Format "2006-01-02" }}{{ with .Description }}: {{ . }}{{ end }}{{ with .Params.tags }} _(tags: {{ delimit . ", " }})_{{ end }}
{{- end }}

---

Canonical HTML page: {{ .Permalink }}
Site index for AI agents: {{ "llms.txt" | absURL }}
