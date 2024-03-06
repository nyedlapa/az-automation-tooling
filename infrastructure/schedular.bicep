@description('Workload name')
param workload string

@description('Environment name')
param environment string

@description('Resource Group location')
param location string


@description('Send Email Alert')
var clientSecretExpirationRunbook = 'clientSecretExpiration'

var automationAccountName = 'aa-${workload}-${environment}-${location}-01'

@description('Parameter to store the curent time')
param Time string = utcNow()

param startTimeUtc string = utcNow()
param delayMinutes int = 25

@description('Creating Automation account resource ')
resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

@description('Creating a schedule for clientSecretExpiration')
resource clientSecretExpiration 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: 'clientSecretExpiration'
  properties: {
    description: 'Run every day once'
    startTime: '${startTimeUtc} + duration(\'PT\' + string${delayMinutes} + \'M\')'
    expiryTime: '9999-12-31T17:59:00-06:00'
    interval: 1
    frequency: 'day'
    timeZone: 'America/Chicago'
  }
}

@description('Creating a job schedule forclientSecretExpiration')
resource AddDenyResourcePolicyjobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
  parent: automationAccount
  // name: guid(resourceGroup().id, 'clientSecretExpiration')
  name: guid(Time,'clientSecretExpiration')
  properties: {
    runbook: {
      name: clientSecretExpirationRunbook
    }
    schedule: {
      name: 'clientSecretExpiration'
    }
  }
}
