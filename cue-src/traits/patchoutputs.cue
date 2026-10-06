patchoutputs: {
  type: "trait"
    annotations: {}
      namespace: "vela-system"
    description: "a general purpose trait to patch the output of the workload and other traits. Place it after the appropiate trait if you want to consider the output of them."
    attributes: {
      podDisruptive: true
        appliesToWorkloads: ["*"]
    }
}
template:{

	patch: {
	if parameter.component != _|_ {
	parameter.component
	}
}

  	patchOutputs: {
  		   if parameter.traits != _|_ {
  	  	parameter.traits
  }

  }

parameter: {
    component?: {...}
    traits?: {...}
}

}