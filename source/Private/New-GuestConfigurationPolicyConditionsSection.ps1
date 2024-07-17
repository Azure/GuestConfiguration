function New-GuestConfigurationPolicyConditionsSection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter()]
        [System.Collections.Hashtable]
        $Tag,

        [Parameter()]
        [System.Boolean]
        $IncludeVMSS = $true,

        [Parameter()]
        [Switch]
        $ExcludeArcMachines
    )

    $templateFileName = "3-Images-$Platform.json"
    if ($IncludeVMSS)
    {
        $templateFileName = "3-Images-$Platform-VMSS.json"
    }
    $conditionsSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    if ($null -ne $Tag -and $Tag.Count -gt 0)
    {
        $tagConditionList = @()

        foreach ($tagName in $Tag.Keys)
        {
            $tagConditionList += [Ordered]@{
                field  = "tags['$tagName']"
                equals = $($Tag[$tagName])
            }
        }

        if ($tagConditionList.Count -eq 1)
        {
            $tagConditions = $tagConditionList[0]
        }
        elseif ($tagConditionList.Count -gt 1)
        {
            $tagConditions = [Ordered]@{
                allOf = $tagConditionList
            }
        }

        $conditionsSection = [Ordered]@{
            allOf = @(
                $conditionsSection,
                $tagConditions
            )
        }
    }

    if ($ExcludeArcMachines)
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
    }

    return $conditionsSection
}
