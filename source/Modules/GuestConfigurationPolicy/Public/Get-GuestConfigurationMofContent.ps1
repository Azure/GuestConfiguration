
function Get-GuestConfigurationMofContent {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )

    Write-Verbose "Parsing Configuration document '$Path'"
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    # Set the profile path for Chef resource
    $resourcesInMofDocument | ForEach-Object {
        if ($_.CimClass.CimClassName -eq 'MSFT_ChefInSpecResource') {
            $profilePath = "$Name/Modules/$($_.Name)"
            $item = $_.CimInstanceProperties.Item('GithubPath')
            if ($item -eq $null) {
                $item = [Microsoft.Management.Infrastructure.CimProperty]::Create('GithubPath', $profilePath, [Microsoft.Management.Infrastructure.CimFlags]::Property)
                $_.CimInstanceProperties.Add($item)
            }
            else {
                $item.Value = $profilePath
            }
        }
    }

    return $resourcesInMofDocument
}
