{{/*
[01] Expand the name of the chart.
*/}}
{{- define "sqlserver.chartname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
[02] Expand the name of the app components
*/}}
{{- define "sqlserver.name" -}}
{{- default .Values.app.name .Values.nameOverride | trunc 63 }}
{{- end }}

{{/*
[03] Get the "application" prefix for componets
*/}}
{{- define "sqlserver.nameWithSuffix" -}}
{{- $ctx := .context -}}
{{- $suffix := .suffix | default "" -}}
{{- $appName := include "sqlserver.name" $ctx }}

{{- if $suffix -}}
{{- printf "%s-%s" $appName .suffix |trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- default $appName | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
[04] Get the "version" application
*/}}
{{- define "sqlserver.appversion" -}}
{{- default .Values.app.version .Chart.Version | replace "+" "_" | quote | trunc 63 }}
{{- end }}

{{/*
[05] Create chart name and version as used by the chart label.
*/}}
{{- define "sqlserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 }}
{{- end }}


{{/*
[06] Plural Selector labels to use with "matchLabels"
*/}}
{{- define "sqlserver.selectorLabels" -}}
application: {{ include "sqlserver.name" . }}
app: {{ include "sqlserver.name" . }}
app.kubernetes.io/name: {{ include "sqlserver.name" . }}
{{- end }}

{{/*
[07] Singular Selector labels to use with "matchLabels"
*/}}
{{- define "sqlserver.selectorLabel" -}}
app.kubernetes.io/name: {{ include "sqlserver.name" . }}
{{- end }}

{{/*
[08] Commons Labels
*/}}
{{- define "sqlserver.labels" -}}
helm.sh/chart: {{ include "sqlserver.name" . }}
version: {{ include "sqlserver.appversion" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ include "sqlserver.appversion" . }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime:  {{ .Values.app.name }}
{{ include "sqlserver.selectorLabels" . }}
{{- end }}

{{/*
[09] Custom Project Annotations
*/}}
{{- define "sqlserver.customProjectAnnotations" -}}
  {{- $version := (include "sqlserver.appversion" . | trimPrefix "\"" | trimSuffix "\"" ) -}}
  {{- $annotations := .Values.baseProjectAnnotations | default (dict) -}}
  {{- $annotations := set $annotations "app.kubernetes.io/version" $version -}}
  {{- $annotations := set $annotations "meta.helm.sh/chart"    .Chart.Name -}}
  {{- $annotations := set $annotations "meta.helm.sh/release"   .Release.Name -}}
  {{- $annotations := set $annotations "meta.helm.sh/revision"   (.Release.Revision | toString ) -}}
  {{- $annotations := set $annotations "meta.helm.sh/managed-by" .Release.Service -}}
{{- toYaml $annotations -}}
{{- end -}}
