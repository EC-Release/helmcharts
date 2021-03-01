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
Extract the agent mode from the agent config
*/}}
{{- define "agent.mode" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- if contains "mod=" . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
{{- (split "=" $c )._1 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Extract the Remote Port List flag setting (-rpt) from the agent config
*/}}
{{- define "agent.hasRPT" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- if contains "rpt=" . -}}
true
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Specify agent launch command based on the revision from the global variable "releasetag"
*/}}
{{- define "agent.launchCmd" -}}
{{- if or (eq .Values.global.agtK8Config.releaseTag "v1.1beta") (eq .Values.global.agtK8Config.releaseTag "v1.1") -}}
["./agent","env"]
{{- else -}}
[]
{{- end -}}
{{- end -}}