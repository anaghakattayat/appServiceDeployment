targetScope = 'subscription'
@description('Optional. Specifies the location for resources.')
param location string ='westus3'
param AppRgName string = 'RGAmeth-2'
//param sku string = 'S1'
param planName string = 'ameth-appServicePlan-2'
param webAppName string = 'ameth-webApp-2'
param virtualNetwork string = 'Ameth-virtual-network-2'
param slotWebAppName string = 'slot-WebAppName-2'
param logAnalyticsWorkspace string = 'loganalyticsws2'
param retentionInDays int = 30
param appInsights string = 'appInsights2'
param appSettings string = 'appSettings2'
param keyVault string = 'keyVaultameth1'

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
  keyVault : keyVault
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
