param($ResourceGroup, $automationAccountName)

$clientSecretExpiration = 'clientSecretExpiration'


Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration -Path "./infrastructure/runbooks/client-secret-expiration.ps1" -Published -Type PowerShell -Force

# Get the imported runbook
$runbook = Get-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration

# Update the runbook to use PowerShell version 7.2
$runbook.Properties.RunbookType = 'PowerShell72'
Update-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration -Runbook $runbook.Properties

