@description('Environment name')
@allowed([
  'prd'
  'dev'
])
param environment string

var environmentConfigurationMap = {
  dev: {
    privateEndpointVnet: { // Private endpoint VNet settings
      resoureGroupName: 'iw-vnet-eastus2'
      virtualNetworkName: 'iw-vnet-eastus2-f5d606b1-21fd-4844-9e05-e859515fc168' // Name of the VNet
      subnetName: 'snet-corp-development-01-privateendpoint-eastus2-01'
    }
  }
  prd: {
    privateEndpointVnet: { // Private endpoint VNet settings
      resoureGroupName: 'iw-vnet-eastus2'
      virtualNetworkName: 'iw-vnet-eastus2-f5d606b1-21fd-4844-9e05-e859515fc168' // Name of the VNet
      subnetName: 'snet-corp-development-01-privateendpoint-eastus2-01'
    }
  }
}

output settings object = environmentConfigurationMap[environment]
