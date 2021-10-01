@description('The location into which the resources should be deployed.')
param location string = 'test'

@description('The name of the function app plan.')
param functionAppPlanName string = 'test'

@description('The name of the function app.')
param functionAppName string = 'test'

@description('The application insights instrumentation key.')
param applicationInsightsInstrumentationKey string = 'test'


@description('The storage account name.')
param storageAccountName string = 'test'

@description('The storage account key.')
@secure()
param storageAccountKey string

@description('The name of the function app sku.')
param functionAppPlanSku string = 'P1v2'

@description('The name of the function app tier.')
param functionAppPlanTier string = 'PremiumV2'

param functionPlanOS string = 'Windows'

var isReserved = (functionPlanOS == 'Linux') ? true : false

resource plan 'Microsoft.Web/serverfarms@2021-01-01' = {
  location: location
  name: functionAppPlanName
  sku: {
    name: functionAppPlanSku
    tier: functionAppPlanTier
    size: functionAppPlanSku
    family: functionAppPlanSku
    capacity: 3
  }
  kind: 'elastic'
  properties: {
    maximumElasticWorkerCount: 1
    reserved: isReserved
    zoneRedundant: true
  }
}

resource functionApp 'Microsoft.Web/sites@2021-01-01' = {
  location: location
  name: functionAppName
  kind: isReserved ? 'functionapp,linux' : 'functionapp'
  dependsOn: [
    plan
  ]
  properties: {
    serverFarmId: plan.id
    reserved: isReserved
    siteConfig: {
      linuxFxVersion: isReserved ? 'dotnet|3.1' : json('null')
      alwaysOn: true
      vnetRouteAllEnabled: true
      healthCheckPath: 'api/hc'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsInstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: '1'
        }
      ]
    }
  }
}
