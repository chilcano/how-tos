{{/*
# -------------------------------------------------------------------------------------
#
# Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained 
# herein is strictly forbidden, unless permitted by WSO2 in accordance with the 
# WSO2 Commercial License available at https://wso2.com/licenses/eula/3.2
#
# --------------------------------------------------------------------------------------s
*/}}

{{- define "dockerconfigjson" -}}
{{- $auth := printf "%s:%s" .Values.wso2.deployment.image.imagePullSecrets.username .Values.wso2.deployment.image.imagePullSecrets.password | b64enc -}}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .Values.wso2.deployment.image.registry .Values.wso2.deployment.image.imagePullSecrets.username .Values.wso2.deployment.image.imagePullSecrets.password $auth | b64enc -}}
{{- end -}}
