# Bicep Resource Group and Storage

A simple first pass over bicep.

<https://github.com/Azure/bicep/blob/main/docs/tutorial/01-simple-template.md>

Has things like:

- parameters
- outputs
- modules
- calling it from az cli
- getting the results from the az cli

``` pwsh

az group create -n rg-bicep-dev-001 -l westeurope --debug

az deployment group create `
-f ./main.bicep `
-g rg-bicep-dev-001 `
--parameters location=westeurope `
environment=dev `
--debug

$var = (az deployment group create `
-f ./main.bicep `
-g rg-bicep-dev-001 `
--parameters location=westeurope `
storageAccountName=stbicep001 `
-o json `
--query properties.outputs.storageId.value `
| ConvertFrom-Json)

```
