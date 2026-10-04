{{- /* Markdown list of books / registered electronic resources from data/publications.yaml. */ -}}
{{ range hugo.Data.publications.offline -}}
- **{{ .authors }}** _{{ .title_original }}_ \[_{{ .title_english }}_\]. {{ .details }}

{{ end -}}
