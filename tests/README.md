## Prerequisites

Before you start contributing, there are a few things you should know:

- You should have a basic understanding of Cue since it's the language used for defining the trait schema.

- Knowledge of Python is required for writing the tests.

- There is a script available to generate the traitDefinitions, which you can find here.

## Pull Request Integration Test

To ensure the quality of your contributions, all pull requests will go through an integration test. This test will run the tests in an ephemeral kind cluster and ensure that the changes do not break the existing functionality.

## Getting Started

To get started, clone this repo to your local machine. Then, create a new branch for your changes:

```css
git checkout -b my-branch
```

Next, make your changes and add tests to ensure that your changes are working correctly. Run the tests locally following th guide in [python tests](#pytest_oam_traits) Once you have made your changes, push your branch:

```perl
git push origin my-branch
```

Finally, open a pull request to the oam-traits repository, and our team will review your changes.

## pytest oam traits

pytest project to test custom traits for kubevela.

## Installation & setup for local development

The pull-request-test-oam pipeline is run on every PR. It creates a kind cluster, install Kubevela server and run the
tests later (every test runs vela dry-run to ensure the traits are working).

The project has been tested with python 3.9 but 3.10 should be fine as well.

### macOS

Install [homebrew](https://docs.brew.sh/Installation.html) first. Then install system dependencies using _brew_:
```
brew upgrade
brew install python3
```

## Pipenv
Installing python dependencies is the same for any system, because we'll be using [pipenv](https://docs.pipenv.org/) to streamline dependency and environment management.
Install _pipenv_ and let it take care of installing python dependencies

```
pip install pipenv
```

Install dependencies and virtualenv dependencies

```
pipenv install
```

**Pipfile** - file that describes the environment, contains information about the dependencies of your project

**Pipfile.lock** - file that contains fixed hashes and versions for every library and dependencies

Both files should be stored in the project repository.

The source of truth is the Pipfile.lock and that should be used to install the environment in the CI pipeline or while
debugging locally: (Make sure you execute the below command with python 3.9)
```
pipenv install --ignore-pipfile
```
or
```
pipenv install --python 3.9 --ignore-pipfile
```

If there is a new python library added to the pipfile, both files have to be updated in the repository. Please make sure all your tests are passing on the environment created from Pipfile.lock before pushing to master.


Check if all went well and activate the shell
```
pipenv check
pipenv shell
```

Set the PYTHONPATH. Assuming you're currently in `tests` directory:
```
export PYTHONPATH=$PYTHONPATH:$(pwd)
```

to update a new dependency or upgrade an existing one:
```
pipenv install package==0.2
```

## Running the tests (requires communicating with a Kubevela server)
We'll be using [py.test](https://docs.pytest.org/en/latest/usage.html) to run the tests. Below instructions assume you're working in an activated pipenv environment.

```
py.test -v -s
py.test -m traits
```

## Install kubevela in a kind cluster (mac OS) locally

Ensure you have GO latest version and the $(go env GOPATH)/bin  added to your PATH. You must have kubectl installed as well.
:exclamation: Ensure that you have not KUBECONFIG pointing to another cluster for safety or teleport (tsh logout).

Installation of [kind](https://github.com/kubernetes-sigs/kind)
```
go install sigs.k8s.io/kind@v0.17.0
```

Create a kind cluster
```
kind create cluster --image=kindest/node:v1.33.12 --config=kind-config.yaml
```

Check kind cluster has finished and nodes are ready and install ingress controller
```
kubectl cluster-info --context kind-kind
kubectl get nodes
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

Install KubeVela CLI (if not already installed)
```
brew install kubevela

```

Install Kubevela Core in the kind cluster
```
vela install -y --set multicluster.enabled=false
```

```
helm repo add kubevela https://kubevela.github.io/charts
helm install --create-namespace -n vela-system kubevela kubevela/vela-core --version 1.10.2 --wait
```

Install keda and prometheus
```
helm install --create-namespace -n keda keda kedacore/keda --version 2.13.2 --set prometheus.metricsServer.enabled=true \
          --set prometheus.metricsServer.serviceMonitor.enabled=true --set webhooks.enabled=false --wait
helm install --create-namespace -n prometheus kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 57.1.1 \
          --set podMonitorSelectorNilUsesHelmValues=false --set ruleSelectorNilUsesHelmValues=false \
          --set serviceMonitorSelectorNilUsesHelmValues=false --set grafana.service.nodePort=31000 \
          --set grafana.service.type=NodePort --wait
```

Optional install vela ux
```
vela addon enable velaux
vela port-forward addon-velaux -n vela-system
```

Install traits and components
```
kubectl apply -f ./ -n vela-system
kubectl apply -f ./ComponentDefinitions/ -n vela-system
```

These files has been generated using vela render:
```
vela def render cue-src/envFrom.cue
```
and added the namespace *vela-system* after.

### Uninstall

```
vela addon disable velaux
vela uninstall
kubectl get crd |grep oam | awk '{print $1}' | xargs kubectl delete crd
kind delete cluster
```