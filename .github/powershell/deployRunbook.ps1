param($ResourceGroup, $automationAccountName)

$clientSecretExpiration = 'clientSecretExpiration'


Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration -Path "./infrastructure/runbooks/client-secret-expiration.ps1" -Published -Type PowerShell -Force -Version '7.0'
