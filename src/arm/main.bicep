@minLength(3)
@maxLength(4)
@description('The environment name.')
param environment string = 'prod'

@description('The location into which the resources should be deployed.')
param location string = 'test'

var storageAccountName = 'stbicep${environment}001'

module stg './storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

output storageId string = stg.outputs.storageId
