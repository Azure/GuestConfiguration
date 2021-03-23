
<#
    .SYNOPSIS
        Publishes the Guest Configuration policy in Azure Policy Center.

    .Parameter Path
        Guest Configuration policy path.

    .Example
        Publish-GuestConfigurationPolicy -Path ./git/custom_policy
#>

function Publish-GuestConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $ManagementGroupName
    )

    $rmContext = Get-AzContext
    Write-Verbose -Message "Publishing Guest Configuration policy using '$($rmContext.Name)' AzContext."

    # Publish policies
    $policyFile = Join-Path -Path $Path -ChildPath 'AuditIfNotExists.json'
    $jsonDefinition = Get-Content -Path $policyFile | ConvertFrom-Json | ForEach-Object { $_ }
    $definitionContent = $jsonDefinition.Properties

    $newAzureRmPolicyDefinitionParameters = @{
        Name        = $jsonDefinition.name
        DisplayName = $($definitionContent.DisplayName | ConvertTo-Json -Depth 20).replace('"', '')
        Description = $($definitionContent.Description | ConvertTo-Json -Depth 20).replace('"', '')
        Policy      = $($definitionContent.policyRule | ConvertTo-Json -Depth 20)
        Metadata    = $($definitionContent.Metadata | ConvertTo-Json -Depth 20)
        ApiVersion  = '2018-05-01'
        Verbose     = $true
    }

    if ($definitionContent.PSObject.Properties.Name -contains 'parameters')
    {
        $newAzureRmPolicyDefinitionParameters['Parameter'] = ConvertTo-Json -InputObject $definitionContent.parameters -Depth 15
    }

    if ($ManagementGroupName)
    {
        $newAzureRmPolicyDefinitionParameters['ManagementGroupName'] = $ManagementGroupName
    }

    Write-Verbose -Message "Publishing '$($jsonDefinition.properties.displayName)' ..."
    New-AzPolicyDefinition @newAzureRmPolicyDefinitionParameters
}
