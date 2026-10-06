---
title:  Externalsecrets
---

## Description

Inject a secret from your local clusters secret store into a secret in k8s. Consider to place it after a sidecar if you plan to add env vars to the sidecar.

### Apply To Component Types

All Component Types


## Specification


 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 externalSecrets | Specify the names of the external secrets. | [[]externalSecrets](#externalsecrets) | true |  


#### externalSecrets

 Name | Description | Type | Required | Default 
 ---- | ----------- | ---- | -------- | ------- 
 name |  | string | true |  
 template |  | map[string]_ | false |  
 mountOnly |  | bool | false | false 
 mountToEnv |  | bool | false | true 
 mountPath |  | string | false |  
 defaultMode |  | int | false | 420 

