@description('automationAccountName')
param automationAccountName string

@description('Subnet Id for private endpoint creation')
param privateEndpointSubnetId string

@description('location')
param location string

@description('Application environment')
param environment string

@description('Application workload type')
param workload string

@description('subscription ID')
param subscriptionId string

@description('client ID')
param clientId string

@description('tenantId ID')
param tenantId string

@description('Azure Service Principle client Secret')
@secure()
param readerSPNSecret string

@description('ClientSecretExpiration notification receiver EmailI')
param emailSender string

@description(ClientSecretExpiration Notifications Sender EmailId')
param emailTo string



@description('Automation account private endpoint resource definition')
resource automationAccountPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: 'pep-${workload}-tooling-${environment}-${location}-01'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'plconnection-${workload}-tooling-${environment}'
        properties: {
          privateLinkServiceId: automationAccount.id
          groupIds: ['Webhook']
        }
      }
    ]
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

@description('Creating Automation account resource ')
resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: false
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {}
    }
  }
}

@description('A resource definition to variable') 
resource automationAccountsubscriptionIdVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'subscriptionId'
  properties: {
    isEncrypted: false
    value: '"${subscriptionId}"'
  }
}

@description('A resource definition variable') 
resource automationAccounreaderSPNSecretVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'readerSPNSecret'
  properties: {
    isEncrypted: true
    value: '"${readerSPNSecret}"'
  }
}

@description('A resource definition variable') 
resource automationAccountTenetIdVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'tenant-id'
  properties: {
    isEncrypted: false
    value: '"${tenantId}"'
  }
}

@description('A resource definition variable') 
resource automationAccountclientIdVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'client-id'
  properties: {
    isEncrypted: true
    value: '"${clientId}"'
  }
}
@description('A resource definition variable') 
resource automationAccountEmailSenderVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'emailSender'
  properties: {
    isEncrypted: true
    value: '"${EmailSender}"'
  }
}

@description('A resource definition variable') 
resource automationAccountEmailToVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'emailTo'
  properties: {
    isEncrypted: false
    value: '"${EmailTo}"'
  }
}
