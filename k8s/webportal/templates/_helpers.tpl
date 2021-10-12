{{/*
Expand the name of the chart.
*/}}
{{- define "webportal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webportal.fullname" -}}
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
{{- define "webportal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webportal.labels" -}}
helm.sh/chart: {{ include "webportal.chart" . }}
{{ include "webportal.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "webportal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webportal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
run: {{ include "webportal.fullname" . }}
{{- end }}

{{/*
Specify the webportal internal ingress spec
*/}}
{{- define "webportal.intIngress" -}}
{{- if .Values.global.webportalK8Config.withIngress.tls -}}
tls:
{{- range .Values.global.webportalK8Config.withIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- range .Values.global.webportalK8Config.withIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: {{ $.Release.Name }}
            servicePort: 18090
      {{- end }}
{{- end }}
{{- end -}}


{{/*
Specify the webportal external ingress spec
*/}}
{{- define "webportal.extIngress" -}}
{{- if .Values.global.webportalK8Config.withExtIngress.tls -}}
tls:
{{- range .Values.global.webportalK8Config.withExtIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- range .Values.global.webportalK8Config.withExtIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: {{ $.Release.Name }}
            servicePort: 18090
      {{- end }}
{{- end }}
{{- end -}}


{{/*
Generate service port spec for pods.
*/}}
{{- define "webportal.svcPortSpec" -}}
- port: 18090
  targetPort: webui-prt-name
  protocol: TCP
  name: webportal
{{- end -}}

{{/*
Generate service health port spec for pods.
*/}}
{{- define "webportal.svcHealthPortSpec" -}}
- port: 18091
  targetPort: web-h-prt-name
  protocol: TCP
  name: webui-svc-h-prt
{{- end -}}

{{/*
Generate container port spec for oauth
*/}}
{{- define "webportal.portSpec" -}}
- name: webui-prt-name
  containerPort: 17990
  protocol: TCP
{{- end -}}


{{/*
Generate container HEALTH port spec for oauth
*/}}
{{- define "webportal.healthPortSpec" -}}
- name: web-h-prt-name
  containerPort: 17990
  protocol: TCP
{{- end -}}