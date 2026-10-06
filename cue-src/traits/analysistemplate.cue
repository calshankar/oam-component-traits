import (
	"strings"
)

analysistemplate: {
	type: "trait"
  annotations: {
	}
	labels: {
		"ui-hidden": "true"
	}
	attributes: {
		podDisruptive: false
		appliesToWorkloads: ["traitdefinition.core.oam.dev", "rollouts.argoproj.io"]
	}
	description: "Analysis Template referred in Argo Rollouts."
}

template: {

	parameter: {
		// +usage=The name of the analysistemplate
		name: string
		// +usage=The namespace of the analysistemplate
		namespace: string
		// +usage=The Arguments to be passed to the AnalysisTemplate
		args?: [...{
      name: string
      value?: string
    }]
		// +usage=The dryRun metric is used to control whether to evaluate metric or not during analysis run. This metric has no impact to the final state of rollout
		dryRunMetricName?: [...string]
    // +usage=The cluster scope of the AnalysisTemplate
    templates?: [...{
      templateName: string
      clusterScope?: *false | bool
    }]
    // +usage=The AnalysisTemplates may reference other templates to combine the metric analysis.
		metrics?: [...{
      // +usage=The name of the metric that is targeted for analysis. For example, "http-error-rate"
      name: string
      // +usage=Metric Interval Samples collested during the analysis. Defaults to 5 minutes if not specified
      interval: *"5m" | string
      // +usage=The condition or cause for analysis run to fail. For example, "result < 0.5"
      failureCondition?: string
      // +usage=The number of failures before the analysis is considered failed. Defaults to 3 if not specified
      failurelimit?: *3 | int | string
      // +usage=The condition/cause an analysis run to be a Success
      successcondition?: string
      // +usage=The number of consecutive successes for the analysis to succeed. Specify either failurelimit or consecutiveSuccessLimit
      consecutivesuccesslimit: int | string
      // +usage=The number of measurements performed over the duration of the analysis run. Defaults to 3 if not specified
      count?: *3 | int | string
      // +usage=The until 5 minutes after the analysis run starts. Default to 5mins if not specified
      initialdelay?: *"3m" | =~ "^([1-9][0-9]{0,3})(s|m)$"
      // +usage=The provider of the metric
      provider: {
          // +usage=The address of the prometheus
          address: *"http://prometheus-prometheus.monitoring.svc:9090" | string
          // +usage=The query string to query prometheus on the cluster
          query: string
          // +usage=The headers of the prometheus
          timeout?: int64
      }
    }]
	}


	outputs: analysistemplate: {

    apiVersion: "argoproj.io/v1alpha1"
    kind:       "AnalysisTemplate"
    metadata: {
      name: parameter.name
      namespace: parameter.namespace
      labels: {
        if parameter.labels != _|_ {
          parameter.labels
        }
      }
      annotations: {
        if parameter.annotations != _|_ {
          parameter.annotations
        }
      }
    }
    spec: {
      if parameter.args != _|_ {
        args: [for v in parameter.args {
          {
            if v.name != _|_ {
							name: v.name
            }
            if v.value != _|_ {
              value: v.value
            }
        }}
        ]
      }
      if parameter.templates != _|_ {
        templates: [for v in parameter.templates {
          {
            if v.templateName != _|_ {
              templateName: v.templateName
            }
            if v.clusterScope != _|_ {
              clusterScope: v.clusterScope
            }
          }}
        ]
      }
      if parameter.dryRunMetricName != _|_ {
        dryRun: [for v in parameter.dryRunMetricName {
          metricName: v
        }]
      }
      if parameter.metrics != _|_ {
        metrics: [for v in parameter.metrics {
          {
            if v.name != _|_ {
              name: v.name
            }
            if v.consecutiveSuccessLimit != _|_ {
              consecutiveSuccessLimit: v.consecutiveSuccessLimit
            }
            if v.failureCondition != _|_ {
              failureCondition: v.failureCondition
            }
            if v.failurelimit != _|_ {
              failurelimit: v.failurelimit
            }
            if v.successcondition != _|_ {
              successcondition: v.successcondition
            }
            if v.initialdelay != _|_ {
              initialdelay: v.initialdelay
            }
            if v.count != _|_ {
              count: v.count
            }
            if v.interval != _|_ {
              interval: v.interval
            }
            if v.provider.query != _|_ {
              provider: {
                prometheus: {
                  address:  v.provider.address
                  query:    v.provider.query
                  if v.provider.timeout != _|_ {
                    timeout: v.provider.timeout
                  }
                }
              }
            }
          }}
        ]
      }
    }
  }
}
