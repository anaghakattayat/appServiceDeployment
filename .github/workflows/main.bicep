
targetScope = 'subscription'

@description('The location into which your Azure resources should be deployed.')
param location string

@description('Required. The resource properties')
param resourceParam object

// Resource Group
module rg '/modules/Resources/resource-groups/main.bicep' = {
  name: '${deployment().name}-rg'
  params: {
    name: resourceParam.AppRgName
    location: location
    tags: resourceParam.tags
  }
}
