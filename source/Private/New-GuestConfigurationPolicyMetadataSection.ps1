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
        $ContentManagedIdentity,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
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

    if ($ContentManagedIdentity)
    {
        $propertiesSection.metadata.guestConfiguration.contentManagedIdentity = $ContentManagedIdentity
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
