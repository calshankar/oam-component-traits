hla: {
	type: "trait"
	annotations: {}
	labels: {
		"ui-hidden": "true"
	}
	namespace:   "vela-system"
	description: "Ensure High Level of Availability in your applications"
	attributes: {
		podDisruptive: true
		appliesToWorkloads: ["deployments.apps", "rollouts.argoproj.io", "statefulsets.apps", "daemonsets.apps"]
	}
}

template: {
		_defaultPoliciesScaleDown: [{type: "Percent", value: 50, periodSeconds: 60}]
		_defaultPoliciesScaleUp: [{type: "Pods", value: 1, periodSeconds: 30}]
		// function definitions
		PDBTemplate: {
			_name: string
			_default: *false | bool
			pdbHla: {
				apiVersion: "policy/v1"
				kind: "PodDisruptionBudget"
				metadata:
					name: _name
				spec: {
					selector:
					{
						matchLabels: "app.oam.dev/component": _name
					}
					if parameter.pdb != _|_ {
						"\(parameter.pdb.type)": parameter.pdb.value
					}

					if _default {
						minAvailable: "50%"
					}
				}
			}
		}
		// https://keda.sh/docs/2.10/concepts/scaling-deployments/
		// https://keda.sh/docs/2.10/scalers/prometheus/
		ScaledObjectPrometheusTemplate: {
			_target: string
			_triggers: [...]
			scaledObjectHla : {
				apiVersion: "keda.sh/v1alpha1"
				kind: "ScaledObject"
				metadata: {
					name: "scaled-object-\(_target)"
				}
				spec: {
					// Check if the workload is a Rollout by checking the context
					if context.output.kind == "Rollout" {
						scaleTargetRef: {
							apiVersion: "argoproj.io/v1alpha1"
							kind: "Rollout"
							name: _target
						}
					}
					if context.output.kind != "Rollout" {
						scaleTargetRef: {
							name: _target
						}
					}
					pollingInterval: parameter.keda.pollingInterval
					cooldownPeriod: parameter.keda.cooldownPeriod
					if parameter.keda.minReplicaCount != _|_ {
						minReplicaCount: parameter.keda.minReplicaCount
					}
					if parameter.keda.minReplicaCount == _|_ {
						minReplicaCount: parameter.replicas
					}
					maxReplicaCount: parameter.keda.maxReplicaCount
					if (parameter.keda.fallback != _|_) {
						fallback: {
							failureThreshold: parameter.keda.fallback.failureThreshold
							replicas: parameter.keda.fallback.replicas
						}
					}
					if (parameter.keda.fallback == _|_) {
						fallback: null
					}
					advanced: {
						restoreToOriginalReplicaCount: parameter.keda.advanced.restoreToOriginalReplicaCount
						horizontalPodAutoscalerConfig: {
							behavior: {
								scaleDown: {
									stabilizationWindowSeconds: parameter.keda.advanced.horizontalPodAutoscalerConfig.behavior.scaleDown.stabilizationWindowSeconds
									selectPolicy: parameter.keda.advanced.horizontalPodAutoscalerConfig.behavior.scaleDown.selectPolicy
									policies: *parameter.keda.advanced.horizontalPodAutoscalerConfig.behavior.scaleDown.policies | _defaultPoliciesScaleDown
								}
								scaleUp: {
									stabilizationWindowSeconds: parameter.keda.advanced.horizontalPodAutoscalerConfig.behavior.scaleUp.stabilizationWindowSeconds
									selectPolicy: parameter.keda.advanced.horizontalPodAutoscalerConfig.behavior.scaleUp.selectPolicy
									policies: *parameter.keda.advanced.horizontalPodAutoscalerConfig.behavior.scaleUp.policies | _defaultPoliciesScaleUp
								}
							}
						}
					}
					triggers: _triggers
				}
			}
		}

		PatchLifecycle: {
			_name: string
			_matchContainer_: [ for _c in parameter.lifecycle.containers if _c.name == _name {
				firstMatch: _c
			}]
			name: _name
		  if len(_matchContainer_) > 0 {
		  	// _matchContainer_ wont have visibility inside lifecycle
		  	_container: _matchContainer_[0].firstMatch
		  	lifecycle: {
					if _container.postStart != _|_ {
						postStart: _container.postStart
					}
					if _container.preStop != _|_ {
						preStop: _container.preStop
					}
				}
		  }
		}

		outputs: {
			// This first failure style doesnt work in functions, they should be evaluated completely?
			if parameter.pdb != _|_ {
				if parameter.pdb.type != "none" {
						// without keda and 0 replicas PDB can not be defined
						if parameter.replicas <= 1 && parameter.keda == _|_  {
							err: {"msg": "You can not define a pod disruption budget with 1 replica and keda disabled."}
						}
						// Either keda enabled or more than 1 replica, PDB is created
						if parameter.keda != _|_ || parameter.replicas > 1 {
							PDBTemplate & {_name: context.name}
						}

				}
			}
			if parameter.pdb == _|_ {
				if parameter.keda != _|_ || parameter.replicas > 1 {
					// Add a default pdb with minAvailable=50%
					PDBTemplate & {_name: context.name, _default: true}
				}
			}

			if parameter.keda != _|_ {

				_prometheus_triggers: [...]
				_gen_triggers: *parameter.keda.triggers | []

				if parameter.keda.prometheusTriggers != _|_ {
					_prometheus_triggers: [for prom_t in parameter.keda.prometheusTriggers {
							type: "prometheus"
							metadata: {
								serverAddress: prom_t.serverAddress
								activationThreshold: prom_t.activationThreshold
								metricName: prom_t.metricName
								threshold: prom_t.threshold
								query: prom_t.query
							}
							if (prom_t.metricType != _|_) {
								metricType: prom_t.metricType
							}
						}
					]
				}

				ScaledObjectPrometheusTemplate & {_target: context.name, _triggers: _prometheus_triggers + _gen_triggers}
			}
		}

		// Ensure liveness and readiness are defined in the containers
		patch: spec: template: spec: {
			//+patchKey=name
			containers: [
				for c in context.output.spec.template.spec.containers {
					// TODO: add an algorithm to define as many err as containers variations.... (just an array?)
					if c.livenessProbe == _|_ {
						err: "container \(c.name) not define the liveness probe"
					}
					if c.readinessProbe == _|_ {
						err: "container \(c.name) not define the readinessProbe probe"
					}
				},
			]
		}

		// Note: we dont update spec.replicas when keda is enabled and leave that to keda to avoid kubevela override the value while deployment
		// a new version during and scale up or down event where replicas has changed from the minimum
		if parameter.keda == _|_ {
			patch: spec: replicas: parameter.replicas
		}

		// patch terminationGracePeriodSeconds
		//+patchStrategy=retainKeys
		patch: spec: template: spec: terminationGracePeriodSeconds: parameter.lifecycle.terminationGracePeriodSeconds

		// patch lifecycle
		patch: spec: template: spec: {
			if parameter.lifecycle.containers == _|_ {
				// +patchkey=name
				containers: [...{
					if parameter.lifecycle.postStart != _|_ || parameter.lifecycle.preStop != _|_ {
						lifecycle: {
							if parameter.lifecycle.postStart != _|_ {
								postStart: parameter.lifecycle.postStart
							}
							if parameter.lifecycle.preStop != _|_ {
								preStop: parameter.lifecycle.preStop
							}
						}
					}
				}]
			}
			if parameter.lifecycle.containers != _|_ {
				// +patchKey=name
				containers: [ for c in context.output.spec.template.spec.containers {
					PatchLifecycle & { _name: c.name }
				}]
			}
		}

		parameter: {
			//+usage=Specify the number of workload. When keda is enabled this will be the minimum replicas to scale from. When setting to zero be sure you have a trigger that can be evaluated by keda to scale up from 0 -> 1
			replicas: *2 | int
			//+usage=Specify behaviour of your pods when your containers are starting or temrinating (applied to all the containers)
			lifecycle: {
				//+usage=Time to wait before moving from a TERM signal to the pod's main process to a KILL signal. Modify according to the preStop command.
				terminationGracePeriodSeconds: *30 | int
				//+usage=Specify a command to be executed once before your container is started
				postStart?: #LifeCycleHandler
				//+usage=Specify a command to be executed once before your container receives the terminate SIGTERM signal from k8s (example sleep time). Use this when your application can not do a graceful shutdown under a SIGTERM signal.
				preStop?: #LifeCycleHandler
				//+usage=Specify the commands per container. It has priority over postStart and preStop.
				containers?: [...{
					//+usage=Name of the container
					name: string,
					//+usage=Specify a command to be executed in the container once before your container is started.
					postStart?: #LifeCycleHandler
					//+usage=Specify a command to be executed in the container once before your container receives the terminate SIGTERM signal from k8s (example sleep time). Use this when your application can not do a graceful shutdown under a SIGTERM signal.
					preStop?: #LifeCycleHandler
				}]

			}
			//+usage=Specify a pod disruption budget for your component to control the concurrent disruptions in your app component. By default minAvailable=50% if your replicas > 1. Use none to not have pdb. See https://kubernetes.io/docs/tasks/run-application/configure-pdb/
			pdb?: {
				//+usage=Specify the type of pdb you want to use. Mutually exlusives with minAvailable and maxUnavailable.
				type: "minAvailable" | "maxUnavailable" | "none"
				//+usage=Specify the value when type is not none. The value can be either a number (absolute value of pods) or a string with a percentage.
				value?: string | int
			}
			//+usage=Specify your scaling policy based on a prometheus metric of your service
			keda?: {
				//+usage=Define the keda behavior
				#kedaHPA
				//+usage=Define the triggers for scaling, except prometheus. See https://keda.sh/docs/2.10/scalers/
				triggers?: [...#Trigger]
				//+usage=Define the prometheus triggers for scaling. See https://keda.sh/docs/2.10/scalers/prometheus/
				prometheusTriggers?: [...#PrometheusTrigger]
			}
		}
		#Port: int & >=1 & <=65535
		#LifeCycleHandler: {
			//+usage=Run a command in the container
			exec?: {
				//+usage=Command to be executed in the container as array of strings.
				command: [...string]
			}
			//+usage=Performs an HTTP request against an specific endpoint in the container
			httpGet?: {
				//+usage=Path to access in the container
				path?:  string
				//+usage=Port to access in the container
				port:   #Port
				//+usage=Host to access in the container (usually localhost or 127.0.0.1)
				host?:  string
				//+usage=HTTP scheme. Default to HTTP
				scheme: *"HTTP" | "HTTPS"
				//+usage=HTTP headers to be added to the request
				httpHeaders?: [...{
					//+usage=Name of the header
					name:  string
					//+usage=Value of the header
					value: string
				}]
			}
			//+usage=Performs a tcp request against an specific endpoint in the container
			tcpSocket?: {
				//+usage=Port to access in the container
				port:  #Port
				//+usage=Host to access in the container (usually localhost or 127.0.0.1)
				host?: string
			}
		}

		#kedaHPA : {
			//+usage=specify the interval to check each trigger.  Default: 30 seconds
			pollingInterval: *30 | int
			//+usage=Specify the cool down period that prevents the scaler from scaling down after each trigger activation. Default: 60 seconds
			cooldownPeriod: *60 | int
			//+usage=Specify the minimal replica count. Default: replicas.
			minReplicaCount?: int
			//+usage=Specify the maximal replica count. It should be bigger than replicas Default: 10.
			maxReplicaCount: *10 | int
			//+usage=Specify the fallback value when the metrics server is not available. Fallback should not be used when any of your triggers defines an AverageValue metricType.
			fallback?: {
					//+usage=Specify the failure threshold of the scaler.
					failureThreshold: int
					//+usage=Specify the replica when failed to get metrics. Default to replicas.
					replicas: int
			}
			//+usage=Specify the behaviour of Kubernetes Horizontal Pod Autoscaler.
			advanced: {
				//+usage=This property specifies whether the target resource (Deployment, StatefulSet,…) should be scaled back to original replicas count, after the ScaledObject is deleted
				restoreToOriginalReplicaCount: *false | true
				//+usage=Specify the behaviour of Kubernetes Horizontal Pod Autoscaler.
				horizontalPodAutoscalerConfig: {
					//+usage=Specify the behavior of the HPA. By default the scale up happens instantly, while the scale down is gradual leaving an stabilizaiton window of 300 seconds.
					behavior: #BehaviorHPA
				}
			}
		}

		#BehaviorHPA: {
			//+usage=Specify the scaling policies for scale Down. Do not modify unless you know what you are doing. https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior
			scaleDown: {
				//+usage=The stabilization window is used to restrict the flapping of replica count when the metrics used for scaling keep fluctuating
				stabilizationWindowSeconds: *300 | int
				//+usage=Define the policies for scaling down.  If you set this, the default policies will be ignored
				policies?: [...#scalePolicy]
				//+usage=Define the trigger type when you define several policies.
				selectPolicy: *"Min" | "Max"
			}
			//+usage=Specify the scaling policies for scale Up. Do not modify unless you know what you are doing. https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior
			scaleUp: {
				//+usage=The stabilization window is used to restrict the flapping of replica count when the metrics used for scaling keep fluctuating
				stabilizationWindowSeconds: *0 | int
				//+usage=Define the policies for scaling up and down. If you set this, the default policies will be ignored
				policies?: [...#scalePolicy]
				//+usage=Define the trigger type when you define several policies.
				selectPolicy: *"Min" | "Max"
			}
		}

		#scalePolicy: {
			//+usage=Define wether to use a percentage of the pods or a number
			type: *"Percent" | "Pods"
			//+usage=Define the value of the scale policy (percentage or number dependin on the type)
			value: *100 | int
			//+usage=Define the period when new pods are created
			periodSeconds: *15 | int
		}

		#PrometheusTrigger: {
			//+usage=Address of Prometheus servier. If using VMs, set full URL to Prometheus querying API, e.g. http://<vmselect>:8481/select/0/prometheus
			serverAddress: *"http://prometheus-prometheus.monitoring.svc:9090" | string
			//+usage=Name of the metric exposed in prometheus
			metricName: string
			//+usage=The threshold value that once exceeded for the periodSeconds should trigger a scale policy.
			threshold: string
			//+usage=The query to be run in prometheus against the threshold. It's recommended to use rate for flatten the edges and sum for considering all your pods.
			query: string
			//+usage=Specify the type of the autoscaler. Utilization is not allowed with prometheus. Use Value when you dont need to divide the metric by the number of your pods (default).
			metricType?: "AverageValue" | "Value"
			//+usage=Defines when the scaler is active or not and scales from/to 0 based on it. By default 0.
			activationThreshold: *"0" | string
		}

		#Trigger: {
			//+usage=Specify the type of the autoscaler. Common values are cpu or memory
			type: "cpu" | "memory" | string
			//+usage=Specify the name of the trigger (useful for prometheus metrics but not required)
			name?: string
			//+usage=Specify the type of the autoscaler. Utilization defines the average of the CPU as a percentage. With AverageValue, the value is a quantity. Value is used when we dont want to take the average. cpu and memory does not support Value!.
			metricType?: *"Utilization" | "AverageValue" | "Value"
			//+usage=Specify the configuration parameters for the trigger
			metadata: {
				//+usage=Specify the value to trigger scaling (e.g 80 to scale up when trigger reaches that). The value depends on the metricType (percentage or value).
				value?: string
				...
			}
		}

		//+usage=Define the errors that an application may have after sanity checking. The application wont be deployed with this field present.
		errs: [ for c in patch.spec.template.spec.containers if c.err != _|_ {c.err}]
}
