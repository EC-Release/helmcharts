{{/*
Extract the plugin flag setting (-plg) from the agent config
*/}}
{{- define "agent.hasPlugin" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- $a := (. | replace "\"" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- if contains "plg=true" $b -}}
true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Extract the VLAN flag setting (-vln) from the agent config
*/}}
{{- define "agent.hasVLAN" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- $a := (. | replace "\"" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- if contains "vln=true" $b -}}
true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
   * set the tls env var if there does not exist a vln plugin flag
   */}}
{{- define "agent.tlsPluginType" -}}
- name: "plg.typ"
  value: "tls"
{{- end -}}

{{/*
   * set the vln env var if there does not exist a vln plugin flag
   */}}
{{- define "agent.vlnPluginType" -}}
- name: "plg.typ"
  value: "vln"
{{- end -}}

{{/*
Compile the vln port list from the values.yaml and agtConfig
*/}}
{{- define "vln.ports" -}}
{{- $isRPTExists := include "agent.hasRPT" . -}}
{{- if not $isRPTExists -}}
- name: conf.rpt
{{- if .Values.global.agtK8Config.withPlugins.vln.ports -}}
  value: {{ (join "," .Values.global.agtK8Config.withPlugins.vln.ports) | quote }}
{{- else -}}
  value: "0"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the vln ips list from the chart values.yaml
*/}}
{{- define "vln.ips" -}}
{{- if and (.Values.global.agtK8Config.withPlugins.vln.ips) (not .Values.global.agtK8Config.withPlugins.vln.remote) -}}
- name: plg.vln.ips
  value: {{ (join "," .Values.global.agtK8Config.withPlugins.vln.ips) | quote }}
{{- end -}}
{{- end -}}
