{{- /* Markdown table of articles from data/publications.yaml. */ -}}
| Year | Topic | Language |
| ---- | ----- | -------- |
{{ range hugo.Data.publications.articles -}}
| {{ .year }} | [{{ replace .title "|" "\\|" }}]({{ .url }}) | {{ .language }} |
{{ end -}}
