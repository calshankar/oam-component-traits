import (
        "strings"
        )
externalsecrets: {
	type: "trait"
	annotations: {}
	labels: {
		"ui-hidden": "false"
	}
	namespace:   "vela-system"
	description: "Inject a secret from your local clusters secret store into a secret in k8s. Consider to place it after a sidecar if you plan to add env vars to the sidecar."
	attributes: {
		podDisruptive: true
		appliesToWorkloads: ["*"]
	}
}
template: {
 	secretVolumesList: *[
				for v in parameter.externalSecrets if v.mountPath != _|_ {
			{
				_secretName: strings.Replace(strings.ToLower(v.name), "/", "-", -1)
				name: "secret-" + _secretName
				secret: {
					defaultMode: v.defaultMode
					secretName:  _secretName
				}
			}
		},
	] | []

	secretVolumeMountsList: *[
				for v in parameter.externalSecrets if v.mountPath != _|_ {
			{
				name:      "secret-" + strings.Replace(strings.ToLower(v.name), "/", "-", -1)
				mountPath: v.mountPath
			}
		},
	] | []

		secretEnvMountsList: *[
				for v in parameter.externalSecrets if v.mountToEnv  {
			{
				secretRef: {
					name: strings.Replace(strings.ToLower(v.name), "/", "-", -1)
				}
			}
		},
	] | []
	patch: spec: template: spec: {
		// +patchKey=name
		volumes: secretVolumesList

		containers: [{
			// +patchKey=name
			envFrom: secretEnvMountsList
			// +patchKey=name
			volumeMounts: secretVolumeMountsList
		}, ...]

	}
outputs:{
    if parameter.externalSecrets != _|_ {
        for c in parameter.externalSecrets if c.mountOnly == false {
            "ext-\(strings.Replace(strings.ToLower(c.name), "/", "-", -1))": {
                    apiVersion: "external-secrets.io/v1beta1"
                    kind:       "ExternalSecret"
                    metadata: name: strings.Replace(strings.ToLower(c.name), "/", "-", -1) + "-ext"
                    spec:
                    {
						refreshInterval: "1h"
						secretStoreRef:
						{
							kind: "ClusterSecretStore",
							name: "aws-sm"
						}
						target:
						{
							name: strings.Replace(strings.ToLower(c.name), "/", "-", -1)
							if c.template != _|_ {
							template: data: c.template
							}
						}
						dataFrom: [
								{
										extract: key: c.name
								},
						]
                    }
                }
        }
    }
}
parameter: {
    // +usage=Specify the names of the external secrets
    externalSecrets: [...{
    	name: string
    	template?:{...}
    	mountOnly: *false | bool
    	mountToEnv: *true | bool
    	mountPath?: string
    	defaultMode: *420 | int
    	}]
	}
}