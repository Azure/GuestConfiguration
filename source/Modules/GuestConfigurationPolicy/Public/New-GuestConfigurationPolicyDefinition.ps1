<#
    .SYNOPSIS
        Creates a new policy for guest configuration.
#>
function New-GuestConfigurationPolicyDefinition
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $AuditIfNotExistsInfo
    )

    if (Test-Path -Path $PolicyFolderPath)
    {
        $null = Remove-Item -Path $PolicyFolderPath -Force -Recurse -ErrorAction 'SilentlyContinue'
    }

    $null = New-Item -Path $PolicyFolderPath -ItemType 'Directory'

    foreach ($currentAuditPolicyInfo in $AuditIfNotExistsInfo)
    {
        $currentAuditPolicyInfo['FolderPath'] = $PolicyFolderPath
        New-GuestConfigurationAuditPolicyDefinition @currentAuditPolicyInfo
    }
}
