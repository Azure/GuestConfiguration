function New-GuestConfigurationPolicyActionSection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter()]
        [String]
        $ManagedIdentityResourceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [ValidateSet('Audit', 'ApplyAndAutoCorrect', 'ApplyAndMonitor')]
        [String]
        $AssignmentType = 'Audit',

        [Parameter()]
        [Hashtable[]]
        $Parameter,

        [Parameter()]
        [System.Boolean]
        $IncludeVMSS = $true
    )

    if ($AssignmentType -ieq 'Audit')
    {
        $actionSection = New-GuestConfigurationPolicyAuditActionSection -ConfigurationName $ConfigurationName -Parameter $Parameter
    }
    else
    {
        $setActionSectionParameters = @{
            ConfigurationName = $ConfigurationName
            ConfigurationVersion = $ConfigurationVersion
            ContentUri = $ContentUri
            ContentHash = $ContentHash
            AssignmentType = $AssignmentType
            Parameter = $Parameter
            IncludeVMSS = $IncludeVMSS
        }

        if (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId))
        {
            $setActionSectionParameters.ContentManagedIdentity = $ManagedIdentityResourceId
        }

        $actionSection = New-GuestConfigurationPolicySetActionSection @setActionSectionParameters
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $complianceCondition = $actionSection.details.existenceCondition

        $parameterHashStringList = @()

        foreach ($currentParameter in $Parameter)
        {
            $parameterReference = New-GuestConfigurationPolicyParameterReferenceString -Parameter $currentParameter
            $parameterValue = "parameters('$($currentParameter['Name'])')"
            $currentParameterHashString = "'$parameterReference', '=', $parameterValue"
            $parameterHashStringList += $currentParameterHashString
        }

        $concantenatedParameterHashStrings = $parameterHashStringList -join ", ',', "
        $parameterHashString = "[base64(concat($concantenatedParameterHashStrings))]"

        $parameterCondition = [Ordered]@{
            field = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
            equals = $parameterHashString
        }

        $actionSection.details.existenceCondition = [Ordered]@{
            allOf = @(
                $complianceCondition,
                $parameterCondition
            )
        }
    }

    return $actionSection
}
