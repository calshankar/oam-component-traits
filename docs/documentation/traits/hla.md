## Introduction

This document provides an overview of the usage of the HLA (High Level of Availability) trait.

## Overview

The HLA trait is a pre-built trait that can be used to ensure that the application is deployed in a highly available and scalable manner. The trait provides the following features:

* Pod disruption budget: The trait will configure by default a pdb so that you have always 50% of your pods available when k8s is doing maintenance or recycling nodes.

* AutoScaling: The trait can automatically scale the application by adding or removing instances based on a prometheus metric.

* Health checks: The trait will ensure that the readiness and liveness checks are defined.

### Usage

To use the HLA trait, you need to include it in your OAM application's file:

```yaml
        - type: hla
          properties:
            replicas: 2
            keda:
              prometheusTriggers:
                - maxReplicaCount: 5
                  metricName: "nginx_connections_waiting"
                  threshold: "0.25"
                  query: 'sum(rate(nginx_connections_waiting{service="hla-ws-app"}[1m]))'
```

In the above example, the hla trait is configured for the most typical usage. Please refer to [reference hla](../reference_traits/hla.md) for a full understanding of the properties.
A full example of that configuration can be found in the example applications [hla-application](../examples/hla_application/index.md).

### Scaling from zero

To optimize costs, you can use the hla trait in combination with KEDA and set replicas: 0, so your service activates only when needed.
This approach keeps your deployment at zero replicas until a metric threshold or an event triggers it.

KEDA supports scaling from zero by using an external metric source or event. You can configure a scheduler trigger to scale up
your deployment at specific times. However, for a more dynamic, automated approach, choose a metric that reliably indicates when your service should activate, such as a queue length, Ingress requests, or a custom external trigger.

When scaling from zero, a simple CPU autoscaler alone won’t work, as CPU usage can't be evaluated without an active pod.
Instead, use an external source like a message queue or Ingress to kick-start scaling, after which your deployment can
rely on standard metrics (e.g., CPU) for further scaling adjustments.

Here's an example setup where KEDA scales up when an initial request is received, then relies on CPU or other metrics for ongoing scaling:


```yaml
- type: hla
  properties:
    replicas: 0
    lifecycle:
      preStop:
        exec:
          command: ["sleep", "10"]
    keda:
      maxReplicaCount: 5
      triggers:
        - type: "cpu"
          metricType: "Utilization"
          metadata:
            value: "100"
      prometheusTriggers:
        - metricName: "nginx_request_per_minute"
          threshold: "10000"
          query: 'sum(increase(nginx_ingress_controller_requests{ingress="eternalmoving"}[1m]))'
          activationThreshold: "1"
      #for demo
      pollingInterval: 10
      cooldownPeriod: 30
```

In this example, any incoming request to the ingress will prompt KEDA to scale the deployment from 0 to 1, activating the service when needed.
Note that there may be a slight delay when the metric is initially evaluated. After the initial activation, the trigger
will not be reactivated due to the high threshold. Instead, further scaling will depend on the CPU trigger (or another defined metric) to adjust the replicas dynamically based on demand.

If an external trigger isn’t feasible, a fallback option is to use the scheduler trigger to bring up the deployment
periodically or set minReplicaCount: 1 to maintain a minimum pod. This approach ensures availability but doesn’t
reduce costs as effectively as true zero-scaling.

Use the [scheduler](https://keda.sh/docs/2.15/scalers/cron/) only if you can't define a reliable metric.

> **Note**: This approach is generally recommended for development and QA environments only.

### Conclusion

By using the HLA trait, you can easily deploy highly available and scalable applications without having to worry about managing the infrastructure yourself. This can save a lot of time and effort, especially for large-scale deployments.
