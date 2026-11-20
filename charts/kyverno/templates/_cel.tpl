{{- /* CEL variable `images`: all images of containers, initContainers and ephemeralContainers of a Pod */ -}}
{{- define "kyverno.imagesVariable" -}}
- name: images
  expression: >-
    object.spec.containers.map(c, c.image) +
    object.spec.?initContainers.orValue([]).map(c, c.image) +
    object.spec.?ephemeralContainers.orValue([]).map(c, c.image)
{{- end }}

{{- /* Mutation expression applying `variables.containers` and `variables.<init>`. `pod` is an optional Pod level fragment ending in a comma. initContainers are only written when the Pod has some, so Pods without them stay untouched. */ -}}
{{- define "kyverno.applyContainers" -}}
has(object.spec.initContainers)
? Object{spec: Object.spec{ {{ .pod }} containers: variables.containers, initContainers: variables.{{ .init }}}}
: Object{spec: Object.spec{ {{ .pod }} containers: variables.containers}}
{{- end }}

{{- /* CEL variables `containers` and `initContainers` setting `image` to the CEL expression `image` (in terms of `c.image`) */ -}}
{{- define "kyverno.imageVariables" -}}
- name: containers
  expression: >-
    object.spec.containers.map(c, Object.spec.containers{name: c.name, image: {{ .image }}})
- name: initContainers
  expression: >-
    object.spec.?initContainers.orValue([]).map(c, Object.spec.initContainers{name: c.name, image: {{ .image }}})
{{- end }}

{{- /* CEL for prepended image references, expects `variables.registry` and, when `excluded` is set, `variables.excluded`. Images without a registry (first path segment without `.` or `:`) are Docker Hub images (`nginx` is `docker.io/library/nginx`). */ -}}
{{- define "kyverno.prependImage" -}}
c.image.startsWith(variables.registry + '/') ? c.image :
{{ if .excluded }}c.image.matches(variables.excluded) ? c.image :
{{ end -}}
variables.registry + '/' + (c.image.matches(r'^([^/]*[.:][^/]*|localhost)/.*') ? c.image : (c.image.contains('/') ? 'docker.io/' : 'docker.io/library/') + c.image)
{{- end }}

{{- /* CEL for replaced image references, expects `variables.target`, `variables.pattern` and, when `excluded` is set, `variables.excluded`. */ -}}
{{- define "kyverno.replaceImage" -}}
c.image.startsWith(variables.target + '/') ? c.image :
{{ if .excluded }}c.image.matches(variables.excluded) ? c.image :
{{ end -}}
regex.replace(c.image, variables.pattern, variables.target + r'/\1')
{{- end }}

{{- /* Pod level fields written back by the apply configuration, user values always win */ -}}
{{- define "kyverno.podSecurityContext" -}}
securityContext: Object.spec.securityContext{
runAsNonRoot: object.spec.?securityContext.?runAsNonRoot.orValue(true),
{{ if not (kindIs "invalid" .runAsUser) }}runAsUser: object.spec.?securityContext.?runAsUser.orValue({{ .runAsUser | int64 }}),
{{ end -}}
{{ if not (kindIs "invalid" .runAsGroup) }}runAsGroup: object.spec.?securityContext.?runAsGroup.orValue({{ .runAsGroup | int64 }}),
{{ end -}}
seccompProfile: Object.spec.securityContext.seccompProfile{
type: object.spec.?securityContext.?seccompProfile.?type.orValue("RuntimeDefault")}},
{{- end }}

{{- /* Container level fields for the list `.field` (containers or initContainers) */ -}}
{{- define "kyverno.containerSecurityContext" -}}
Object.spec.{{ .field }}.securityContext{
allowPrivilegeEscalation: c.?securityContext.?allowPrivilegeEscalation.orValue(false),
{{ if .readOnlyRootFilesystem }}readOnlyRootFilesystem: c.?securityContext.?readOnlyRootFilesystem.orValue(true),
{{ end -}}
privileged: c.?securityContext.?privileged.orValue(false)}
{{- end }}

{{- /* JSONPatch list adding `capabilities.drop: [ALL]` where the container has no capabilities or no drop list. `.list` is the CEL list. */ -}}
{{- define "kyverno.dropAllPatches" -}}
lists.range(size({{ .list }}))
.filter(i, !has({{ .list }}[i].securityContext) || !has({{ .list }}[i].securityContext.capabilities))
.map(i, JSONPatch{op: "add", path: "/spec/{{ .field }}/" + string(i) + "/securityContext/capabilities", value: {"drop": ["ALL"]}})
+ lists.range(size({{ .list }}))
.filter(i, has({{ .list }}[i].securityContext) && has({{ .list }}[i].securityContext.capabilities) && !has({{ .list }}[i].securityContext.capabilities.drop))
.map(i, JSONPatch{op: "add", path: "/spec/{{ .field }}/" + string(i) + "/securityContext/capabilities/drop", value: ["ALL"]})
{{- end }}
