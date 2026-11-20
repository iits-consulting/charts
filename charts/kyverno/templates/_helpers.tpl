{{- /* Kyverno wildcard list (`*` any characters, `?` one character) to one anchored RE2 expression */ -}}
{{- define "kyverno.globToRegex" -}}
  {{- $parts := list -}}
  {{- range . -}}
    {{- $glob := toString . -}}
    {{- if or (contains "'" $glob) (contains "\n" $glob) -}}
      {{- fail (printf "wildcard %q must not contain quotes or newlines" $glob) -}}
    {{- end -}}
    {{- $parts = append $parts (regexQuoteMeta $glob | replace "\\*" ".*" | replace "\\?" ".") -}}
  {{- end -}}
  {{- printf "^(?:%s)$" (join "|" $parts) -}}
{{- end -}}

{{- /* `Enforce` or `Audit` from a case insensitive validationAction (`Deny` is accepted for `Enforce`) */ -}}
{{- define "kyverno.validationAction" -}}
  {{- $action := (. | default "Enforce" | toString | lower) -}}
  {{- if or (eq $action "enforce") (eq $action "deny") -}}Enforce
  {{- else if eq $action "audit" -}}Audit
  {{- else -}}
    {{- fail (printf "validationAction must be Enforce or Audit, got %q" $action) -}}
  {{- end -}}
{{- end -}}

{{- /* The CEL validationActions item (`Deny` or `Audit`) for a validationAction value */ -}}
{{- define "kyverno.validationActions" -}}
- {{ ternary "Deny" "Audit" (eq (include "kyverno.validationAction" .) "Enforce") }}
{{- end -}}

{{- /* The policy failurePolicy, `Fail` unless set */ -}}
{{- define "kyverno.failurePolicy" -}}
{{ .failurePolicy | default "Fail" }}
{{- end -}}

{{- /* matchConditions list item skipping the given namespace wildcards. Call with the list. */ -}}
{{- define "kyverno.excludeNamespacesCondition" -}}
- name: exclude-namespaces
  expression: >-
    !object.metadata.?namespace.orValue("").matches(r'{{ include "kyverno.globToRegex" . }}')
{{- end }}

{{- /* matchConditions list item matching only the given namespace wildcards. Call with the list. */ -}}
{{- define "kyverno.targetNamespacesCondition" -}}
- name: target-namespaces
  expression: >-
    object.metadata.?namespace.orValue("").matches(r'{{ include "kyverno.globToRegex" . }}')
{{- end }}

{{- /* matchConditions list item skipping Ingresses by name and namespace wildcards (tpl rendered, for example with .Release.Namespace). Call with a dict `root` and `list`. */ -}}
{{- define "kyverno.excludeIngressesCondition" -}}
- name: exclude-ingresses
  expression: >-
    !(
    {{- range $i, $ingress := .list }}
    {{ if $i }}|| {{ end }}(object.metadata.name.matches(r'{{ include "kyverno.globToRegex" (list (tpl $ingress.name $.root)) }}') &&
    object.metadata.?namespace.orValue("").matches(r'{{ include "kyverno.globToRegex" (list (tpl $ingress.namespace $.root)) }}'))
    {{- end }}
    )
{{- end }}

{{- /* matchConditions items of the Ingress policies. Call with a dict `root` and `values`. */ -}}
{{- define "kyverno.ingressMatchConditions" -}}
  {{- $conditions := list -}}
  {{- if .values.excludeNamespaces -}}
    {{- $conditions = append $conditions (include "kyverno.excludeNamespacesCondition" .values.excludeNamespaces) -}}
  {{- end -}}
  {{- if .values.excludeIngresses -}}
    {{- $conditions = append $conditions (include "kyverno.excludeIngressesCondition" (dict "root" .root "list" .values.excludeIngresses)) -}}
  {{- end -}}
  {{- join "\n" $conditions -}}
{{- end }}

{{- /* Every pull secret as a JSON list of {name, namespaces, selector, clone}, use with fromJsonArray. Order:
       existingSecretRef, `pull-secret-<key>` of secrets, injectOnly. `selector` is the normalized namespaceSelector,
       null if unset. `clone` is the {policyName, namespace} of the source, null for injectOnly. */ -}}
{{- define "kyverno.pullSecrets" -}}
  {{- $values := .Values.autoInjectDockerPullSecrets -}}
  {{- $all := list -}}
  {{- range $values.existingSecretRef | default list -}}
    {{- if .name -}}
      {{- $clone := dict "policyName" (printf "auto-create-docker-%s" .name) "namespace" (.namespace | default $.Release.Namespace) -}}
      {{- $all = append $all (dict "name" .name "namespaces" (.namespaces | default list) "selector" (include "kyverno.labelSelector" .namespaceSelector | fromJson) "clone" $clone) -}}
    {{- end -}}
  {{- end -}}
  {{- range $key, $secret := $values.secrets | default dict -}}
    {{- $clone := dict "policyName" (printf "auto-create-docker-pull-secret-%s" $key) "namespace" $.Release.Namespace -}}
    {{- $all = append $all (dict "name" (printf "pull-secret-%s" $key) "namespaces" ($secret.namespaces | default list) "selector" (include "kyverno.labelSelector" $secret.namespaceSelector | fromJson) "clone" $clone) -}}
  {{- end -}}
  {{- range $values.injectOnly | default list -}}
    {{- $all = append $all (dict "name" .name "namespaces" (.namespaces | default list) "selector" (include "kyverno.labelSelector" .namespaceSelector | fromJson) "clone" nil) -}}
  {{- end -}}
  {{- toJson $all -}}
{{- end }}

{{- /* A label selector as JSON with `matchLabels` and `matchExpressions` (each with `values`) always set, `{}` if
       empty. Use with fromJson, which turns `{}` into an empty dict. */ -}}
{{- define "kyverno.labelSelector" -}}
  {{- if or (.matchLabels | default dict) (.matchExpressions | default list) -}}
    {{- $expressions := list -}}
    {{- range .matchExpressions | default list -}}
      {{- $expressions = append $expressions (dict "key" .key "operator" .operator "values" (.values | default list)) -}}
    {{- end -}}
    {{- dict "matchLabels" (.matchLabels | default dict) "matchExpressions" $expressions | toJson -}}
  {{- else -}}
    {}
  {{- end -}}
{{- end }}

{{- /* CEL that is true if the labels match a normalized selector (see kyverno.labelSelector). Call with a dict
       `selector` and `labels` (a CEL map expression). NotIn and DoesNotExist match a missing label. */ -}}
{{- define "kyverno.labelSelectorMatches" -}}
  {{- $labels := .labels -}}
  {{- $terms := list -}}
  {{- range $key, $value := .selector.matchLabels -}}
    {{- $terms = append $terms (printf "(%s in %s && %s[%s] == %s)" (toJson $key) $labels $labels (toJson $key) (toJson (toString $value))) -}}
  {{- end -}}
  {{- range .selector.matchExpressions -}}
    {{- $has := printf "%s in %s" (toJson .key) $labels -}}
    {{- $in := printf "(%s && %s[%s] in %s)" $has $labels (toJson .key) (toJson .values) -}}
    {{- if eq .operator "In" -}}{{- $terms = append $terms $in -}}
    {{- else if eq .operator "NotIn" -}}{{- $terms = append $terms (printf "!%s" $in) -}}
    {{- else if eq .operator "Exists" -}}{{- $terms = append $terms (printf "(%s)" $has) -}}
    {{- else -}}{{- $terms = append $terms (printf "!(%s)" $has) -}}
    {{- end -}}
  {{- end -}}
  {{- join " && " $terms -}}
{{- end }}

{{- /* Names of all pull secrets as a JSON list, use with fromJsonArray */ -}}
{{- define "kyverno.pullSecretNames" -}}
  {{- $names := list -}}
  {{- range include "kyverno.pullSecrets" . | fromJsonArray -}}
    {{- $names = append $names .name -}}
  {{- end -}}
  {{- toJson $names -}}
{{- end }}

{{- /* Base64 dockerconfigjson of one entry of autoInjectDockerPullSecrets.secrets */ -}}
{{- define "kyverno.dockerconfigjson" -}}
  {{- $auth := printf "%s:%s" .username .password | b64enc -}}
  {{- dict "auths" (dict .registryUrl (dict "auth" $auth)) | toJson | b64enc -}}
{{- end }}

{{- /* Labels of every policy object created by the chart. Call with the root context. */ -}}
{{- define "kyverno.policyLabels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: kyverno
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
