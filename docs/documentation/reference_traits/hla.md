---
title:  Hla
---

## Description

Ensure High Level of Availability in your applications.

> For now this trait is hidden from the VelaUX. Available when using CLI

### Apply To Component Types

Component based on the following kinds of resources:
- deployments.apps
- rollouts.argoproj.io
- statefulsets.apps
- daemonsets.apps



## Specification


 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 replicas | Specify the number of workload. When keda is enabled this will be the minimum replicas to scale from. When setting to zero be sure you have a trigger that can be evaluated by keda to scale up from 0 -> 1. | int | false | 2
 lifecycle | Specify behaviour of your pods when your containers are starting or temrinating (applied to all the containers). | [lifecycle](#lifecycle) | true |
 pdb | Specify a pod disruption budget for your component to control the concurrent disruptions in your app component. By default minAvailable=50% if your replicas > 1. Use none to not have pdb. See https://kubernetes.io/docs/tasks/run-application/configure-pdb/. | [pdb](#pdb) | false |
 keda | Specify your scaling policy based on a prometheus metric of your service. | [keda](#keda) | false |


#### lifecycle

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 terminationGracePeriodSeconds | Time to wait before moving from a TERM signal to the pod's main process to a KILL signal. Modify according to the preStop command. | int | false | 30
 postStart | Specify a command to be executed once before your container is started. | [postStart](#poststart) | false |
 preStop | Specify a command to be executed once before your container receives the terminate SIGTERM signal from k8s (example sleep time). Use this when your application can not do a graceful shutdown under a SIGTERM signal. | [preStop](#prestop) | false |
 containers | Specify the commands per container. It has priority over postStart and preStop. | [[]containers](#containers) | false |


##### postStart

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 exec | Run a command in the container. | [exec](#exec) | false |
 httpGet | Performs an HTTP request against an specific endpoint in the container. | [httpGet](#httpget) | false |
 tcpSocket | Performs a tcp request against an specific endpoint in the container. | [tcpSocket](#tcpsocket) | false |


##### exec

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 command | Command to be executed in the container as array of strings. | []string | true |


##### httpGet

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 path | Path to access in the container. | string | false |
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |
 scheme | HTTP scheme. Default to HTTP. | "HTTP" or "HTTPS" | false | HTTP
 httpHeaders | HTTP headers to be added to the request. | [[]httpHeaders](#httpheaders) | false |


##### httpHeaders

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | Name of the header. | string | true |
 value | Value of the header. | string | true |


##### tcpSocket

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |


##### preStop

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 exec | Run a command in the container. | [exec](#exec) | false |
 httpGet | Performs an HTTP request against an specific endpoint in the container. | [httpGet](#httpget) | false |
 tcpSocket | Performs a tcp request against an specific endpoint in the container. | [tcpSocket](#tcpsocket) | false |


##### exec

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 command | Command to be executed in the container as array of strings. | []string | true |


##### httpGet

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 path | Path to access in the container. | string | false |
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |
 scheme | HTTP scheme. Default to HTTP. | "HTTP" or "HTTPS" | false | HTTP
 httpHeaders | HTTP headers to be added to the request. | [[]httpHeaders](#httpheaders) | false |


##### httpHeaders

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | Name of the header. | string | true |
 value | Value of the header. | string | true |


##### tcpSocket

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |


##### containers

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | Name of the container. | string | true |
 postStart | Specify a command to be executed in the container once before your container is started. | [postStart](#poststart) | false |
 preStop | Specify a command to be executed in the container once before your container receives the terminate SIGTERM signal from k8s (example sleep time). Use this when your application can not do a graceful shutdown under a SIGTERM signal. | [preStop](#prestop) | false |


##### postStart

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 exec | Run a command in the container. | [exec](#exec) | false |
 httpGet | Performs an HTTP request against an specific endpoint in the container. | [httpGet](#httpget) | false |
 tcpSocket | Performs a tcp request against an specific endpoint in the container. | [tcpSocket](#tcpsocket) | false |


##### exec

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 command | Command to be executed in the container as array of strings. | []string | true |


##### httpGet

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 path | Path to access in the container. | string | false |
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |
 scheme | HTTP scheme. Default to HTTP. | "HTTP" or "HTTPS" | false | HTTP
 httpHeaders | HTTP headers to be added to the request. | [[]httpHeaders](#httpheaders) | false |


##### httpHeaders

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | Name of the header. | string | true |
 value | Value of the header. | string | true |


##### tcpSocket

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |


##### preStop

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 exec | Run a command in the container. | [exec](#exec) | false |
 httpGet | Performs an HTTP request against an specific endpoint in the container. | [httpGet](#httpget) | false |
 tcpSocket | Performs a tcp request against an specific endpoint in the container. | [tcpSocket](#tcpsocket) | false |


##### exec

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 command | Command to be executed in the container as array of strings. | []string | true |


##### httpGet

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 path | Path to access in the container. | string | false |
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |
 scheme | HTTP scheme. Default to HTTP. | "HTTP" or "HTTPS" | false | HTTP
 httpHeaders | HTTP headers to be added to the request. | [[]httpHeaders](#httpheaders) | false |


##### httpHeaders

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | Name of the header. | string | true |
 value | Value of the header. | string | true |


##### tcpSocket

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 port | Port to access in the container. | int | true |
 host | Host to access in the container (usually localhost or 127.0.0.1). | string | false |


#### pdb

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 type | Specify the type of pdb you want to use. Mutually exlusives with minAvailable and maxUnavailable. | "minAvailable" or "maxUnavailable" or "none" | true |
 value | Specify the value when type is not none. The value can be either a number (absolute value of pods) or a string with a percentage. | string | false |


#### keda

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 triggers | Define the triggers for scaling, except prometheus. See https://keda.sh/docs/2.10/scalers/. | [[]triggers](#triggers) | false |
 pollingInterval | specify the interval to check each trigger.  Default: 30 seconds. | int | false | 30
 cooldownPeriod | Specify the cool down period that prevents the scaler from scaling down after each trigger activation. Default: 60 seconds. | int | false | 60
 minReplicaCount | Specify the minimal replica count. Default: replicas. | int | false |
 maxReplicaCount | Specify the maximal replica count. It should be bigger than replicas Default: 10. | int | false | 10
 fallback | Specify the fallback value when the metrics server is not available. Fallback should not be used when any of your triggers defines an AverageValue metricType. | [fallback](#fallback) | false |
 prometheusTriggers | Define the prometheus triggers for scaling. See https://keda.sh/docs/2.10/scalers/prometheus/. | [[]prometheusTriggers](#prometheustriggers) | false |
 advanced | Specify the behaviour of Kubernetes Horizontal Pod Autoscaler. | [advanced](#advanced) | true |


##### triggers

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 type | Specify the type of the autoscaler. Common values are cpu or memory. | string | true |
 name | Specify the name of the trigger (useful for prometheus metrics but not required). | string | false |
 metricType | Specify the type of the autoscaler. Utilization defines the average of the CPU as a percentage. With AverageValue, the value is a quantity. Value is used when we dont want to take the average. cpu and memory does not support Value!. | "Utilization" or "AverageValue" or "Value" | false | Utilization
 metadata | Specify the configuration parameters for the trigger. | [metadata](#metadata) | true |


##### metadata

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 value | Specify the value to trigger scaling (e.g 80 to scale up when trigger reaches that). The value depends on the metricType (percentage or value). | string | false |


##### fallback

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 failureThreshold | Specify the failure threshold of the scaler. | int | true |
 replicas | Specify the replica when failed to get metrics. Default to replicas. | int | true |


##### prometheusTriggers

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 serverAddress | Address of Prometheus servier. If using VMs, set full URL to Prometheus querying API, e.g. http://<vmselect>:8481/select/0/prometheus. | string | false | http://prometheus-prometheus.monitoring.svc:9090
 metricName | Name of the metric exposed in prometheus. | string | true |
 threshold | The threshold value that once exceeded for the periodSeconds should trigger a scale policy. | string | true |
 query | The query to be run in prometheus against the threshold. It's recommended to use rate for flatten the edges and sum for considering all your pods. | string | true |
 metricType | Specify the type of the autoscaler. Utilization is not allowed with prometheus. Use Value when you dont need to divide the metric by the number of your pods (default). | "AverageValue" or "Value" | false |
 activationThreshold | Defines when the scaler is active or not and scales from/to 0 based on it. By default 0. | string | false | 0


##### advanced

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 restoreToOriginalReplicaCount | This property specifies whether the target resource (Deployment, StatefulSet,…) should be scaled back to original replicas count, after the ScaledObject is deleted. | bool | false | false
 horizontalPodAutoscalerConfig | Specify the behaviour of Kubernetes Horizontal Pod Autoscaler. | [horizontalPodAutoscalerConfig](#horizontalpodautoscalerconfig) | true |


##### horizontalPodAutoscalerConfig

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 behavior | Specify the behavior of the HPA. By default the scale up happens instantly, while the scale down is gradual leaving an stabilizaiton window of 300 seconds. | [behavior](#behavior) | true |


##### behavior

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 scaleDown | Specify the scaling policies for scale Down. Do not modify unless you know what you are doing. https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior. | [scaleDown](#scaledown) | true |
 scaleUp | Specify the scaling policies for scale Up. Do not modify unless you know what you are doing. https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior. | [scaleUp](#scaleup) | true |


##### scaleDown

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 stabilizationWindowSeconds | The stabilization window is used to restrict the flapping of replica count when the metrics used for scaling keep fluctuating. | int | false | 300
 policies | Define the policies for scaling down.  If you set this, the default policies will be ignored. | [[]policies](#policies) | false |
 selectPolicy | Define the trigger type when you define several policies. | "Min" or "Max" | false | Min


##### policies

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 type | Define wether to use a percentage of the pods or a number. | "Percent" or "Pods" | false | Percent
 value | Define the value of the scale policy (percentage or number dependin on the type). | int | false | 100
 periodSeconds | Define the period when new pods are created. | int | false | 15


##### scaleUp

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 stabilizationWindowSeconds | The stabilization window is used to restrict the flapping of replica count when the metrics used for scaling keep fluctuating. | int | false | 0
 policies | Define the policies for scaling up and down. If you set this, the default policies will be ignored. | [[]policies](#policies) | false |
 selectPolicy | Define the trigger type when you define several policies. | "Min" or "Max" | false | Min


##### policies

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 type | Define wether to use a percentage of the pods or a number. | "Percent" or "Pods" | false | Percent
 value | Define the value of the scale policy (percentage or number dependin on the type). | int | false | 100
 periodSeconds | Define the period when new pods are created. | int | false | 15


## Example
```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: hla-webservice-app
spec:
  components:
    - name: hla-ws-app
      type: webservice
      properties:
        image: nginx-with-stub:latest
        imagePullPolicy: IfNotPresent
        imagePullSecrets: ["my-secret"]
        prometheusPort: 9113
        ports:
          - port: 8080
            name: http
            expose: true
          - port: 9113
            name: metrics
            expose: true
        livenessProbe:
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 2
          httpGet:
            path: /healthz
            port: 8080
        readinessProbe:
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 2
          httpGet:
            path: /ready
            port: 8080
        cpuRequest: 100m
        securityContext:
          runAsUser: 0
      traits:
        - type: sidecar
          properties:
            name: nginx-prometheus-exporter
            image: nginx/nginx-prometheus-exporter:latest
            args: [ "-nginx.scrape-uri=http://127.0.0.1:8080/stub_status" ]
            imagePullPolicy: IfNotPresent
            livenessProbe:
              initialDelaySeconds: 10
              periodSeconds: 15
              timeoutSeconds: 2
              httpGet:
                path: /metrics
                port: 9113
            readinessProbe:
              initialDelaySeconds: 10
              periodSeconds: 15
              timeoutSeconds: 2
              httpGet:
                path: /metrics
                port: 9113
            cpuRequest: 50m
        - type: hla
          properties:
            replicas: 2
            lifecycle:
              terminationGracePeriodSeconds: 15
              preStop:
                exec:
                  command: ["sleep", "10"]
            keda:
              maxReplicaCount: 5
              triggers:
                - type: "cpu"
                  metricType: "Utilization"
                  metadata:
                    value: "60"
              prometheusTriggers:
                - metricName: "nginx_connections_waiting"
                  threshold: "0.25"
                  query: 'sum(rate(nginx_connections_waiting{service="hla-ws-app"}[1m]))'
        - type: gateway
          properties:
            domains:
              - domain: localhost
                http:
                  "/healthz": 8080
                  "/medium-json": 8080
                  "/big-json": 8080
```
