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
 function: "agent.container"
 example: https://github.com/EC-Release/helmcharts/blob/v1/k8s/agent/templates/deployment.yaml#L33
 params:
   type: (dict)
   - name: "isPlugin"
     type: boolean
     memo: is the container launched as a plugin?
   - name: "contrName"
     type: string
     memo: unique container name
   - name: "releaseTag"
     type: string
     memo: image release tag. E.g. "v1", "v1beta"
   - name: "launchCmd"
     type: string
     memo: image release tag. E.g. ["echo","hell0"]
   - name: "securityContext"
     type: yaml
     memo: k8-spec container securityContext. See k8s api ref
   - name: "portName"
     type: string
     memo: port name for agent container spec
   - name: "healthPortName"
     type: string
     memo: health port name for agent container spec
   - name: "podResource"
     type: yaml
     memo: k8-spec resource spec. See k8s api ref
   - name: "agentRev"
     type: string
     memo: agent revision. E.g. "v1.hokkaido.212", "v1beta.fukuoka.1728"
   - name: "binaryURL"
     type: string
     memo: a downloadable agent binary in a git format 
   - name: "ownerHash"
     type: string
     memo: the owner's hash for a prompt-free deployment
    - name: "agtConfig"
     type: string
     memo: agent configuration in environment format. Refer to example https://github.com/EC-Release/helmcharts/blob/v1/k8s/example/server%2Btls.env
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
