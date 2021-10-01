@description('The location into which the resources should be deployed.')
param location string = 'test'

@description('The name of the app virtual network.')
param applicationVirtualNetworkName string = 'test'

@description('The IP adddress space used for application the virtual network.')
param applicationVirtualNetworkAddressPrefix string = '10.100.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: applicationVirtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        applicationVirtualNetworkAddressPrefix
      ]
    }
  }
}
