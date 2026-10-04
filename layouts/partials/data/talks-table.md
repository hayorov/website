{{- /* Markdown table of talks from data/talks.yaml. Used by the talks-table shortcode and the Markdown/llms outputs. */ -}}
| Year | Topic | Conference | Location |
| ---- | ----- | ---------- | -------- |
{{ range hugo.Data.talks -}}
{{- $title := replace .title "|" "\\|" -}}
{{- $event := replace .event "|" "\\|" -}}
| {{ .year }} | {{ if .url }}[{{ $title }}]({{ .url }}){{ else }}{{ $title }}{{ end }} | {{ if .event_url }}[{{ $event }}]({{ .event_url }}){{ else }}{{ $event }}{{ end }} | {{ .location }} |
{{ end -}}
