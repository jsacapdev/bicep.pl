@description('The location into which the resources should be deployed.')
param location string = 'test'

@description('The name of the function app plan.')
param functionAppPlanName string = 'test'

@description('The name of the function app.')
param functionAppName string = 'test'

@description('The application insights instrumentation key.')
param applicationInsightsInstrumentationKey string = 'test'

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
  }
  kind: 'elastic'
  properties: {
    maximumElasticWorkerCount: 1
    reserved: isReserved
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
      functionsRuntimeScaleMonitoringEnabled: true
      linuxFxVersion: isReserved ? 'dotnet|3.1' : json('null')
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsInstrumentationKey
        }
      ]
    }
  }
}
