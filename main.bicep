targetScope = 'subscription'

@description('The location into which your Azure resources should be deployed.')
param location string

@description('Required. The resource properties')
param resourceParam object

// Resource Group
module rg './module/resources/resource-groups/main.bicep' = {
  name: '${deployment().name}-rg'
  params: {
    name: resourceParam.AppRgName
    location: location
    tags: resourceParam.tags
  }
}

// Virtual-network
module virtualnetwork 'modules/network/virtual-networks/main.bicep' = {
  scope: resourceGroup(resourceParam.AppRgName)
  name: resourceParam.virtualNetwork
  params: {
    location: location
    name: resourceParam.virtualNetwork
    tags: resourceParam.tags
    addressPrefixes:['10.7.0.0/16']
  }
}
