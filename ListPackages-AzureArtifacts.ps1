#$PAT = ""

#$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) } + @{"Content-Type"="application/json"; "Accept"="application/json"}

$token = $(az account get-access-token --resource "499b84ac-1321-427f-aa17-267ca6975798" --queryaccessToken --output tsv)

$header = @{

      'Authorization' = 'Bearer '+ $token

      'Content-Type' = 'application/json'

      }

$URL = https://feeds.dev.azure.com/<ORG-Name>/_apis/packaging/Feeds/<feed-id>/packages?api-version=7.1-preview.1

$feeds = (Invoke-RestMethod -Method Get -Uri $URL -Headers $header)

$UserGroupsObject = @()

Write-Host "ID                          Version `n" -ForegroundColor Green

foreach($pack in $feeds.value)

{

    $UserGroupsObject += New-Object -TypeName PSObject-Property @{

    name = $pack.name;

    version = $pack.versions.version;

    }

}

$UserGroupsObject | Export-CSV -Path "C:\Feeds.csv"
