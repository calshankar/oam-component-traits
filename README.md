# OAM Component and Traits

A production-ready collection of custom [Open Application Model (OAM)](https://oam.dev/) **ComponentDefinitions** and **TraitDefinitions** designed for [KubeVela](https://kubevela.io/).

This repository extends KubeVela with capabilities for progressive delivery using [Argo Rollouts](https://argoproj.github.io/argo-rollouts/), high availability via [KEDA](https://keda.sh/) and Pod Disruption Budgets, automated secret and configuration injection with [External Secrets Operator](https://external-secrets.io/), workload service account management, and granular manifest patching.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Catalog](#catalog)
  - [Components](#components)
  - [Traits](#traits)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage Example](#usage-example)
- [Development Workflow](#development-workflow)
- [GitOps with Argo CD](#gitops-with-argo-cd)
- [Testing](#testing)
- [License](#license)

---

## Overview

KubeVela allows platform engineers to define reusable building blocks (Components and Traits) using the [CUE data constraint language](https://cuelang.org/). Application developers then consume these building blocks through clean, declarative `Application` manifests without needing to write low-level Kubernetes resources directly.

This repository provides:
- **CUE source definitions** under `cue-src/` for source-controlled schematic definitions.
- **Rendered Kubernetes CRD manifests** in the root directory and `ComponentDefinitions/`, ready to be installed into the `vela-system` namespace.
- **Progressive Delivery & High Availability patterns** pre-configured for production environments.

---

## Repository Structure

```text
├── ComponentDefinitions/         # Rendered ComponentDefinition YAML manifests
│   └── rollouts.yaml             # Argo Rollouts workload component definition
├── cue-src/                      # CUE language template source files
│   ├── components/               # CUE templates for components (rollouts.cue)
│   └── traits/                   # CUE templates for traits (hla, analysistemplate, etc.)
├── argoManifest/                 # GitOps manifests and multi-cluster examples
│   └── sampleAppSet.yaml         # Argo CD ApplicationSet example for multi-cluster OAM apps
├── docs/                         # Detailed documentation and trait specifications
│   ├── documentation/oam.md      # OAM and KubeVela conceptual guide
│   └── documentation/reference_traits/ # Parameter reference tables for each trait/component
├── tests/                        # Integration test suite and local environment setup
│   ├── kind-config.yaml          # Local Kind cluster configuration
│   ├── requirements.txt / Pipfile# Python test dependencies
│   ├── test_oam_applications/    # Sample OAM applications used for verification
│   └── README.md                 # Test harness and local setup documentation
├── analysistemplate.yaml         # TraitDefinition: Argo Rollouts AnalysisTemplate
├── annotations.yaml              # TraitDefinition: Pod and workload annotations injection
├── envFrom.yaml                  # TraitDefinition: ConfigMap, Secret, & ExternalSecret env injection
├── externalSecrets.yaml          # TraitDefinition: External Secrets Operator integration
├── hla.yaml                      # TraitDefinition: High Level Availability (PDB, KEDA, Lifecycles)
├── patchoutputs.yaml             # TraitDefinition: General-purpose manifest patching
└── serviceaccount.yaml           # TraitDefinition: ServiceAccount creation and association
```

---

## Catalog

### Components

| Component | Target Resource | Description |
| :--- | :--- | :--- |
| **`rollouts`** | `rollouts.argoproj.io` | Deploys an Argo Rollouts resource supporting Canary and Blue-Green progressive delivery, traffic routing (e.g., NGINX Ingress), Prometheus metrics discovery, health probes, and analysis steps. |

### Traits

| Trait | Target Workloads | Description |
| :--- | :--- | :--- |
| **`hla`** | `deployments.apps`, `rollouts.argoproj.io`, `statefulsets.apps`, `daemonsets.apps` | **High Level of Availability**: Injects Pod Disruption Budgets (`minAvailable` / `maxUnavailable`), KEDA `ScaledObject` autoscaling (Prometheus metrics & resource triggers), and pod lifecycle hooks (`preStop`, `postStart`, `terminationGracePeriodSeconds`). |
| **`analysistemplate`** | `rollouts.argoproj.io`, `traitdefinition.core.oam.dev` | Generates Argo Rollouts `AnalysisTemplate` resources to run automated background or step-based canary metrics verification against Prometheus. |
| **`envfrom`** | `deployments.apps`, `statefulsets.apps`, `daemonsets.apps`, `jobs.batch`, `cronjobs.batch` | Injects environment variables into workload containers directly from ConfigMaps, Secrets, or ExternalSecrets with key validation and name-length sanitization. |
| **`externalsecrets`** | `*` (All Component Types) | Creates `ExternalSecret` custom resources to synchronize credentials from external SecretStores into Kubernetes Secrets and attaches them to workloads. |
| **`serviceaccount`** | `*` (All Component Types) | Creates a dedicated Kubernetes `ServiceAccount` and binds `serviceAccountName` into the workload pod specification (supports Deployments, Rollouts, CronJobs). |
| **`annotations`** | `*` (All Component Types) | Injects custom metadata annotations into the workload and propagates them to generated Pod and Job templates. |
| **`patchoutputs`** | `*` (All Component Types) | General-purpose escape hatch to patch workload definitions and trait outputs using CUE patch strategies. |

---

## Prerequisites

- **Kubernetes cluster** (v1.24+ recommended)
- **kubectl** configured with cluster access
- **KubeVela CLI & Controller** (`vela-core` >= v1.9.0)
  ```bash
  # Install KubeVela CLI (macOS)
  brew install kubevela

  # Or install via script
  curl -fsSL https://kubevela.io/install.sh | bash
  ```
- **Optional Cluster Add-ons** (required depending on the traits used):
  - [Argo Rollouts](https://argoproj.github.io/argo-rollouts/) (for `rollouts` component and `analysistemplate` trait)
  - [KEDA](https://keda.sh/) (for `hla` autoscaling)
  - [Prometheus Stack](https://prometheus-community.github.io/helm-charts) (for `hla` and `analysistemplate` metrics)
  - [External Secrets Operator](https://external-secrets.io/) (for `externalsecrets` trait)
  - [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) (for traffic routing)

---

## Installation

Apply the Component and Trait definitions into the KubeVela system namespace (`vela-system`):

```bash
# Apply ComponentDefinitions
kubectl apply -f ./ComponentDefinitions/ -n vela-system

# Apply TraitDefinitions
kubectl apply -f ./analysistemplate.yaml -n vela-system
kubectl apply -f ./annotations.yaml -n vela-system
kubectl apply -f ./envFrom.yaml -n vela-system
kubectl apply -f ./externalSecrets.yaml -n vela-system
kubectl apply -f ./hla.yaml -n vela-system
kubectl apply -f ./patchoutputs.yaml -n vela-system
kubectl apply -f ./serviceaccount.yaml -n vela-system
```

Verify that definitions are successfully registered:

```bash
vela def list -n vela-system
```

You can view the detailed schema and parameters of any installed definition using `vela show`:

```bash
vela show rollouts
vela show hla
```

---

## Usage Example

Below is an example of an OAM `Application` manifest combining the `rollouts` component with the `hla`, `analysistemplate`, `envfrom`, and `serviceaccount` traits:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: canary-demo-app
  namespace: default
spec:
  components:
    - name: web-service
      type: rollouts
      properties:
        image: argoproj/rollouts-demo:blue
        imagePullPolicy: IfNotPresent
        replicas: 3
        ports:
          - port: 8080
            name: http
            expose: true
        cpuRequest: "100m"
        memoryRequest: "128Mi"
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 15
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        strategy:
          type: "Canary"
          canary:
            canaryService: web-service-canary
            stableService: web-service-stable
            trafficRouting:
              nginx:
                stableIngress: web-service-ingress
            steps:
              - setWeight: 20
              - pause: { duration: "1m" }
              - analysis:
                  templates:
                    - templateName: success-rate-check
              - setWeight: 50
              - pause: { duration: "2m" }
        ingress:
          class: nginx
          domains:
            - domain: app.example.com
              http:
                "/": 8080

      traits:
        # High Availability: PDB, Lifecycle Hook, and KEDA Autoscaling
        - type: hla
          properties:
            pdb:
              type: "maxUnavailable"
              value: 1
            lifecycle:
              terminationGracePeriodSeconds: 30
              preStop:
                exec:
                  command: ["/bin/sh", "-c", "sleep 15"]
            keda:
              minReplicaCount: 2
              maxReplicaCount: 10
              prometheusTriggers:
                - metricName: "http_requests_total"
                  metricType: "AverageValue"
                  threshold: "100"
                  query: 'sum(rate(http_requests_total{service="web-service"}[1m]))'

        # Analysis Template for Canary Validation
        - type: analysistemplate
          properties:
            name: success-rate-check
            namespace: default
            metrics:
              - name: success-rate
                interval: 30s
                successcondition: "result[0] >= 0.99"
                failurelimit: 2
                provider:
                  address: http://prometheus-prometheus.monitoring.svc:9090
                  query: |
                    sum(rate(nginx_ingress_controller_requests{ingress="web-service-ingress", status!~"[4-5].*"}[2m]))
                    /
                    sum(rate(nginx_ingress_controller_requests{ingress="web-service-ingress"}[2m]))

        # Environment variables from ConfigMaps and Secrets
        - type: envfrom
          properties:
            configMaps:
              - name: "app-config"
                data:
                  ENVIRONMENT: "production"
                  LOG_LEVEL: "info"
            secrets:
              - name: "app-secrets"
                stringData:
                  API_KEY: "secret-token"

        # Automated ServiceAccount creation and workload binding
        - type: serviceaccount
          properties:
            name: web-service-sa
```

### Dry-Run Validation

Test and validate the output of your application manifest locally without deploying to the cluster:

```bash
vela dry-run -f canary-demo-app.yaml
```

Deploying to the cluster:

```bash
vela up -f canary-demo-app.yaml
```

---

## Development Workflow

The source definitions in this repository are authored in CUE under `cue-src/` and compiled to Kubernetes `TraitDefinition` and `ComponentDefinition` YAML files.

### Modifying CUE Templates

1. Edit or add trait templates under `cue-src/traits/` or component templates under `cue-src/components/`.
2. Re-render the YAML definitions using the KubeVela CLI:

```bash
# Render a trait definition
vela def render cue-src/traits/<trait-name>.cue -o <trait-name>.yaml

# Render a component definition
vela def render cue-src/components/rollouts.cue -o ComponentDefinitions/rollouts.yaml
```

> **Note:** Ensure that `metadata.namespace: vela-system` is present in the rendered YAML definitions before applying to the cluster.

---

## GitOps with Argo CD

For multi-cluster and multi-region deployment topologies, this repository includes an [Argo CD ApplicationSet](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/) example in `argoManifest/sampleAppSet.yaml`.

This pattern allows platform teams to:
- Dynamically generate Argo CD applications targeting multiple regional Kubernetes clusters.
- Parameterize OAM `Application` manifests via Helm values or Git generators.
- Enforce consistent progressive delivery policies across diverse environments.

---

## Testing

An automated integration testing suite is located in the `tests/` directory. It uses `kind`, `pytest`, and `vela dry-run` to validate trait compilation and Kubernetes resource output against test manifests under `tests/test_oam_applications/`.

### Setting up Local Kind Test Cluster

See [`tests/README.md`](tests/README.md) for full instructions on setting up a local testing environment:

```bash
# Create local Kind cluster with ingress and port mappings
kind create cluster --image=kindest/node:v1.33.12 --config=tests/kind-config.yaml

# Install KubeVela Core via Helm
helm repo add kubevela https://kubevela.github.io/charts
helm install --create-namespace -n vela-system kubevela kubevela/vela-core --version 1.10.2 --wait

# Install test dependencies and run tests
cd tests
pipenv install --ignore-pipfile
pipenv run pytest -v -s
```

---

## License

This project is licensed under the [MIT License](LICENSE).
