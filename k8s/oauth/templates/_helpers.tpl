{{/*
Expand the name of the chart.
*/}}
{{- define "oauth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oauth.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oauth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "oauth.labels" -}}
helm.sh/chart: {{ include "oauth.chart" . }}
{{ include "oauth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oauth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oauth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
run: {{ include "oauth.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oauth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oauth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Specify the oauth internal ingress spec
*/}}
{{- define "oauth.intIngress" -}}
{{- if .Values.global.oauthK8Config.withIntIngress.tls -}}
tls:
{{- range .Values.global.oauthK8Config.withIntIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- range .Values.global.oauthK8Config.withIntIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: oauth
            servicePort: 18090
      {{- end }}
{{- end }}
{{- end -}}

{{/*
Specify the oauth external ingress spec
*/}}
{{- define "oauth.extIngress" -}}
{{- if .Values.global.oauthK8Config.withExtIngress.tls -}}
tls:
{{- range .Values.global.oauthK8Config.withExtIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- range .Values.global.oauthK8Config.withExtIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: oauth
            servicePort: 18090
      {{- end }}
{{- end }}
{{- end -}}

{{/*
Generate service port spec for pods.
*/}}
{{- define "oauth.svcPortSpec" -}}
- port: 18090
  targetPort: auth-prt-name
  protocol: TCP
  name: oauth
{{- end -}}

{{/*
Generate service health port spec for pods.
*/}}
{{- define "oauth.svcHealthPortSpec" -}}
- port: 18091
  targetPort: auth-h-prt-name
  protocol: TCP
  name: auth-svc-h-prt
{{- end -}}

{{/*
Generate container port spec for oauth
*/}}
{{- define "oauth.portSpec" -}}
- name: auth-prt-name
  containerPort: 17990
  protocol: TCP
{{- end -}}


{{/*
Generate container HEALTH port spec for oauth
*/}}
{{- define "oauth.healthPortSpec" -}}
- name: auth-h-prt-name
  containerPort: 17990
  protocol: TCP
{{- end -}}

{{/*
Specify the resource in the targeted cluster, if any
*/}}
{{- define "oauth.podResource" -}}
{{- if .Values.global.oauthK8Config.resources -}}
limits:
  cpu: {{ .Values.global.oauthK8Config.resources.limits.cpu }}
  memory: {{ .Values.global.oauthK8Config.resources.limits.memory }}
requests:
  cpu: {{ .Values.global.oauthK8Config.resources.requests.cpu }}
  memory: {{ .Values.global.oauthK8Config.resources.requests.memory }}
{{- else -}}
{}
{{- end -}}
{{- end -}}