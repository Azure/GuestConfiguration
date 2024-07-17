function New-GuestConfigurationPolicyParametersSection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $Parameter,

        [Parameter()]
        [Switch]
        $ExcludeArcMachines
    )

    $templateFileName = '2-Parameters.json'
    $parametersSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    if ($ExcludeArcMachines)
    {
        if ($parametersSection.parameters.IncludeArcMachines)
        {
            $parametersSection.parameters.Remove("IncludeArcMachines")
        }
    }

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

        if ($currentParameter.Keys -contains 'DefaultValue')
        {
            # Key is intentionally camelCase
            $parametersSection.parameters.$parameterName['defaultValue'] = [string]$currentParameter['DefaultValue']
        }

        if ($currentParameter.Keys -contains 'AllowedValues')
        {
            $allowedStringValues = @()
            foreach ($allowedValue in $currentParameter['AllowedValues'])
            {
                $allowedStringValues += [string]$allowedValue
            }

            # Key is intentionally camelCase
            $parametersSection.parameters.$parameterName['allowedValues'] = $allowedStringValues
        }
    }

    return $parametersSection
}
