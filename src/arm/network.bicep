@description('The location into which the resources should be deployed.')
param location string = 'test'

@description('The name of the app virtual network.')
param applicationVirtualNetworkName string = 'test'

@description('The subnet for the function app.')
param applicationFunctionSubnetName string = 'test'

@description('The subnet for the function app.')
param applicationPrivateEndpointSubnetName string = 'test'

@description('The IP adddress space used for application the virtual network.')
param applicationVirtualNetworkAddressPrefix string = '10.100.0.0/16'

@description('The subnet address for the function app.')
param applicationFunctionSubnetAddressPrefix string = '10.100.0.0/24'

@description('The subnet address for the function app.')
param applicationPrivateEndpointSubnetAddressPrefix string = '10.100.1.0/24'

var privateStorageFileDnsZoneName = 'privatelink.file.${environment().suffixes.storage}'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: applicationVirtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        applicationVirtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: applicationFunctionSubnetName
        properties: {
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          delegations: [
            {
              name: 'webapp'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
          addressPrefix: applicationFunctionSubnetAddressPrefix
        }
      }
      {
        name: applicationPrivateEndpointSubnetName
        properties: {
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          addressPrefix: applicationPrivateEndpointSubnetAddressPrefix
        }
      }
    ]
  }
}

// -- Private DNS Zones --
resource storageFileDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateStorageFileDnsZoneName
  location: 'global'
}
