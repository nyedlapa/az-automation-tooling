@description('Environment name')
@allowed([
  'prd'
  'dev'
])
param environment string

var environmentConfigurationMap = {
  dev: {
    subscriptionId: 'f5d606b1-21fd-4844-9e05-e859515fc168'
    clientId: 'edaae7d6-2147-4102-809c-7fa44a06f716'
    tenantId: '95933331-9c40-4ebf-9199-cd4c72f03a84'
    privateEndpointVnet: { // Private endpoint VNet settings
       resoureGroupName: 'iw-vnet-eastus2'
      virtualNetworkName: 'iw-vnet-eastus2-f5d606b1-21fd-4844-9e05-e859515fc168' // Name of the VNet
      subnetName: 'snet-corp-development-01-privateendpoint-eastus2-01
    }
  }
  prd: {
    subscriptionId: 'f5d606b1-21fd-4844-9e05-e859515fc168'
    clientId: 'edaae7d6-2147-4102-809c-7fa44a06f716'
    tenantId: '95933331-9c40-4ebf-9199-cd4c72f03a84'
    privateEndpointVnet: { // Private endpoint VNet settings
      resoureGroupName: 'iw-vnet-eastus2'
      virtualNetworkName: 'iw-vnet-eastus2-f5d606b1-21fd-4844-9e05-e859515fc168' // Name of the VNet
      subnetName: 'snet-corp-development-01-privateendpoint-eastus2-01'
    }
  }
}

output settings object = environmentConfigurationMap[environment]
