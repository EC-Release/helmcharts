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
{{- $launchCmd := "[]" -}}
{{- $podResource := include "agent.podResource" . -}}
{{- $hasPlugin := include "agent.hasPlugin" . -}}
{{- include "agent.container" (merge (dict "isPlugin" true "contrName" $contrName "releaseTag" $contrReleaseTag "launchCmd" $launchCmd "securityContext" $contrSecurityContext "portName" $portName "healthPortName" $healthPortName "podResource" $podResource "agentRev" $agentRev "binaryURL" $binaryURL "ownerHash" $ownerHash "agtConfig" $agtConfig) .) }}
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
