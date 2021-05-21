function New-CustomGuestConfigPolicy
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $PolicyInfo
    )

    Write-Verbose -Message "Getting Policy Definitions from Current Context."

    $existingPolicies = Get-AzPolicyDefinition

    $existingAuditPolicy = $existingPolicies | Where-Object -FilterScript {
        ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and
        ($_.Properties.displayName -eq $PolicyInfo.DisplayName)
    }

    if ($null -ne $existingAuditPolicy)
    {
        Write-Verbose -Message "Found policy with name '$($existingAuditPolicy.Properties.displayName)' and guid '$($existingAuditPolicy.Name)'..."
        $PolicyInfo['Guid'] = $existingAuditPolicy.Name
    }

    New-GuestConfigurationPolicyDefinition @PSBoundParameters
}
