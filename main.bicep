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

module storageAccount './module/storage/storage-accounts/main.bicep' = {
  scope: resourceGroup(resourceParam.sharedRgName)
  name: resourceParam.name
  params: {
    name: resourceParam.name
    tags: resourceParam.tags
    location: resourceParam.location
    kind: resourceParam.kind
    skuName: resourceParam.skuName
    diagnosticWorkspaceId: resourceParam.diagnosticWorkspaceId
    blobServices: {
        //name: format('{0}-blob',sa.blobServices)
        name: resourceParam.blobServices
        tags: resourceParam.tags
        //deleteRetentionPolicy : 
    }
  }
}





    
  

 

