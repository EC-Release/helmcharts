{{/*
Expand the name of the chart.
*/}}
{{- define "ec-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ec-service.fullname" -}}
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
{{- define "ec-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ec-service.labels" -}}
helm.sh/chart: {{ include "ec-service.chart" . }}
{{ include "ec-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ec-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ec-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
run: {{ include "ec-service.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ec-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ec-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Specify the ec-service internal ingress spec
*/}}
{{- define "ec-service.intIngress" -}}
{{- $fullName := include "ec-service.fullname" . -}}
{{- if .Values.global.ecServiceK8Config.withIngress.tls -}}
tls:
{{- range .Values.global.ecServiceK8Config.withIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- range .Values.global.ecServiceK8Config.withIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: {{ $fullName }}
            servicePort: 80
      {{- end }}
{{- end }}
{{- end -}}


{{/*
Specify the ec-service external ingress spec
*/}}
{{- define "ec-service.extIngress" -}}
{{- $fullName := include "ec-service.fullname" . -}}
{{- if .Values.global.ecServiceK8Config.withExtIngress.tls -}}
tls:
{{- range .Values.global.ecServiceK8Config.withExtIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- range .Values.global.ecServiceK8Config.withExtIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: {{ $fullName }}
            servicePort: 80
      {{- end }}
{{- end }}
{{- end -}}

{{/* Function to get the existence of ConfigMap component for root certs */}}
{{- define "ec-service.isECCertsCMExist" -}}
{{- if (lookup "v1" "ConfigMap" .Release.Namespace .Values.global.ecCertsConfigmapName) }}
{{- print "Exists" }}
{{- else }}
{{- print "Not Exists" }}
{{- end -}}
{{- end -}}

{{/* Function to get the existence of ec secrets component */}}
{{- define "ec-service.isECSecretExist" -}}
{{- if (lookup "v1" "Secret" .Release.Namespace .Values.global.ecSecretName) }}
{{- print "Exists" }}
{{- else }}
{{- print "Not Exists" }}
{{- end -}}
{{- end -}}
