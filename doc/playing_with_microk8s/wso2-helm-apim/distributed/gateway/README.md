# wso2am-universal-gw

![Version: 4.5.0-3](https://img.shields.io/badge/Version-4.5.0--3-informational?style=flat-square) ![AppVersion: 4.5.0](https://img.shields.io/badge/AppVersion-4.5.0-informational?style=flat-square)

A Helm chart for the deployment of WSO2 API Management Universal Gateway profile

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws.enabled | bool | `false` | If AWS is used as the cloud provider |
| aws.region | string | `""` | AWS region |
| aws.secretsManager.secretIdentifiers.internalKeystorePassword | object | `{"secretKey":"","secretName":""}` | Internal keystore password identifier in secrets manager |
| aws.secretsManager.secretIdentifiers.internalKeystorePassword.secretKey | string | `""` | AWS Secrets Manager secret key |
| aws.secretsManager.secretIdentifiers.internalKeystorePassword.secretName | string | `""` | AWS Secrets Manager secret name |
| aws.secretsManager.secretProviderClass | string | `"wso2am-gw-secret-provider-class"` | AWS Secrets Manager secret provider class name |
| aws.serviceAccountName | string | `""` |  |
| azure.enabled | bool | `false` | If Azure is used as the cloud provider |
| azure.keyVault.activeDirectory.servicePrincipal | object | `{"appId":"","clientSecretName":"","credentialsSecretName":""}` | Service Principal created for transacting with the target Azure Key Vault For advanced details refer to official documentation (https://github.com/Azure/secrets-store-csi-driver-provider-azure/blob/master/docs/service-principal-mode.md) |
| azure.keyVault.activeDirectory.servicePrincipal.appId | string | `""` | Application ID of the service principal used in secret-store-csi |
| azure.keyVault.activeDirectory.servicePrincipal.clientSecretName | string | `""` | Client secret name of the service principal used in secret-store-csi |
| azure.keyVault.activeDirectory.servicePrincipal.credentialsSecretName | string | `""` | Credentials secret name of the service principal used as nodePublisherRef |
| azure.keyVault.activeDirectory.tenantId | string | `""` | Azure Active Directory tenant ID of the target Key Vault |
| azure.keyVault.name | string | `""` | Azure Key vault used for credential management |
| azure.keyVault.resourceManager.resourceGroup | string | `""` | Name of the Azure Resource Group to which the target Azure Key Vault belongs |
| azure.keyVault.resourceManager.subscriptionId | string | `""` | Subscription ID of the target Azure Key Vault |
| azure.keyVault.secretIdentifiers.internalKeystoreKeyPassword | string | `""` | Internal keystore key password identifier in keyvault |
| azure.keyVault.secretIdentifiers.internalKeystorePassword | string | `""` | Internal keystore password identifier in keyvault |
| azure.keyVault.secretProviderClass | string | `"wso2am-gw-secret-provider-class"` | Azure Key vault secret provider class name |
| gcp.enabled | bool | `false` | If GCP is used as the cloud provider |
| gcp.secretsManager | object | `{"projectId":"","secret":{"secretName":"","secretVersion":""},"secretProviderClass":""}` | Secrets Manager configuration parameters |
| gcp.secretsManager.projectId | string | `""` | Project ID |
| gcp.secretsManager.secret.secretName | string | `""` | Name of the secret |
| gcp.secretsManager.secret.secretVersion | string | `""` | Version of the secret  |
| gcp.secretsManager.secretProviderClass | string | `""` | Secret provider class |
| gcp.serviceAccountName | string | `""` | Service Account with access to read secrets |
| kubernetes.configMaps | object | `{"scripts":{"defaultMode":"0407"}}` | Set UNIX permissions over the executable scripts |
| kubernetes.enableAppArmor | bool | `false` | Enable AppArmor profiles for the deployment |
| kubernetes.ingress.gateway.annotations | object | `{"nginx.ingress.kubernetes.io/backend-protocol":"HTTPS","nginx.ingress.kubernetes.io/proxy-buffer-size":"8k","nginx.ingress.kubernetes.io/proxy-buffering":"on"}` | Ingress annotations for Gateway pass-through |
| kubernetes.ingress.gateway.hostname | string | `"gw.wso2.com"` | Ingress hostname for Gateway pass-through |
| kubernetes.ingress.ratelimit.burstLimit | string | `""` | Ingress ratelimit burst limit |
| kubernetes.ingress.ratelimit.enabled | bool | `false` | Ingress rate limit |
| kubernetes.ingress.ratelimit.zoneName | string | `""` | Ingress ratelimit zone name |
| kubernetes.ingress.tlsSecret | string | `""` | Kubernetes secret created for Ingress TLS |
| kubernetes.ingress.websocket.annotations | string | `nil` | Ingress annotations for Websocket |
| kubernetes.ingress.websocket.hostname | string | `"websocket.wso2.com"` | Ingress hostname for Websocket |
| kubernetes.ingress.websub.annotations | string | `nil` | Ingress annotations for Websub |
| kubernetes.ingress.websub.hostname | string | `"websub.wso2.com"` | Ingress hostname for Websub |
| kubernetes.ingressClass | string | `"nginx"` | Ingress class to be used for the ingress resource |
| kubernetes.securityContext.runAsUser | int | `10001` | User ID of the container |
| kubernetes.securityContext.seLinux | object | `{"enabled":false,"level":""}` | SELinux context for the container |
| kubernetes.securityContext.seccompProfile | object | `{"localhostProfile":"","type":"RuntimeDefault"}` | Seccomp profile for the container |
| kubernetes.securityContext.seccompProfile.type | string | `"RuntimeDefault"` | Seccomp profile type(RuntimeDefault, Unconfined or Localhost) |
| wso2.ELKAnalytics | object | `{"enabled":false}` | ELK Analytics Parameters |
| wso2.apim.configurations.adminPassword | string | `""` | Super admin password |
| wso2.apim.configurations.adminUsername | string | `""` | Super admin username |
| wso2.apim.configurations.ai | object | `{"enabled":false,"endpoint":"","token":""}` | APIM AI related configurations |
| wso2.apim.configurations.cache.gateway_token.enabled | bool | `true` | Gateway token cache enabled |
| wso2.apim.configurations.cache.gateway_token.expiryTime | int | `15` | Gateway token cache expiration time in minutes |
| wso2.apim.configurations.cache.jwt_claim.enabled | bool | `true` | Gateway JWT claim cache enabled |
| wso2.apim.configurations.cache.jwt_claim.expiryTime | int | `900` | Gateway JWT claim cache expiration time in seconds |
| wso2.apim.configurations.cache.resource.enabled | bool | `true` | Gateway resource cache enabled |
| wso2.apim.configurations.cache.resource.expiryTime | int | `900` | Gateway resource cache expiration time in seconds |
| wso2.apim.configurations.cors.allowCredentials | bool | `false` | CORS Access-Control-Allow-Credentials |
| wso2.apim.configurations.cors.allowHeaders | list | `["authorization","Access-Control-Allow-Origin","Content-Type","SOAPAction","apikey","Internal-Key"]` | CORS Access-Control-Allow-Headers |
| wso2.apim.configurations.cors.allowMethods | list | `["GET","PUT","POST","DELETE","PATCH","OPTIONS"]` | CORS Access-Control-Allow-Methods |
| wso2.apim.configurations.cors.allowOrigins | list | `["*"]` | CORS Access-Control-Allow-Origin |
| wso2.apim.configurations.cors.enableForWS | bool | `false` | Enable CORS for Websockets |
| wso2.apim.configurations.cors.enabled | bool | `true` | CORS configuration enabled |
| wso2.apim.configurations.databases.jdbc.driver | string | `""` | JDBC driver class name |
| wso2.apim.configurations.databases.shared_db | object | `{"password":"","poolParameters":{"defaultAutoCommit":true,"maxActive":100,"maxWait":60000,"minIdle":5,"testOnBorrow":true,"testWhileIdle":true,"validationInterval":30000},"url":"","username":""}` | APIM SharedDB configurations. This is required for gateway only in a multi-tenancy scenario |
| wso2.apim.configurations.databases.shared_db.password | string | `""` | APIM SharedDB password |
| wso2.apim.configurations.databases.shared_db.poolParameters | object | `{"defaultAutoCommit":true,"maxActive":100,"maxWait":60000,"minIdle":5,"testOnBorrow":true,"testWhileIdle":true,"validationInterval":30000}` | APIM database JDBC pool parameters |
| wso2.apim.configurations.databases.shared_db.url | string | `""` | APIM SharedDB URL |
| wso2.apim.configurations.databases.shared_db.username | string | `""` | APIM SharedDB username |
| wso2.apim.configurations.databases.type | string | `""` | Database type. eg: mysql, oracle, mssql, postgres |
| wso2.apim.configurations.eventhub.enabled | bool | `false` | Event hub (control plane) enabled. This should be enabled if the traffic manager is separated from the control-plane. |
| wso2.apim.configurations.eventhub.servicePort | int | `9443` | Event hub (control plane) service port |
| wso2.apim.configurations.eventhub.serviceUrl | string | `"wso2am-cp-service"` | Event hub (control plane) loadbalancer service url |
| wso2.apim.configurations.eventhub.urls | list | `["wso2am-cp-1-service","wso2am-cp-2-service"]` | Event hub service urls |
| wso2.apim.configurations.iskm.enabled | bool | `false` |  |
| wso2.apim.configurations.iskm.serviceName | string | `""` |  |
| wso2.apim.configurations.jwt.claimDialect | string | `"http://wso2.org/claims"` |  |
| wso2.apim.configurations.jwt.claimsExtractorImpl | string | `"org.wso2.carbon.apimgt.impl.token.DefaultClaimsRetriever"` |  |
| wso2.apim.configurations.jwt.enableUserClaims | string | `"false"` |  |
| wso2.apim.configurations.jwt.enabled | bool | `false` |  |
| wso2.apim.configurations.jwt.encoding | string | `"base64"` |  |
| wso2.apim.configurations.jwt.generatorImpl | string | `"org.wso2.carbon.apimgt.keymgt.token.JWTGenerator"` |  |
| wso2.apim.configurations.jwt.header | string | `"X-JWT-Assertion"` |  |
| wso2.apim.configurations.jwt.signingAlgorithm | string | `"SHA256withRSA"` |  |
| wso2.apim.configurations.km.servicePort | int | `9443` | Key Manager service port |
| wso2.apim.configurations.km.serviceUrl | string | `"wso2am-cp-service"` | Key manager service name if default Resident KM is used |
| wso2.apim.configurations.oauth_config.authHeader | string | `"Authorization"` | OAuth authorization header name |
| wso2.apim.configurations.oauth_config.enableTokenEncryption | bool | `false` | Enable token encryption |
| wso2.apim.configurations.oauth_config.enableTokenHashing | bool | `false` | Enable token hashing |
| wso2.apim.configurations.oauth_config.removeOutboundAuthHeader | bool | `true` | Remove oauth header from outgoing requests |
| wso2.apim.configurations.openTelemetry.enabled | bool | `false` | Open Telemetry enabled |
| wso2.apim.configurations.openTelemetry.hostname | string | `""` | Remote tracer hostname |
| wso2.apim.configurations.openTelemetry.name | string | `""` | Remote tracer name. e.g. jaeger, zipkin, OTLP |
| wso2.apim.configurations.openTelemetry.port | string | `""` | Remote tracer port |
| wso2.apim.configurations.openTracer.enabled | bool | `false` | Open Tracing enabled |
| wso2.apim.configurations.openTracer.name | string | `""` | Remote tracer name. e.g. jaeger, zipkin |
| wso2.apim.configurations.openTracer.properties.hostname | string | `""` | Remote tracer hostname |
| wso2.apim.configurations.openTracer.properties.port | string | `""` | Remote tracer port |
| wso2.apim.configurations.security.jksSecretName | string | `"apim-keystore-secret"` | Kubernetes secret containing the keystores and truststore |
| wso2.apim.configurations.security.keystores.internal.alias | string | `"wso2carbon"` | Internal keystore alias |
| wso2.apim.configurations.security.keystores.internal.enabled | bool | `false` | Internal keystore enabled |
| wso2.apim.configurations.security.keystores.internal.keyPassword | string | `""` | Internal keystore key password |
| wso2.apim.configurations.security.keystores.internal.name | string | `"wso2carbon.jks"` | Internal keystore name |
| wso2.apim.configurations.security.keystores.internal.password | string | `""` | Internal keystore password |
| wso2.apim.configurations.security.keystores.primary.alias | string | `"wso2carbon"` | Primary keystore alias |
| wso2.apim.configurations.security.keystores.primary.enabled | bool | `false` | Primary keystore enabled |
| wso2.apim.configurations.security.keystores.primary.keyPassword | string | `""` | Primary keystore key password |
| wso2.apim.configurations.security.keystores.primary.name | string | `"wso2carbon.jks"` | Primary keystore name |
| wso2.apim.configurations.security.keystores.primary.password | string | `""` | Primary keystore password |
| wso2.apim.configurations.security.keystores.tls.alias | string | `"wso2carbon"` | TLS keystore alias |
| wso2.apim.configurations.security.keystores.tls.enabled | bool | `true` | TLS keystore enabled |
| wso2.apim.configurations.security.keystores.tls.keyPassword | string | `""` | TLS keystore key password |
| wso2.apim.configurations.security.keystores.tls.name | string | `"wso2carbon.jks"` | TLS keystore name |
| wso2.apim.configurations.security.keystores.tls.password | string | `""` | TLS keystore password |
| wso2.apim.configurations.security.truststore.name | string | `"client-truststore.jks"` | Truststore name |
| wso2.apim.configurations.security.truststore.password | string | `""` | Truststore password |
| wso2.apim.configurations.sync_runtime_artifacts.gateway.labels | list | `["Default"]` | Gateway label used to filter out artifact retrieval |
| wso2.apim.configurations.throttling.headerBasedThrottling | bool | `false` | Enable header based throttling |
| wso2.apim.configurations.throttling.jwtClaimBasedThrottling | bool | `false` | Enable JWT claim based throttling |
| wso2.apim.configurations.throttling.portOffset | int | `0` |  |
| wso2.apim.configurations.throttling.queryParamBasedThrottling | bool | `false` | Enable query param based throttling |
| wso2.apim.configurations.throttling.servicePort | int | `9443` | Port of the service URL |
| wso2.apim.configurations.throttling.serviceUrl | string | `"wso2am-cp-service"` | Traffic manager loadbalancer service url for throttling. If the traffic manager is separated from control-plane, all urls should be pointed to traffic-manager ones. |
| wso2.apim.configurations.throttling.unlimitedTier | bool | `true` | Enable unlimited throttling tier |
| wso2.apim.configurations.throttling.urls | list | `["wso2am-cp-1-service","wso2am-cp-2-service"]` | Traffic manager service urls. You only need to define one if the TM is not in HA. |
| wso2.apim.configurations.transactionCounter.enabled | bool | `false` |  |
| wso2.apim.configurations.transactionCounter.serverId | string | `"Gateway1"` |  |
| wso2.apim.configurations.transport.passthru_https.sender.parameters.hostnameVerifier | string | `"AllowAll"` | Hostname verifier. https://apim.docs.wso2.com/en/latest/install-and-setup/setup/security/enabling-hostname-verification/#configuring-hostname-verification |
| wso2.apim.configurations.userStore.properties | object | `{"key":"value"}` | User store properties |
| wso2.apim.configurations.userStore.type | string | `"database_unique_id"` | User store type.  https://apim.docs.wso2.com/en/latest/administer/managing-users-and-roles/managing-user-stores/configure-primary-user-store/configuring-the-primary-user-store/ |
| wso2.apim.log4j2.appenders | string | `""` | Appenders |
| wso2.apim.log4j2.loggers | string | `""` | Console loggers that can be enabled. Allowed values are AUDIT_LOG_CONSOLE, HTTP_ACCESS_CONSOLE, TRANSACTION_CONSOLE, CORRELATION_CONSOLE |
| wso2.apim.mountStartupScript | bool | `false` | Startup script mount status |
| wso2.apim.portOffset | int | `0` | Port Offset for APIM deployment |
| wso2.apim.secureVaultEnabled | bool | `false` | Secure vauld enabled |
| wso2.apim.startupArgs | string | `""` | Startup arguments for APIM |
| wso2.apim.version | string | `"4.5.0"` | APIM version |
| wso2.choreoAnalytics | object | `{"enabled":false,"endpoint":"","onpremKey":""}` | WSO2 Choreo Analytics Parameters If provided, these parameters will be used publish analytics data to Choreo Analytics environment (https://apim.docs.wso2.com/en/latest/observe/api-manager-analytics/configure-analytics/register-for-analytics/). |
| wso2.choreoAnalytics.endpoint | string | `""` | Choreo Analytics cloud service endpoint |
| wso2.choreoAnalytics.onpremKey | string | `""` | On-premise key for Choreo Analytics |
| wso2.deployment.cpuUtilizationPercentage | int | `75` | Target CPU utilization percentage for HPA |
| wso2.deployment.image.digest | string | `""` | Docker image digest |
| wso2.deployment.image.imagePullPolicy | string | `"Always"` | Refer to the Kubernetes documentation on updating images (https://kubernetes.io/docs/concepts/containers/images/#updating-images) |
| wso2.deployment.image.imagePullSecrets | object | `{"enabled":false,"password":"","username":""}` | Container registry credentials. Specify image pull secrets for private registries |
| wso2.deployment.image.registry | string | `""` | Container registry hostname |
| wso2.deployment.image.repository | string | `""` | Azure ACR repository name consisting the image |
| wso2.deployment.lifecycle.preStopHook.sleepSeconds | int | `10` | Number of seconds to sleep before sending SIGTERM to the pod |
| wso2.deployment.livenessProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed |
| wso2.deployment.livenessProbe.initialDelaySeconds | int | `60` | Number of seconds after the container has started before liveness probes are initiated |
| wso2.deployment.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |
| wso2.deployment.maxReplicas | int | `3` | Maximum replicas for HPA |
| wso2.deployment.memoryUtilizationPercentage | int | `75` | Target memory utilization percentage for HPA |
| wso2.deployment.minAvailable | string | `"50%"` | Minimum available pod counts for PDB |
| wso2.deployment.minReplicas | int | `2` | Minimum replicas for HPA |
| wso2.deployment.nodeSelector | string | `nil` | Node selector to deploy pod in selected node. Add label to the node and specify the label here. |
| wso2.deployment.readinessProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed |
| wso2.deployment.readinessProbe.initialDelaySeconds | int | `60` | Number of seconds after the container has started before readiness probes are initiated |
| wso2.deployment.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |
| wso2.deployment.replicas | int | `2` |  |
| wso2.deployment.resources.jvm.memory.xms | string | `"2048m"` | JVM heap memory Xms |
| wso2.deployment.resources.jvm.memory.xmx | string | `"2048m"` | JVM heap memory Xmx |
| wso2.deployment.resources.limits.cpu | string | `"3000m"` | CPU limit for API Manager |
| wso2.deployment.resources.limits.memory | string | `"3Gi"` | Memory limit for API Manager |
| wso2.deployment.resources.requests.cpu | string | `"2000m"` | CPU request for API Manager |
| wso2.deployment.resources.requests.memory | string | `"2Gi"` | Memory request for API Manager |
| wso2.deployment.startupProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed |
| wso2.deployment.startupProbe.initialDelaySeconds | int | `60` | Number of seconds after the container has started before startup probes are initiated |
| wso2.deployment.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |
| wso2.deployment.strategy.rollingUpdate.maxSurge | int | `2` |  |
| wso2.deployment.strategy.rollingUpdate.maxUnavailable | int | `0` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
