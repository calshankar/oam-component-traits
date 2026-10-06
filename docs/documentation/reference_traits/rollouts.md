---
title:  Rollouts
---

## Description

Rollouts component for Argo Rollouts, a Kubernetes controller and set of CRDs that provide advanced deployment capabilities such as blue-green and canary deployments.

## Underlying Kubernetes Resources

- rollouts.argoproj.io

## Specification


 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 annotations | Specify the annotations in the workload. | map[string]string | false |  
 image | Which image would you like to use for your service. | string | true |  
 imagePullPolicy | Specify image pull policy for your service. | "Always" or "Never" or "IfNotPresent" | false |  
 imagePullSecrets | Specify image pull secrets for your service. | []string | false |  
 ports | Which ports do you want customer traffic sent to, defaults to 80. | [[]ports](#ports) | false |  
 prometheusPort | *IMPORTANT* Specify the prometheus port for discoverying and exposing metrics. | int | false |  
 prometheusPath | *IMPORTANT* Specify the prometheus patch for discoverying and exposing metrics. Only applies if prometheusPort is defined. | string | false | /metrics 
 headlessService | Set to true if you want to create a headlesService additionally to the service created via exposeType. | bool | false | false 
 cmd | Commands to run in the container. | []string | false |  
 args | Arguments to the cmd. | []string | false |  
 tolerations | Specify the tolerations to add to the pod spec. | [[]tolerations](#tolerations) | false |  
 env | Define arguments by using environment variables. | [[]env](#env) | false |  
 cpuLimit | Number of CPU units the service is limited to, e.g. `0.5` (0.5 CPU core), `100m` (100 milli CPU core). | string | false |  
 memoryLimit | The memory limit required for the sidecar container, e.g. `512Mi`. | string | false |  
 cpuRequest | Number of CPU units to request for the sidecar, e.g. `0.5` (0.5 CPU core), `100m` (100 milli CPU core). | string | false |  
 memoryRequest | The memory resource to request for the sidecar container, e.g. `512Mi`. | string | false |  
 volumeMounts | Speecify pvc, configmap, secret volumes. | [volumeMounts](#volumemounts) | false |  
 livenessProbe | Instructions for assessing whether the container is alive. | [livenessProbe](#livenessprobe) | false |  
 readinessProbe | Instructions for assessing whether the container is in a suitable state to serve traffic. | [readinessProbe](#readinessprobe) | false |  
 startupProbe | indicates whether the application within the container is started. All other probes are disabled if a startup probe is provided, until it succeeds. | [startupProbe](#startupprobe) | false |  
 hostAliases | Specify the hostAliases to add. | [[]hostAliases](#hostaliases) | false |  
 replicas | The Number of desired pods(Defaults to 3). | int | false | 3 
 labels | Label selector for pods matching Stable ReplicaSets. | map[string]string | false |  
 minReadySeconds | Minimum seconds a pod should be ready before considered available(defaults to 30 seconds). | int | false | 30 
 paused | If set to true, the rollout will not be started until it is manually resumed from (defaults to false). | bool | false | false 
 progressDeadlineSeconds | The maximum time in seconds in which a rollout must make progress during an update, before it is considered to be failed(defaults to 600 seconds). | int | false | 600 
 revisionHistoryLimit | Limit on the number of ReplicaSets that can be stored for rollback(defaults to 3). | int | false | 3 
 rollbackRevision | The number of revisions to keep for rollback. | int | false | 3 
 limitAnalysisRuns |  | [limitAnalysisRuns](#limitanalysisruns) | false |  
 strategy |  | [strategy](#strategy) | false |  
 ingress |  | [ingress](#ingress) | true |  


#### ports

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 port | Number of port to expose on the pod's IP address. | int | true |  
 targetPort | Number of port in the container that has to be exposed. Usually port=targetPort. | int | false |  
 name | Name of the port. | string | false |  
 protocol | Protocol for port. Must be UDP, TCP, or SCTP. | "TCP" or "UDP" or "SCTP" | false | TCP 
 expose | Specify if the port should be exposed. | bool | false | false 


#### tolerations

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 key |  | string | true |  
 operator |  | "Equal" or "Exists" | false | Equal 
 value |  | string | false |  
 effect |  | "NoSchedule" or "PreferNoSchedule" or "NoExecute" | false |  
 tolerationSeconds |  | int | false |  


#### env

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | Environment variable name. | string | true |  
 value | The value of the environment variable. | string | false |  
 valueFrom | Specifies a source the value of this var should come from. | [valueFrom](#valuefrom) | false |  


##### valueFrom

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 secretKeyRef | Selects a key of a secret in the pod's namespace. | [secretKeyRef](#secretkeyref) | false |  
 configMapKeyRef | Selects a key of a config map in the pod's namespace. | [configMapKeyRef](#configmapkeyref) | false |  


##### secretKeyRef

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | The name of the secret in the pod's namespace to select from. | string | true |  
 key | The key of the secret to select from. Must be a valid secret key. | string | true |  


##### configMapKeyRef

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | The name of the config map in the pod's namespace to select from. | string | true |  
 key | The key of the config map to select from. Must be a valid secret key. | string | true |  


#### volumeMounts

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 pvc | Mount PVC type volume. | [[]pvc](#pvc) | false |  
 configMap | Mount ConfigMap type volume. | [[]configMap](#configmap) | false |  
 secret | Mount Secret type volume. | [[]secret](#secret) | false |  
 emptyDir | Mount EmptyDir type volume. | [[]emptyDir](#emptydir) | false |  
 hostPath | Mount HostPath type volume. | [[]hostPath](#hostpath) | false |  


##### pvc

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 mountPath |  | string | true |  
 claimName | The name of the PVC. | string | true |  


##### configMap

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 mountPath |  | string | true |  
 defaultMode |  | int | false | 420 
 cmName |  | string | true |  
 items |  | [[]items](#items) | false |  


##### items

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 key |  | string | true |  
 path |  | string | true |  
 mode |  | int | false | 511 


##### secret

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 mountPath |  | string | true |  
 defaultMode |  | int | false | 420 
 secretName |  | string | true |  
 items |  | [[]items](#items) | false |  


##### items

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 key |  | string | true |  
 path |  | string | true |  
 mode |  | int | false | 511 


##### emptyDir

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 mountPath |  | string | true |  
 medium |  | "" or "Memory" | false | empty 


##### hostPath

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 mountPath |  | string | true |  
 path |  | string | true |  


#### livenessProbe

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 exec | Instructions for assessing container health by executing a command. Either this attribute or the httpGet attribute or the tcpSocket attribute MUST be specified. This attribute is mutually exclusive with both the httpGet attribute and the tcpSocket attribute. | [exec](#exec) | false |  
 httpGet | Instructions for assessing container health by executing an HTTP GET request. Either this attribute or the exec attribute or the tcpSocket attribute MUST be specified. This attribute is mutually exclusive with both the exec attribute and the tcpSocket attribute. | [httpGet](#httpget) | false |  
 tcpSocket | Instructions for assessing container health by probing a TCP socket. Either this attribute or the exec attribute or the httpGet attribute MUST be specified. This attribute is mutually exclusive with both the exec attribute and the httpGet attribute. | [tcpSocket](#tcpsocket) | false |  
 initialDelaySeconds | Number of seconds after the container is started before the first probe is initiated. | int | false | 0 
 periodSeconds | How often, in seconds, to execute the probe. | int | false | 10 
 timeoutSeconds | Number of seconds after which the probe times out. | int | false | 1 
 successThreshold | Minimum consecutive successes for the probe to be considered successful after having failed. | int | false | 1 
 failureThreshold | Number of consecutive failures required to determine the container is not alive (liveness probe) or not ready (readiness probe). | int | false | 3 


##### exec

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 command | A command to be executed inside the container to assess its health. Each space delimited token of the command is a separate array element. Commands exiting 0 are considered to be successful probes, whilst all other exit codes are considered failures. | []string | true |  


##### httpGet

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 path | The endpoint, relative to the port, to which the HTTP GET request should be directed. | string | true |  
 port | The TCP socket within the container to which the HTTP GET request should be directed. | int | true |  
 host |  | string | false |  
 scheme |  | string | false | HTTP 
 httpHeaders |  | [[]httpHeaders](#httpheaders) | false |  


##### httpHeaders

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 value |  | string | true |  


##### tcpSocket

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 port | The TCP socket within the container that should be probed to assess container health. | int | true |  


#### readinessProbe

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 exec | Instructions for assessing container health by executing a command. Either this attribute or the httpGet attribute or the tcpSocket attribute MUST be specified. This attribute is mutually exclusive with both the httpGet attribute and the tcpSocket attribute. | [exec](#exec) | false |  
 httpGet | Instructions for assessing container health by executing an HTTP GET request. Either this attribute or the exec attribute or the tcpSocket attribute MUST be specified. This attribute is mutually exclusive with both the exec attribute and the tcpSocket attribute. | [httpGet](#httpget) | false |  
 tcpSocket | Instructions for assessing container health by probing a TCP socket. Either this attribute or the exec attribute or the httpGet attribute MUST be specified. This attribute is mutually exclusive with both the exec attribute and the httpGet attribute. | [tcpSocket](#tcpsocket) | false |  
 initialDelaySeconds | Number of seconds after the container is started before the first probe is initiated. | int | false | 0 
 periodSeconds | How often, in seconds, to execute the probe. | int | false | 10 
 timeoutSeconds | Number of seconds after which the probe times out. | int | false | 1 
 successThreshold | Minimum consecutive successes for the probe to be considered successful after having failed. | int | false | 1 
 failureThreshold | Number of consecutive failures required to determine the container is not alive (liveness probe) or not ready (readiness probe). | int | false | 3 


##### exec

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 command | A command to be executed inside the container to assess its health. Each space delimited token of the command is a separate array element. Commands exiting 0 are considered to be successful probes, whilst all other exit codes are considered failures. | []string | true |  


##### httpGet

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 path | The endpoint, relative to the port, to which the HTTP GET request should be directed. | string | true |  
 port | The TCP socket within the container to which the HTTP GET request should be directed. | int | true |  
 host |  | string | false |  
 scheme |  | string | false | HTTP 
 httpHeaders |  | [[]httpHeaders](#httpheaders) | false |  


##### httpHeaders

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 value |  | string | true |  


##### tcpSocket

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 port | The TCP socket within the container that should be probed to assess container health. | int | true |  


#### startupProbe

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 exec | Instructions for assessing container health by executing a command. Either this attribute or the httpGet attribute or the tcpSocket attribute MUST be specified. This attribute is mutually exclusive with both the httpGet attribute and the tcpSocket attribute. | [exec](#exec) | false |  
 httpGet | Instructions for assessing container health by executing an HTTP GET request. Either this attribute or the exec attribute or the tcpSocket attribute MUST be specified. This attribute is mutually exclusive with both the exec attribute and the tcpSocket attribute. | [httpGet](#httpget) | false |  
 tcpSocket | Instructions for assessing container health by probing a TCP socket. Either this attribute or the exec attribute or the httpGet attribute MUST be specified. This attribute is mutually exclusive with both the exec attribute and the httpGet attribute. | [tcpSocket](#tcpsocket) | false |  
 initialDelaySeconds | Number of seconds after the container is started before the first probe is initiated. | int | false | 0 
 periodSeconds | How often, in seconds, to execute the probe. | int | false | 10 
 timeoutSeconds | Number of seconds after which the probe times out. | int | false | 1 
 successThreshold | Minimum consecutive successes for the probe to be considered successful after having failed. | int | false | 1 
 failureThreshold | Number of consecutive failures required to determine the container is not alive (liveness probe) or not ready (readiness probe). | int | false | 3 


##### exec

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 command | A command to be executed inside the container to assess its health. Each space delimited token of the command is a separate array element. Commands exiting 0 are considered to be successful probes, whilst all other exit codes are considered failures. | []string | true |  


##### httpGet

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 path | The endpoint, relative to the port, to which the HTTP GET request should be directed. | string | true |  
 port | The TCP socket within the container to which the HTTP GET request should be directed. | int | true |  
 host |  | string | false |  
 scheme |  | string | false | HTTP 
 httpHeaders |  | [[]httpHeaders](#httpheaders) | false |  


##### httpHeaders

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 value |  | string | true |  


##### tcpSocket

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 port | The TCP socket within the container that should be probed to assess container health. | int | true |  


#### hostAliases

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 ip |  | string | true |  
 hostnames |  | []string | true |  


#### limitAnalysisRuns

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 successfulRunHistoryLimit | Success rate required to consider the analysis successful. | int | false |  
 unsuccessfulRunHistoryLimit | Number of failed runs before considering the analysis as failed. | int | false |  


#### strategy

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 type | Type of deployment strategy, either Canary or BlueGreen. | "Canary" or "BlueGreen" | true |  
 canary |  | [canary](#canary) | false |  
 blueGreen |  | [blueGreen](#bluegreen) | false |  


##### canary

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 abortScaleDownDelaySeconds | The delay in seconds before scaling down the previous ReplicaSet when the rollout is aborted. | int | false | 30 
 analysis |  | [analysis](#analysis) | false |  
 canaryService | The unique service name which the Rollouts controller will update to select canary pods. Label identifier "role: canary" is added to the service object ** Mandatory Parameter **. | string | false |  
 stableService | The unique name of the service that points to the stable deployment. Label identifier "role: stable" is added to the service object ** Mandatory Parameter **. | string | false |  
 canaryMetadata | Metadata which will be attached to the Canary pods. | [canaryMetadata](#canarymetadata) | false |  
 stableMetadata | Metadata which will be attached to the Stable pods. | [stableMetadata](#stablemetadata) | false |  
 maxSurge |  | int | false | 2 
 maxUnavailable | The maximum number of old/stable replicasets pods that can be unavailable during the update. | int | false | 1 
 minPodsPerReplicaSet | The minimum number of pods that is requested for each ReplicaSet when using traffic routed canary (defaults to 1). | int | false | 1 
 scaleDownDelaySeconds | The delay before scaling down the previous ReplicaSet when the with traffic routing (default 60 seconds). | int | false | 60 
 steps |  | [[]steps](#steps) | false |  
 trafficRouting | To achieve traffic splitting with Nginx ingress, traffic Routing configuration is required. If omitted, traffic split is achieved via a weighted replica counts between the canary and stable ReplicaSet instead of Ingress. | [trafficRouting](#trafficrouting) | false |  


##### analysis

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templates | Reference to the analysis template to use. | [[]templates](#templates) | false |  
 args | List of arguments to pass to the template. | [[]args](#args) | false |  


##### templates

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templateName | Name of the template to use. | string | true |  


##### args

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | Name of the argument. | string | true |  
 value | Value of the argument. | string | true |  


##### canaryMetadata

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 annotations | Annotations to attach to canary pods. | map[string]string | false |  
 labels | Labels to attach to canary pods. | map[string]string | false |  


##### stableMetadata

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 annotations | Annotations to attach to stable pods. | map[string]string | false |  
 labels | Labels to attach to stable pods. | map[string]string | false |  


##### steps

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 setWeight | The ratio of canary ReplicaSet to 20%. | int | false |  
 pause | Pause the rollout for specified duration. | [pause](#pause) | false |  
 setCanaryScale | Configure how the canary is scaled during this step. | [setCanaryScale](#setcanaryscale) | false |  
 analysis | Name of the Analysis template to use in the analysis Step. | [analysis](#analysis) | false |  


##### pause

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 duration |  | string | false |  


##### setCanaryScale

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 replicas | Set a specific number of replicas for the canary. | int | false |  
 weight | Set the canary scale as a percentage of the total replicas. | int | false |  
 matchTrafficWeight | Automatically match the traffic weight with the canary scale. | bool | false |  


##### analysis

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templates | Reference to the analysis template to use. | [[]templates](#templates) | false |  
 args | List of arguments to pass to the template. | [[]args](#args) | false |  


##### templates

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templateName | Name of the template to use. | string | true |  


##### args

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | Name of the argument. | string | true |  
 value | Value of the argument. | string | true |  


##### trafficRouting

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 nginx |  | [nginx](#nginx) | true |  


##### nginx

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 additionalIngressAnnotations | Additional annotations for the ingress. | map[string]string | false |  


##### blueGreen

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 activeService | Name of the service that points to the active deployment. | string | false |  
 previewService | Name of the service that points to the preview deployment. | string | false |  
 autoPromotionEnabled | Whether to automatically promote the new version once ready. | bool | false |  
 autoPromotionSeconds | Seconds to wait before auto-promoting. | int | false |  
 scaleDownDelaySeconds | Seconds to wait before scaling down the previous version. | int | false |  
 scaleDownDelayRevisionLimit | Maximum number of revisions to keep before scaling down old ones. | int | false |  
 previewReplicaCount | Number of replicas for the preview deployment. | int | false |  
 antiAffinity | Anti-affinity configuration between blue and green deployments. | [antiAffinity](#antiaffinity) | false |  
 prePromotionAnalysis | Analysis to run before promoting the new version. | [prePromotionAnalysis](#prepromotionanalysis) | false |  
 postPromotionAnalysis | Analysis to run after promoting the new version. | [postPromotionAnalysis](#postpromotionanalysis) | false |  


##### antiAffinity

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 requiredDuringSchedulingIgnoredDuringExecution | Enforce pods to be scheduled on different nodes. | bool | false |  
 preferredDuringSchedulingIgnoredDuringExecution | Weight for pod anti-affinity. | int | false |  


##### prePromotionAnalysis

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templates | Analysis templates to run. | [[]templates](#templates) | false |  


##### templates

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templateName | Name of the template to use. | string | true |  
 args | Arguments to pass to the template. | [[]args](#args) | false |  


##### args

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | Argument name. | string | true |  
 value | Argument value. | string | true |  


##### postPromotionAnalysis

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templates | Analysis templates to run. | [[]templates](#templates) | false |  


##### templates

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 templateName | Name of the template to use. | string | true |  
 args | Arguments to pass to the template. | [[]args](#args) | false |  


##### args

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name | Argument name. | string | true |  
 value | Argument value. | string | true |  


#### ingress

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 domains | Specify multiple fully qualified domains or single domain for your application. | [[]domains](#domains) | false |  
 class | Specify the class of ingress to use. | string | false | nginx 
 nameSuffix | Specify a suffix for the ingress generated. | string | false |  
 classInSpec | Set ingress class in '.spec.ingressClassName' instead of 'kubernetes.io/ingress.class' annotation. | bool | false | true 
 secretName | Specify the secret name you want to quote. Not usually required. It will be self-generated based on the ingress metadata name. | string | false |  
 annotations | Set additional annotations. | map[string](null&#124;string) | true |  
 tls | Not required for Single Domain or domains with same secret. In case you have multiple domains that doesn't share the same seceret for TLS configuration, you can configure them here. | [[]tls](#tls) | false |  


##### domains

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 domain | Specify the fully qualified domain name to be exposed. The maximum length is 63 characters. | string | true |  
 http | Specify the mapping relationship between the http path and the workload port. | map[string]int | true |  
 pathType |  | string | false | ImplementationSpecific 


##### tls

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 hosts | List of hosts that should be covered by this TLS configuration. | []string | true |  
 secretName | Name of the secret that contains the TLS certificate and key. | string | true |  

