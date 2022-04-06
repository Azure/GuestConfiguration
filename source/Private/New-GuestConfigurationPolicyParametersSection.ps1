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
        $parametersSection.$parameterName = [Ordered]@{
            type = 'string'
            metadata = [Ordered]@{
                displayName = $currentParameter['DisplayName']
                description = $currentParameter['Description']
            }
        }

        foreach ($optionalField in $optionalFields)
        {
            $fieldName = $optionalField.Substring(0, 1).ToLower() + $optionalField.Substring(1)
            if ($currentParameter.ContainsKey($optionalField))
            {
                $parametersSection.$parameterName.$fieldName = $currentParameter[$optionalField]
            }
        }
    }

    return $parametersSection
}
