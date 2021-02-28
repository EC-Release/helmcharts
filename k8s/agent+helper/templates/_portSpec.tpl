{{/* vim: set filetype=mustache: */}}

{{/*
   * Copyright (c) 2020 General Electric Company. All rights reserved.
   *
   * The copyright to the computer software herein is the property of
   * General Electric Company. The software may be used and/or copied only
   * with the written permission of General Electric Company or in accordance
   * with the terms and conditions stipulated in the agreement/contract
   * under which the software has been supplied.
   *
   * author: apolo.yasuda@ge.com
   */}}

{{/*
Generate container port spec for client agent. Need review for gateway usage
*/}}
{{- define "agent.portSpec" -}}
{{- $mode := include "agent.mode" . -}}
{{- $portName := "lpt=" -}}
{{- if or (eq $mode "gateway") (eq $mode "gw:server") (eq $mode "gw:client") -}}
{{- $portName = "gpt=" -}}
{{- end -}}
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains $portName . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
- name: {{ $.portName }}
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate service port spec for agent pods.
*/}}
{{- define "agent.svcPortSpec" -}}
- port: {{ .svcPortNum }}
  targetPort: {{ .portName }}
  protocol: TCP
  name: {{ .svcPortName }}
{{- end -}}

{{/*
Generate container HEALTH port spec for client agent. Need review for gateway usage
*/}}
{{- define "agent.healthPortSpec" -}}
{{- $mode := include "agent.mode" . -}}
{{- $portName := "hca=" -}}
{{- if or (eq $mode "gateway") (eq $mode "gw:server") (eq $mode "gw:client") -}}
{{- $portName = "gpt=" -}}
{{- end -}}
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains $portName . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
- name: {{ $.healthPortName }}
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate service health port spec for agent pods. 
*/}}
{{- define "agent.svcHealthPortSpec" -}}
- port: {{ .svcHealthPortNum }}
  targetPort: {{ .healthPortName }}
  protocol: TCP
  name: {{ .svcHealthPortName }}
{{- end -}}
