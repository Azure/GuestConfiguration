
function Test-GuestConfigurationMofResourceDependencies {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    $externalResources = @()
    for ($i = 0; $i -lt $resourcesInMofDocument.Count; $i++) {
        if ($resourcesInMofDocument[$i].CimInstanceProperties.Name -contains 'ModuleName' -and $resourcesInMofDocument[$i].ModuleName -ne 'GuestConfiguration') {
            if ($resourcesInMofDocument[$i].ModuleName -ieq 'PsDesiredStateConfiguration') {
                Throw "'PsDesiredStateConfiguration' module is not supported by GuestConfiguration. Please use 'PSDSCResources' module instead of 'PsDesiredStateConfiguration' module in DSC configuration."
            }

            $configurationName = $resourcesInMofDocument[$i].ConfigurationName
            Write-Warning -Message "The configuration '$configurationName' is using one or more resources outside of the GuestConfiguration module. Please make sure these resources work with PowerShell Core"
            break
        }
    }
}
