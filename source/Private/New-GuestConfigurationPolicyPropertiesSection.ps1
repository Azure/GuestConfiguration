function New-GuestConfigurationPolicyPropertiesSection
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $templateFileName = '1-Properties.json'
    $propertiesSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    $propertiesSection.displayName = $DisplayName
    $propertiesSection.description = $Description

    $propertiesSection.metadata.version = $PolicyVersion

    $guestConfigruationMetadataSectionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }

    $propertiesSection.metadata.guestConfiguration = New-GuestConfigurationPolicyMetadataSection @guestConfigruationMetadataSectionParameters

    return $propertiesSection
}
