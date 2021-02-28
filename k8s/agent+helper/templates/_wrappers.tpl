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
  image: "ghcr.io/ec-release/oci/agent:{{ .releaseTag }}"
  imagePullPolicy: IfNotPresent
  command: {{ .launchCmd" }} 
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
    {{- toYaml .podResource . | nindent 12 }}
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

{{- define "agent.plugins" -}}
{{- $contrReleaseTag := .Values.global.agtK8Config.releaseTag -}}
{{- $contrSecurityContext := .Values.global.agtK8Config.withPlugins.vln.securityContext -}}
{{- $portName := "agt-prt" -}}
{{- $healthPortName := "agt-h-prt" -}}

{{- $contrName := "" -}}
{{- if and (.Values.global.agtK8Config.withPlugins.vln.enabled) (not .Values.global.agtK8Config.withPlugins.vln.remote) -}}
{{- $contrName = .contrDictContrName -}}
{{- else -}}
{{- $contrName = include "agent.name" . -}}
{{- end -}}

{{- $agentRev := .Values.global.agtK8Config.agentRev -}}
{{- $binaryURL := .Values.global.agtK8Config.binaryURL -}}
{{- $ownerHash := .Values.global.agtK8Config.ownerHash -}}
{{- $agtConfig := .Values.global.agtConfig -}}
{{- $mode := include "agent.mode" . -}}
{{- $launchCmd := printf "[]" -}}
{{- $podResource := include "agent.podResource" . -}}
{{- $hasPlugin := include "agent.hasPlugin" . -}}
{{- include "agent.container" (merge (dict "contrName" $contrName "releaseTag" $contrReleaseTag "launchCmd" $launchCmd "securityContext" $contrSecurityContext "portName" $portName "healthPortName" $healthPortName "podResource" $podResource "agentRev" $agentRev "binaryURL" $binaryURL "ownerHash" $ownerHash "agtConfig" $agtConfig) .) }}
    {{- if (eq $hasPlugin "true") -}}
    {{- if and (.Values.global.agtK8Config.withPlugins.tls.enabled) (or (eq $mode "server") (eq $mode "gw:server")) }}
    {{- include "agent.tlsPluginType" . | nindent 4 }}
    - name: plg.tls.scm
      value: {{ .Values.global.agtK8Config.withPlugins.tls.schema|quote }}
    - name: plg.tls.hst
      value: {{ .Values.global.agtK8Config.withPlugins.tls.hostname|quote }}
    - name: plg.tls.prt
      value: {{ .Values.global.agtK8Config.withPlugins.tls.tlsport|quote }}
    - name: plg.tls.pxy
      value: {{ .Values.global.agtK8Config.withPlugins.tls.proxy|quote }}
    - name: plg.tls.lpt
      value: {{ .Values.global.agtK8Config.withPlugins.tls.port|quote }}
    {{- include "vln.ports" . | nindent 4 -}}
    {{- else if and (.Values.global.agtK8Config.withPlugins.vln.enabled) (or (eq $mode "client") (eq $mode "gw:client")) }}
    {{- include "agent.vlnPluginType" . | nindent 4 }}
    {{- include "vln.ports" . | nindent 4 }}
    {{- include "vln.ips" . | nindent 4 }}
    {{- end -}}
    {{- end -}}
{{- end -}}
