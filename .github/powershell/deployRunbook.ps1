param($ResourceGroup, $automationAccountName)

$clientSecretExpiration = 'clientSecretExpiration'


Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration -Path "./infrastructure/runbooks/client-secret-expiration.ps1" -Published -Type PowerShell -Force

# Get the runbook
$runbook = Get-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration

# Get the content of the existing runbook
$runbookContent = Get-AzAutomationRunbookContent -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration

# Create a new version of the runbook with PowerShell 7.2
$updatedRunbookContent = @{
    Description = $runbook.Properties.Description
    Content = $runbookContent.Content
    Kind = 'PowerShell'
    LogProgress = $runbook.Properties.LogProgress
    LogVerbose = $runbook.Properties.LogVerbose
}

# Update the existing runbook with the new version
Set-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration -Type PowerShell -Content $updatedRunbookContent -Force

# Publish the runbook to make the changes effective
Publish-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $clientSecretExpiration -Force
