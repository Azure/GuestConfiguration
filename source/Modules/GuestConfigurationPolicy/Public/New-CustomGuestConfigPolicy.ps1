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
        $AuditIfNotExistsInfo
    )

    $existingPolicies = Get-AzPolicyDefinition

    $existingAuditPolicy = $existingPolicies | Where-Object -FilterScript {
        ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and
        ($_.Properties.displayName -eq $AuditIfNotExistsInfo.DisplayName)
    }

    if ($null -ne $existingAuditPolicy)
    {
        Write-Verbose -Message "Found policy with name '$($existingAuditPolicy.Properties.displayName)' and guid '$($existingAuditPolicy.Name)'..."
        $AuditIfNotExistsInfo['Guid'] = $existingAuditPolicy.Name
    }

    New-GuestConfigurationPolicyDefinition @PSBoundParameters
}
