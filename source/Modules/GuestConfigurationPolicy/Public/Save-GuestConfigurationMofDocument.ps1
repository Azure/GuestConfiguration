function Save-GuestConfigurationMofDocument {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $SourcePath,

        [Parameter(Mandatory = $true)]
        [String]
        $DestinationPath
    )

    $resourcesInMofDocument = Get-GuestConfigurationMofContent -Name $Name -Path $SourcePath

    # if mof contains Chef resource
    if ($resourcesInMofDocument.CimSystemProperties.ClassName -contains 'MSFT_ChefInSpecResource') {
        Write-Verbose "Serialize DSC document to $DestinationPath path ..."
        $content = ''
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

        $content | Out-File $DestinationPath
    }
    else {
        Write-Verbose "Copy DSC document to $DestinationPath path ..."
        Copy-Item $SourcePath $DestinationPath
    }
}
