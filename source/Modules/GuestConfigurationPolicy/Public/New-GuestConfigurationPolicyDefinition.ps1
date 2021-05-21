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
        $PolicyInfo
    )

    Write-Verbose -Message "Creating new Guest Configuration Policy to '$PolicyFolderPath'."

    if (Test-Path -Path $PolicyFolderPath)
    {
        $null = Remove-Item -Path $PolicyFolderPath -Force -Recurse -ErrorAction 'SilentlyContinue'
    }

    $null = New-Item -Path $PolicyFolderPath -ItemType 'Directory'

    if ($PolicyInfo.FileName -eq 'DeployIfNotExists.json')
    {
        foreach ($currentDeployPolicyInfo in $PolicyInfo)
        {
            $currentDeployPolicyInfo['FolderPath'] = $PolicyFolderPath
            New-GuestConfigurationDeployPolicyDefinition @currentDeployPolicyInfo
        }
    }
    else
    {
        foreach ($currentAuditPolicyInfo in $PolicyInfo)
        {
            $currentAuditPolicyInfo['FolderPath'] = $PolicyFolderPath
            New-GuestConfigurationAuditPolicyDefinition @currentAuditPolicyInfo
        }
    }
}
