function Copy-ChefInspecDependencies {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PackagePath,

        [Parameter(Mandatory = $true)]
        [String]
        $Configuration,

        [string]
        $ChefInspecProfilePath
    )

    # Copy Inspec install script and profiles.
    $modulePath = Join-Path $PackagePath 'Modules'
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Configuration, 4)
    $missingDependencies = @()
    $chefInspecProfiles = @()

    $resourcesInMofDocument | ForEach-Object {
        if ($_.CimClass.CimClassName -eq 'MSFT_ChefInSpecResource') {
            if ([string]::IsNullOrEmpty($ChefInspecProfilePath)) {
                Throw "'$($_.CimInstanceProperties['Name'].Value)'. Please use ChefInspecProfilePath parameter to specify profile path."
            }

            $inspecProfilePath = Join-Path $ChefInspecProfilePath $_.CimInstanceProperties['Name'].Value
            if (-not (Test-Path $inspecProfilePath)) {
                $missingDependencies += $_.CimInstanceProperties['Name'].Value
            }
            else {
                $chefInspecProfiles += $inspecProfilePath
            }

        }
    }

    if ($missingDependencies.Length) {
        Throw "Failed to find Chef Inspec profile for '$($missingDependencies -join ',')'. Please make sure profile is present on $ChefInspecProfilePath path."
    }

    $chefInspecProfiles | ForEach-Object { Copy-Item $_ $modulePath -Recurse -Force -ErrorAction SilentlyContinue }

}
