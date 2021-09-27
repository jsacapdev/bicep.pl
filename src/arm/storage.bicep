@description('The location into which the resources should be deployed.')
param location string = 'test'

@minLength(3)
@maxLength(24)
@description('The storage account name.')
param storageAccountName string = 'test' 

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageId string = stg.id
output storageAccountName string = stg.name
output storageAccountPrimaryKey string = stg.listKeys().keys[0].value

