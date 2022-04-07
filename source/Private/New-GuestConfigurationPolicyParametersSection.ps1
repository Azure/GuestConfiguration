function New-GuestConfigurationPolicyParametersSection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $templateFileName = '2-Parameters.json'
    $parametersSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    $optionalFields = @('AllowedValues', 'DefaultValue')

    foreach ($currentParameter in $Parameter)
    {
        $parameterName = $currentParameter['Name']
        $parametersSection.parameters.$parameterName = [Ordered]@{
            type = 'string'
            metadata = [Ordered]@{
                displayName = $currentParameter['DisplayName']
                description = $currentParameter['Description']
            }
        }

        foreach ($optionalField in $optionalFields)
        {
            if ($currentParameter.ContainsKey($optionalField))
            {
                $fieldName = $optionalField.Substring(0, 1).ToLower() + $optionalField.Substring(1)
                $parametersSection.parameters.$parameterName.$fieldName = $currentParameter[$optionalField]
            }
        }
    }

    return $parametersSection
}
