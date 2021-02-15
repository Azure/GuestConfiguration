function Update-MofDocumentParameters {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [parameter()]
        [Hashtable[]] $Parameter
    )

    if ($Parameter.Count -eq 0) {
        return
    }

    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    foreach ($parmInfo in $Parameter) {
        if (-not $parmInfo.Contains('ResourceType')) {
            Throw "Policy parameter is missing a mandatory property 'ResourceType'. Please make sure that configuration resource type is specified in configuration parameter."
        }
        if (-not $parmInfo.Contains('ResourceId')) {
            Throw "Policy parameter is missing a mandatory property 'ResourceId'. Please make sure that configuration resource Id is specified in configuration parameter."
        }
        if (-not $parmInfo.Contains('ResourcePropertyName')) {
            Throw "Policy parameter is missing a mandatory property 'ResourcePropertyName'. Please make sure that configuration resource property name is specified in configuration parameter."
        }
        if (-not $parmInfo.Contains('ResourcePropertyValue')) {
            Throw "Policy parameter is missing a mandatory property 'ResourcePropertyValue'. Please make sure that configuration resource property value is specified in configuration parameter."
        }

        $resourceId = "[$($parmInfo.ResourceType)]$($parmInfo.ResourceId)"
        if ($null -eq ($resourcesInMofDocument | Where-Object { `
                    ($_.CimInstanceProperties.Name -contains 'ResourceID') `
                        -and ($_.CimInstanceProperties['ResourceID'].Value -eq $resourceId) `
                        -and ($_.CimInstanceProperties.Name -contains $parmInfo.ResourcePropertyName) `
                })) {

            Throw "Failed to find parameter reference in the configuration '$Path'. Please make sure parameter with ResourceType:'$($parmInfo.ResourceType)', ResourceId:'$($parmInfo.ResourceId)' and ResourcePropertyName:'$($parmInfo.ResourcePropertyName)' exist in the configuration."
        }

        Write-Verbose "Updating configuration parameter for $resourceId ..."
        $resourcesInMofDocument | ForEach-Object {
            if (($_.CimInstanceProperties.Name -contains 'ResourceID') -and ($_.CimInstanceProperties['ResourceID'].Value -eq $resourceId)) {
                $item = $_.CimInstanceProperties.Item($parmInfo.ResourcePropertyName)
                $item.Value = $parmInfo.ResourcePropertyValue
            }
        }
    }

    Write-Verbose "Saving configuration file '$Path' with updated parameters ..."
    $content = ""
    for ($i = 0; $i -lt $resourcesInMofDocument.Count; $i++) {
        $resourceClassName = $resourcesInMofDocument[$i].CimSystemProperties.ClassName
        $content += "instance of $resourceClassName"

        if ($resourceClassName -ne 'OMI_ConfigurationDocument') {
            $content += ' as $' + "$resourceClassName$i"
        }
        $content += "`n{`n"
        $resourcesInMofDocument[$i].CimInstanceProperties | ForEach-Object {
            $content += " $($_.Name)"
            if ($_.CimType -eq 'StringArray') {
                $content += " = {""$($_.Value -replace '[""\\]','\$&')""}; `n"
            }
            else {
                $content += " = ""$($_.Value -replace '[""\\]','\$&')""; `n"
            }
        }
        $content += "};`n" ;
    }

    $content | Out-File $Path
}
