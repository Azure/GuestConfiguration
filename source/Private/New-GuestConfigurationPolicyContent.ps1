function New-GuestConfigurationPolicyContent
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [String]
        $Description,

        [Parameter(Mandatory = $true)]
        [String]
        $PolicyVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter()]
        [String]
        $ContentManagedIdentity,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentHash,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Audit', 'ApplyAndMonitor', 'ApplyAndAutoCorrect')]
        [String]
        $AssignmentType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $PolicyId,

        [Parameter()]
        [Hashtable[]]
        $Parameter,

        [Parameter()]
        [Hashtable]
        $Tag,

        [Parameter()]
        [System.Boolean]
        $IncludeVMSS = $true
    )

    $metadataSectionParameters = @{
        DisplayName = $DisplayName
        Description = $Description
        PolicyVersion = $PolicyVersion
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }

    if ($ContentManagedIdentity)
    {
        $metadataSectionParameters.ContentManagedIdentity = $ContentManagedIdentity
    }

    $metadataSection = New-GuestConfigurationPolicyMetadataSection @metadataSectionParameters

    $parametersSection = New-GuestConfigurationPolicyParametersSection -Parameter $Parameter

    $conditionsSection = New-GuestConfigurationPolicyConditionsSection -Platform $Platform -Tag $Tag -IncludeVMSS $IncludeVMSS

    if ($ContentManagedIdentity)
    {
        foreach ($anyOf in $conditionsSection.anyOf)
        {
            foreach ($allOf in $anyOf.allOf)
            {
                if ($allOf.value -eq "[parameters('IncludeArcMachines')]")
                {
                    # Find and remove the specified section
                    $indexToRemove = $anyOf.allOf.IndexOf($allOf)
                    if ($indexToRemove -ne -1)
                    {
                        $anyOf.RemoveAt($indexToRemove)
                    }
                }
            }
        }

        if ($parametersSection.parameters.IncludeArcMachines)
        {
            $parametersSection.parameters.Remove("IncludeArcMachines")
        }
    }

    $actionSectionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        AssignmentType = $AssignmentType
        Parameter = $Parameter
        IncludeVMSS = $IncludeVMSS
    }

    if ($ContentManagedIdentity)
    {
        $actionSectionParameters.ContentManagedIdentity = $ContentManagedIdentity
    }

    $actionSection = New-GuestConfigurationPolicyActionSection @actionSectionParameters

    if ($ContentManagedIdentity -and $actionSection.details.deployment.properties.template.resources)
    {
        $tempResources = @()
        foreach ($resource in $actionSection.details.deployment.properties.template.resources)
        {
            if ($resource.condition -imatch "HybridCompute")
            {
                continue
            }
            $tempResources += $resource
        }
        $actionSection.details.deployment.properties.template.resources = $tempResources
    }

    $policyDefinitionContent = [Ordered]@{
        properties = $metadataSection + $parametersSection + [Ordered]@{
            policyRule = [Ordered]@{
                if = $conditionsSection
                then = $actionSection
            }
        }
        name = $PolicyId
    }

    return $policyDefinitionContent
}
