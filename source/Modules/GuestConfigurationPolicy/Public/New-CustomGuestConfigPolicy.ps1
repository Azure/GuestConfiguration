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

    # policy.name is actually the policy id
    $existingAuditPolicy = $existingPolicies | Where-Object -FilterScript {
        ($_.name -eq $PolicyInfo.guid)
    }

    if ($null -ne $existingAuditPolicy)
    {
        Write-Verbose -Message "Policy with specified guid '$($existingAuditPolicy.Name)' already exists. Overwriting: '$($existingAuditPolicy.Properties.displayName)' ..."
    }

    New-GuestConfigurationPolicyDefinition @PSBoundParameters
}
