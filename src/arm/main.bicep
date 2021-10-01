@minLength(3)
@maxLength(4)
@description('The environment name.')
param environment string = 'prod'

//////////////////////
// global variables 
//////////////////////

// the name of the product 
var product = 'bicep'

// the location derived from a expression
var location = resourceGroup().location

// the global variables defined in the top level main bicep file
var storageAccountName = 'st${product}${environment}001'
var applicationInsightsName = 'appi-${product}-${environment}-001'
var functionAppPlanName = 'plan-${product}-${environment}-001'
var functionAppName = 'function-${product}-${environment}-001'

var applicationVirtualNetworkName = 'vnet-app-${environment}-${location}-001'
var functionSubnetName = 'snet-app-${environment}-${location}-001'

// application insights
module appi './appi.bicep' = {
  name: 'appiDeploy'
  params: {
    location: location
    applicationInsightsName: applicationInsightsName
  }
}

// storage account
module stg './storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

// storage account
module network './network.bicep' = {
  name: 'networkDeploy'
  params: {
    location: location
    applicationVirtualNetworkName: applicationVirtualNetworkName
  }
}

// the function plan and app
module function './function.bicep' = {
  name: 'functionAppDeploy'
  params: {
    location: location
    functionAppPlanName: functionAppPlanName
    functionAppName: functionAppName
    applicationInsightsInstrumentationKey: appi.outputs.applicationInsightsInstrumentationKey
    storageAccountName: stg.outputs.storageAccountName
    storageAccountKey: stg.outputs.storageAccountPrimaryKey
  }
}

output storageId string = stg.outputs.storageId
