$clientId = Get-AutomationVariable -Name 'client-id' { //Azure AD Service Principle ID to get the list of service principles from Azure AD
$tenantId = Get-AutomationVariable -Name 'tenant-id'  { //Azure AD Tenant ID 
$readerSPNSecret = Get-AutomationVariable -Name 'app-Secret'   { //Azure AD Service Principle Client Secret to et the list of service principles from Azure AD 
$emailSender = Get-AutomationVariable -Name 'email-sender'  { //Sender Email ID to Send Emails
$emailTo = Get-AutomationVariable -Name 'email-to'    { //Destinantion Email ID

[int32]$expirationDays = 90


Function Connect-MSGraphAPI {
    param (
        [system.string]$emailSender,
        [system.string]$emailTo,
        [system.string]$clientId,
        [system.string]$tenantId,
        [system.string]$readerSPNSecret
    )
    begin {
        $URI = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
        $ReqTokenBody = @{
            Grant_Type    = "client_credentials"
            Scope         = "https://graph.microsoft.com/.default"
            client_Id     = $clientId
            Client_Secret = $readerSPNSecret
        } 
    }
    Process {
        Write-Host "Connecting to the Graph API"
        $Response = Invoke-RestMethod -Uri $URI -Method POST -Body $ReqTokenBody
    }
    End {
        $Response
    }
}

Function Get-MSGraphRequest {
    param (
        [system.string]$Uri,
        [system.string]$AccessToken
    )
    begin {
        [array]$allPages = @()
        $ReqTokenBody = @{
            Headers = @{
                "Content-Type"  = "application/json"
                "Authorization" = "Bearer $($AccessToken)"
            }
            Method  = "Get"
            Uri     = $Uri
        }
    }
    process {
        do {
            $data = Invoke-RestMethod @ReqTokenBody
            $allpages += $data.value
            if ($data.'@odata.nextLink') {
                $ReqTokenBody.Uri = $data.'@odata.nextLink'
            }
        } until (!$data.'@odata.nextLink')
    }
    end {
        $allPages
    }
}

Function Send-MSGraphEmail {
    param (
        [system.string]$Uri,
        [system.string]$AccessToken,
        [system.string]$To,
        [system.string]$Subject = "App Secret Expiration Notice",
        [system.string]$Body
    )
    begin {
        $headers = @{
            "Authorization" = "Bearer $($AccessToken)"
            "Content-type"  = "application/json"
        }

        $BodyJsonsend = @"
{
   "message": {
   "subject": "$Subject",
   "body": {
      "contentType": "HTML",
      "content": "$($Body)"
   },
   "toRecipients": [
      {
      "emailAddress": {
      "address": "$to"
          }
      }
   ]
   },
   "saveToSentItems": "true"
}
"@
    }
    process {
        $data = Invoke-RestMethod -Method POST -Uri $Uri -Headers $headers -Body $BodyJsonsend
    }
    end {
        $data
    }
}

$tokenResponse = Connect-MSGraphAPI -clientId $clientId -tenantId $tenantId -readerSPNSecret $readerSPNSecret

$array = @()
$apps = Get-MSGraphRequest -AccessToken $tokenResponse.access_token -Uri "https://graph.microsoft.com/v1.0/applications/" 
foreach ($app in $apps) {
    $app.passwordCredentials | foreach-object {
        #If there is a secret with a enddatetime, we need to get the expiration of each one
        if ($_.endDateTime -ne $null) {
            [system.string]$secretdisplayName = $_.displayName
            [system.string]$id = $app.id
            [system.string]$displayname = $app.displayName
            $Date = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($_.endDateTime, 'Central Standard Time')
            [int32]$daysUntilExpiration = (New-TimeSpan -Start ([System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now, "Central Standard Time")) -End $Date).Days
            
            if (($daysUntilExpiration -ne $null) -and ($daysUntilExpiration -le $expirationDays)) {
                $array += $_ | Select-Object @{
                    name = "id"; 
                    expr = { $id } 
                }, 
                @{
                    name = "displayName"; 
                    expr = { $displayName } 
                }, 
                @{
                    name = "secretName"; 
                    expr = { $secretdisplayName } 
                },
                @{
                    name = "daysUntil"; 
                    expr = { $daysUntilExpiration } 
                }
            }
            $daysUntilExpiration = $null
            $secretdisplayName = $null
        }
    }
}

if ($array -ne 0) {
    write-output "sending email"
    $textTable = $array | Sort-Object daysUntil | Select-Object displayName, secretName, daysUntil | ConvertTo-Html -Fragment
    Send-MSGraphEmail -Uri "https://graph.microsoft.com/v1.0/users/$emailSender/sendMail" -AccessToken $tokenResponse.access_token -To $emailTo  -Body $textTable 
}
else {
    write-output "No apps with expiring secrets"
}
