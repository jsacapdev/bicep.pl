@description('The location into which the resources should be deployed.')
param location string = 'test'

@minLength(3)
@maxLength(24)
@description('The application insights name.')
param applicationInsightsName string = 'test' 

resource appi 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output applicationInsightsInstrumentationKey string = appi.properties.InstrumentationKey
