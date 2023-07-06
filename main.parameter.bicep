targetScope = 'subscription'
@description('Optional. Specifies the location for resources.')
param location string ='westus3'
param AppRgName string = 'RGAmeth'
//param sku string = 'S1'
param planName string = 'ameth-appServicePlan'
param webAppName string = 'ameth-webApp'
param virtualNetwork string = 'Ameth-virtual-network'

var resourceParam = {
  AppRgName: AppRgName
  planName: planName
  webAppName: webAppName
  virtualNetwork: virtualNetwork
  //sku: sku
  tags: {
    testtag: 'testtag1'
  }
 
}

module appDeployment 'main.bicep' = {
  name: '${uniqueString(deployment().name)}-${AppRgName}'
  params: {
    location: location
    resourceParam: resourceParam
  }
}
