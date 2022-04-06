function New-GuestConfigurationPolicyMetadataSection
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $guestConfigurationMetadata = [Ordered]@{
        name = $ConfigurationName
        version = $ConfigurationVersion
        contentType = 'Custom'
        contentUri = $ContentUri
        contentHash = $ContentHash
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $guestConfigurationMetadata['configurationParameter'] = @()

        foreach ($currentParameter in $Parameter)
        {
            $guestConfigurationMetadata['configurationParameter'] += [Ordered]@{
                $currentParameter['Name'] = New-GuestConfigurationPolicyParameterReferenceString -Parameter $currentParameter
            }
        }
    }

    return $guestConfigurationMetadata
}
