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
        $IncludeVMSS = $true
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

    return $conditionsSection
}
