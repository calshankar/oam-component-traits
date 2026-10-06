---
title:  Analysistemplate
---

## Description

Analysis Template referred in Argo Rollouts.

> For now this trait is hidden from the VelaUX. Available when using CLI

### Apply To Component Types

Component based on the following kinds of resources:
- traitdefinition.core.oam.dev
- rollouts.argoproj.io



## Specification


 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | The name of the analysistemplate. | string | true |
 namespace | The namespace of the analysistemplate. | string | true |
 args | The Arguments to be passed to the AnalysisTemplate. | [[]args](#args) | false |
 dryRunMetricName | The dryRun metric is used to control whether to evaluate metric or not during analysis run. This metric has no impact to the final state of rollout. | []string | false |
 templates | The cluster scope of the AnalysisTemplate. | [[]templates](#templates) | false |
 metrics | The AnalysisTemplates may reference other templates to combine the metric analysis. | [[]metrics](#metrics) | false |


#### args

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name |  | string | true |
 value |  | string | false |


#### templates

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 templateName |  | string | true |
 clusterScope |  | bool | false | false


#### metrics

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 name | The name of the metric that is targeted for analysis. For example, "http-error-rate". | string | true |
 interval | Metric Interval Samples collested during the analysis. Defaults to 5 minutes if not specified. | string | false | 5m
 failureCondition | The condition or cause for analysis run to fail. For example, "result < 0.5". | string | false |
 failurelimit | The number of failures before the analysis is considered failed. Defaults to 3 if not specified. | int | false | 3
 successcondition | The condition/cause an analysis run to be a Success. | string | false |
 consecutivesuccesslimit | The number of consecutive successes for the analysis to succeed. Specify either failurelimit or consecutiveSuccessLimit. | int | true |
 count | The number of measurements performed over the duration of the analysis run. Defaults to 3 if not specified. | int | false | 3
 initialdelay | The until 5 minutes after the analysis run starts. Default to 5mins if not specified. | string | false | 3m
 provider | The provider of the metric. | [provider](#provider) | true |


##### provider

 Name | Description | Type | Required | Default
 ---- | ----------- | ---- | -------- | -------
 address | The address of the prometheus. | string | false | http://prometheus-prometheus.monitoring.svc:9090
 query | The query string to query prometheus on the cluster. | string | true |
 timeout | The headers of the prometheus. | int | false |


## Example
```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: analysistemplate-test
  namespace: default
spec:
  components:
    - name: analysistemplate-test
      type: webservice
      properties:
        image: ghcr.io/stefanprodan/podinfo:6.0.0
        ports:
        - port: 8080
#          expose: true
        livenessProbe:
          initialDelaySeconds: 12
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
      traits:
        - type: analysistemplate
          properties:
            name: total-5xx-errors
            namespace: default
            args:
              - name: service-name
                value: guestbook-svc.default.svc.cluster.local
            dryRunMetricName: [total-5xx-errors, total-4xx-errors]
            templates:
              - templateName: P99-latency
            metrics:
              - name: error-rate
                interval: 5m
                count: 2
                provider:
                  query: |
                    histogram_quantile(0.99, sum by(le) (rate(nginx_ingress_controller_request_duration_seconds_bucket{ingress=~"{{args.ingress-name}}"}[1m]))) * 1000
            annotations:
              one.example.com/annotation: "test"
```
