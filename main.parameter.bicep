targetScope = 'subscription'
@description('Optional. Specifies the location for resources.')
param location string ='westus3'
param AppRgName string = 'RGAmeth-1'
//param sku string = 'S1'
param planName string = 'ameth-appServicePlan-1'
param webAppName string = 'ameth-webApp-1'
param virtualNetwork string = 'Ameth-virtual-network-1'
param slotWebAppName string = 'slot-WebAppName-1'
param logAnalyticsWorkspace string = 'loganalyticsws1'
param retentionInDays int = 30
param appInsights string = 'appInsights1'
param appSettings string = 'appSettings1'
param sku object = {
  name: 'S1'
  tier: 'S1'
}

var resourceParam = {
  AppRgName: AppRgName
  planName: planName
  webAppName: webAppName
  virtualNetwork: virtualNetwork
  slotWebAppName : slotWebAppName
  logAnalyticsWorkspace : logAnalyticsWorkspace
  retentionInDays : retentionInDays
  appInsights : appInsights
  appSettings : appSettings
  sku: sku
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
