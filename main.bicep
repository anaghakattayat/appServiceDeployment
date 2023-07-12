targetScope = 'subscription'

@description('The location into which your Azure resources should be deployed.')
param location string

@description('Required. The resource properties')
param resourceParam object

// Resource Group
// module rg './module/resources/resource-groups/main.bicep' = {
//   name: '${deployment().name}-rg'
//   params: {
//     name: resourceParam.AppRgName
//     location: location
//     tags: resourceParam.tags
//   }
// }

// Virtual-network
module virtualnetwork 'module/network/virtual-networks/main.bicep' = {
  scope: resourceGroup(resourceParam.AppRgName)
  name: resourceParam.virtualNetwork
  params: {
    location: location
    name: resourceParam.virtualNetwork
    tags: resourceParam.tags
    addressPrefixes:['10.7.0.0/16']
  }
}

 //App service plan
 module serverfarms 'module/web/serverfarms/main.bicep' = {
  scope: resourceGroup(resourceParam.AppRgName)
  name: resourceParam.planName
  params: {
    location: location
    name: resourceParam.planName
    tags: resourceParam.tags
    sku: resourceParam.sku
//    dependsOn: [
//   //   rg.outputs.name
//   // ]
 }
 }

 //App service 
 module sites 'module/web/sites/main.bicep'= {
  scope: resourceGroup(resourceParam.AppRgName) 
  name : resourceParam.webAppName
  params: {
    location: location
    name: resourceParam.webAppName
    serverFarmResourceId: serverfarms.outputs.resourceId
    appInsightResourceId: operationalInsights.outputs.resourceId
    kind: 'app'
   }
 }

 // slot
 module slots 'module/web/sites/slots/main.bicep' = {
 scope: resourceGroup(resourceParam.AppRgName) 
 name:  resourceParam.slotWebAppName
 params: {
   appName: resourceParam.webAppName
   kind: 'app'
   name: resourceParam.slotWebAppName
   location: location
   }
 }

//log Analytics Workspace

module operationalInsights 'module/operational-insights/workspaces/main.bicep' = {
  scope: resourceGroup(resourceParam.AppRgName) 
  name:  resourceParam.logAnalyticsWorkspace
  params: {
    name: resourceParam.logAnalyticsWorkspace
    location: location
    dataRetention: resourceParam.retentionInDays
  }
}

//app insights

module appInsights 'module/insights/components/main.bicep' ={
  scope: resourceGroup(resourceParam.AppRgName) 
  name:  resourceParam.appInsights
  params: {
    name: resourceParam.appInsights
    location: location
    workspaceResourceId : operationalInsights.outputs.resourceId
  }
}

//App service  - app settings

module sitesConfig 'module/web/sites/config--appsettings/main.bicep'= {
  scope: resourceGroup(resourceParam.AppRgName) 
  name : resourceParam.appSettings
  //parent: sites.name
  params: {
   kind: 'app'
   appName: resourceParam.webAppName
   appSettingsKeyValuePairs:  {
   APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.outputs.instrumentationKey
    }   
  }  
  dependsOn: [
    sites
  ]
}


//key vault 

module keyvault 'module/key-vault/vaults/main.bicep' = {
  scope: resourceGroup(resourceParam.AppRgName)   
  name: resourceParam.keyVault
  params: {
   name: resourceParam.keyVault
   location: location
  }
}


