@minLength(3)
@maxLength(4)
@description('The environment name.')
param environment string = 'prod'

var product = 'bicep'

var location = resourceGroup().location

var storageAccountName = 'st${product}${environment}001'
var applicationInsightsName = 'appi-${product}-${environment}-001'

module appi './appi.bicep' = {
  name: 'appiDeploy'
  params: {
    location: location
    applicationInsightsName: applicationInsightsName
  }
}


module stg './storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

output storageId string = stg.outputs.storageId
