{{- /*
  Returns a page's body as clean, self-contained Markdown for the LLM-facing outputs
  (<page>/index.md, /llms-full.txt and content_markdown in <page>/index.json).
  Starts from .RawContent and resolves this site's shortcodes into plain Markdown:
  embedded pages are inlined, galleries become image lists, media become links,
  and site-relative links are made absolute.
*/ -}}
{{- $p := . -}}
{{- $c := $p.RawContent -}}

{{- /* Shortcodes that embed other pages (guarded: only recurse when actually used) */ -}}
{{- if in $c "{{< include-resume >}}" -}}
  {{- with site.GetPage "/resume" -}}
    {{- $c = replace $c "{{< include-resume >}}" (partial "llm/body.md" .) -}}
  {{- end -}}
{{- end -}}
{{- if in $c "{{< include-talks >}}" -}}
  {{- with site.GetPage "/talks" -}}
    {{- $c = replace $c "{{< include-talks >}}" (partial "llm/body.md" .) -}}
  {{- end -}}
{{- end -}}

{{- /* Data-driven tables (data/talks.yaml, data/publications.yaml) */ -}}
{{- $c = replace $c "{{% talks-table %}}" (partial "data/talks-table.md" $p) -}}
{{- $c = replace $c "{{% publications-table %}}" (partial "data/publications-table.md" $p) -}}
{{- $c = replace $c "{{% publications-offline %}}" (partial "data/publications-offline.md" $p) -}}

{{- /* {{< ref "..." >}} -> absolute permalink */ -}}
{{- range $m := findRE `\{\{<\s*ref\s+"[^"]+"\s*>\}\}` $c -}}
  {{- $target := replaceRE `\{\{<\s*ref\s+"([^"]+)"\s*>\}\}` "$1" $m -}}
  {{- with $p.GetPage $target -}}
    {{- $c = replace $c $m .Permalink -}}
  {{- end -}}
{{- end -}}

{{- /* Media shortcodes -> Markdown images / links */ -}}
{{- $c = replaceRE `\{\{<\s*figure\s+src="([^"]*)"\s+caption="((?:[^"\\]|\\.)*)"[^>]*>\}\}` "![${2}](${1})" $c -}}
{{- $c = replaceRE `\{\{<\s*figure\s+src="([^"]*)"[^>]*>\}\}` "![](${1})" $c -}}
{{- $c = replaceRE `\{\{<\s*youtube\s+([A-Za-z0-9_-]+)\s*>\}\}` "[YouTube video](https://www.youtube.com/watch?v=${1})" $c -}}
{{- $c = replaceRE `(?s)\{\{<\s*button\s+href="([^"]+)"[^>]*>\}\}\s*(.*?)\s*\{\{<\s*/button\s*>\}\}` "[${2}](${1})" $c -}}
{{- $c = replaceRE `\{\{<\s*strava\s+(\d+)[^>]*>\}\}` "Strava profile: https://www.strava.com/athletes/${1} (the HTML page embeds a ride heatmap and activity summary)." $c -}}

{{- /* Image galleries -> list of image URLs */ -}}
{{- range $m := findRE `\{\{<\s*(?:foldergallery|biketimeline)\s+src="[^"]+"\s*>\}\}` $c -}}
  {{- $dir := replaceRE `^.*src="([^"]+)".*$` "$1" $m -}}
  {{- $imgs := slice -}}
  {{- range readDir (printf "static/%s" $dir) -}}
    {{- if in (slice ".jpg" ".jpeg" ".png" ".gif" ".webp" ".bmp" ".svg") (path.Ext .Name | lower) -}}
      {{- $imgs = $imgs | append (printf "- ![%s](%s)" (replaceRE `\.[^.]+$` "" .Name | humanize) (absURL (printf "%s/%s" $dir .Name))) -}}
    {{- end -}}
  {{- end -}}
  {{- $c = replace $c $m (printf "Photo gallery (%d images):\n\n%s" (len $imgs) (delimit $imgs "\n")) -}}
{{- end -}}

{{- /* Anything left over is presentational only */ -}}
{{- $c = replaceRE `\{\{[<%][^}]*[>%]\}\}` "" $c -}}

{{- /* Site-relative links and images -> absolute */ -}}
{{- $c = replaceRE `\]\(/([^/)])` (printf "](%s${1}" site.BaseURL) $c -}}

{{- return (trim $c "\n ") -}}
