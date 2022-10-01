[string]$PATKey = "Your PAT here"

[string]$Organization = "Your ORG URL here"

 

$UserGroupsObject = @()

 

$PATKey | az devops login --org $Organization

 

az devops configure --defaults organization=$Organization

 

$Users = (az devops user list --org $Organization) | ConvertFrom-Json

 

foreach ($user in $Users.members) {

    $activeUserGroups = az devops security group membership list --id $user.user.principalName --org $Organization --relationship memberof | ConvertFrom-Json

    [array]$groups = ($activeUserGroups | Get-Member -MemberType NoteProperty).Name

 

    foreach ($group in $groups) {

        $UserGroupsObject += New-Object -TypeName PSObject -Property @{

            principalName = $user.user.principalName

            displayName   = $user.user.displayName

            GroupName     = $activeUserGroups.$group.principalName

        }

    }

}

 

$UserGroupsObject | Export-CSV -Path "C:\DevopsUsersAndAssignments.csv"
