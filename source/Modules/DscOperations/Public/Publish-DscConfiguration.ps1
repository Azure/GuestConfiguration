
<#
    .SYNOPSIS
        Publish DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Publish-DscConfiguration -Path C:\metaconfig
#>

function Publish-DscConfiguration
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName,

        [parameter(Position=1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    $testGCbinPath = Test-Path $gcBinPath
    if ($false -eq $testGCbinPath) {throw "Guest Config binaries not found at path $gcBinPath"}

    $testDSClibPath = Test-Path $dsclibPath
    if ($false -eq $testDSClibPath) {throw "Guest Config binaries not found at path $dsclibPath"}

    $testPath = Test-Path $Path
    if ($false -eq $testPath) {throw "Guest Config binaries not found at path $testPath"}

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.PublishDscConfiguration($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath, $Path)
}
