@description('Environment name')
@allowed([
  'prd'
  'dev'
])
param environment string

var environmentConfigurationMap = {
  dev: {
    subscriptionId: '936afe5d-a7a5-44e9-830b-7b819d0ba031'
    clientId: 'bf470a56-215c-4167-9cbf-7f8ce87afc2a'  { //Need to add Client ID
    tenantId: 'e3615ed9-9f3a-43e1-9e3b-112a500f6652'  { // Need to add TenantID
    privateEndpointVnet: { // Private endpoint VNet settings
      resoureGroupName: 'fbitn-vnet-eastus2'
      virtualNetworkName: 'vnet-corp-development-01-eastus2-01' // Name of the VNet
      subnetName: 'snet-corp-development-01-privateendpoint-eastus2-01'
    }
  }
  prd: {
    subscriptionId: '8aa959df-fa01-4029-992f-bae1a25402f7'
    clientId: 'bf470a56-215c-4167-9cbf-7f8ce87afc2a'
    tenantId: 'e3615ed9-9f3a-43e1-9e3b-112a500f6652'
    privateEndpointVnet: { // Private endpoint VNet settings
      resoureGroupName: 'fbitn-vnet-eastus2'
      virtualNetworkName: 'vnet-corp-production-01-eastus2-01' // Name of the VNet
      subnetName: 'snet-corp-production-01-privateendpoint-eastus2-01'
    }
  }
}

output settings object = environmentConfigurationMap[environment]
