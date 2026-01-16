function New-GuestConfigurationPolicyMetadataSection
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
        [ValidateNotNullOrEmpty()]
        [String]
        $PolicyVersion,

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
        [Hashtable[]]
        $Parameter,

        [Parameter()]
        [System.Boolean]
        $EnableAutoRemediation,

        [Parameter()]
        [ValidateSet('Audit', 'ApplyAndAutoCorrect', 'ApplyAndMonitor')]
        [String]
        $AssignmentType
    )

    $templateFileName = '1-Metadata.json'
    $propertiesSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    $propertiesSection.displayName = $DisplayName
    $propertiesSection.description = $Description

    $propertiesSection.metadata.version = $PolicyVersion

    $propertiesSection.metadata.guestConfiguration = [Ordered]@{
        name = $ConfigurationName
        version = $ConfigurationVersion
        contentType = 'Custom'
        contentUri = $ContentUri
        contentHash = $ContentHash
    }

    # Add assignmentType if EnableAutoRemediation is used
    if ($EnableAutoRemediation)
    {
        $propertiesSection.metadata.guestConfiguration.assignmentType = "[if(parameters('EnableAutoRemediation'),'$AssignmentType','Audit')]"
    }
    elseif ($null -ne $AssignmentType)
    {
        $propertiesSection.metadata.guestConfiguration.assignmentType = $AssignmentType
    }

    if (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId))
    {
        $propertiesSection.metadata.guestConfiguration.contentManagedIdentity = $ManagedIdentityResourceId
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $propertiesSection.metadata.guestConfiguration.configurationParameter = [Ordered]@{}

        foreach ($currentParameter in $Parameter)
        {
            $parameterName = $currentParameter['Name']
            $parameterReferenceString = New-GuestConfigurationPolicyParameterReferenceString -Parameter $currentParameter

            $propertiesSection.metadata.guestConfiguration.configurationParameter.$parameterName = $parameterReferenceString
        }
    }

    return $propertiesSection
}
