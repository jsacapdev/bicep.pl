@description('The location into which the resources should be deployed.')
param location string = 'test'

@description('The name of the function app plan.')
param functionAppPlanName string = 'test'

@description('The name of the function app sku.')
param functionAppPlanSku string = 'P1v2'

@description('The name of the function app tier.')
param functionAppPlanTier string = 'PremiumV2'

param functionPlanOS string = 'Linux'

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
