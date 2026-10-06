serviceaccount: {
	type: "trait"
	annotations: {}
    namespace: "vela-system"
	description: "create a serviceaccount and inject it into your workload."
	attributes: {
		podDisruptive: true
		appliesToWorkloads: ["*"]
	}
}
template:{


	patch: {
		_contextType: context.output.kind
		if _contextType == "CronJob" {
			spec: jobTemplate: spec: template: spec: serviceAccountName: parameter.name
		}
		if _contextType != "CronJob" {
			spec: template: spec: serviceAccountName: parameter.name
		}

	}
	outputs : serviceaccount: {
        apiVersion: "v1"
        kind: "ServiceAccount"
        metadata: {
        	if parameter.annotations != _|_{
        	 annotations: parameter.annotations
        	}
        	if parameter.labels != _|_{
        	 labels: parameter.labels
        	}
        	name: parameter.name
        }

	}
	parameter: {
      name: * (context.name) | string
      labels?: [string]:string
      annotations?: [string]:string
	}
}