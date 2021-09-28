@minLength(3)
@maxLength(4)
@description('The environment name.')
param environment string = 'prod'

var location = resourceGroup().location

var storageAccountName = 'stbicep${environment}001'

module stg './storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

output storageId string = stg.outputs.storageId
