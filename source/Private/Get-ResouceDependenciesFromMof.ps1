function Get-ResouceDependenciesFromMof
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MofFilePath
    )

    $resourceDependencies = @()
    $reservedResourceNames = @('OMI_ConfigurationDocument')
    $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4)

    foreach ($mofInstance in $mofInstances)
    {
        if ($reservedResourceNames -inotcontains $mofInstance.CimClass.CimClassName -and $mofInstance.CimInstanceProperties.Name -icontains 'ModuleName')
        {
            Write-Verbose -Message "Found resource dependency in mof with name '$($mofInstance.CimClass.CimClassName)' from module '$($mofInstance.ModuleName)' with version '$($mofInstance.ModuleVersion)'."
            $resourceDependencies += @{
                ResourceInstanceName = $mofInstance.CimInstanceProperties['Name'].Value
                ResourceName = $mofInstance.CimClass.CimClassName
                ModuleName = $mofInstance.ModuleName
                ModuleVersion = $mofInstance.ModuleVersion
            }
        }
    }

    return $resourceDependencies
}
