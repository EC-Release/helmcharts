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
   
{{- define "agent.container" -}}
- name: {{ .contrName|quote }}
  {{ if not (.isPlugin) }}
  image: "ghcr.io/ec-release/oci/agent:{{ .releaseTag }}"
  {{- else -}}
  image: "ghcr.io/ec-release/oci/plugins:{{ .releaseTag }}"
  {{ end }}
  imagePullPolicy: IfNotPresent
  command: {{ .launchCmd }} 
  securityContext:
    {{- toYaml .securityContext | nindent 4 }}
  ports:
    {{- include "agent.portSpec" (merge (dict "portName" .portName) .) | nindent 4 }}
    {{- include "agent.healthPortSpec" (merge (dict "healthPortName" .healthPortName) .) | nindent 4 }}
  livenessProbe:
    httpGet:
      path: /health
      port: {{ .healthPortName }}
  readinessProbe:
    httpGet:
      path: /health
      port: {{ .healthPortName }}
  resources:
    {{- .podResource | nindent 4 }}
  env:
    - name: AGENT_REV
      value: {{ .agentRev|quote }}
    - name: AGENT_BIN_URL
      value: {{ .binaryURL|quote }}
    - name: EC_PPS
      value: {{ .ownerHash|quote }}
    {{- range (split "\n" .agtConfig) }}
    {{- $a := splitn "=" 2 . }}
    {{- if and (not (eq $a._1 "")) ($a._1) }}
    - name: {{ $a._0|quote }}
      value: {{ $a._1|quote }}
    {{- end }}
    {{- end -}}
{{- end -}}

