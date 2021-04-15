<#
    .SYNOPSIS
        Publish DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Parameter Path
        Policy Path.

    .Example
        Publish-DscConfiguration -Path C:\metaconfig
#>

function Publish-DscConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = (Get-DscLibPath) -replace  '[""\\]','\$&'

    if (-not (Test-Path -Path $gcBinPath))
    {
        throw "Guest Config binaries not found at path $gcBinPath"
    }

    if (-not (Test-Path -Path $dsclibPath))
    {
        throw "Guest Config DSC Lib not found at path $dsclibPath"
    }

    if (-not (Test-Path -Path $Path))
    {
        throw "Guest Config DSC Config not found at path $testPath"
    }

    if (-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type)
    {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()

    Write-Debug -Message "Running [GuestConfig.DscOperations] `$dscOperation.PublishDscConfiguration method with: $PSCmdlet, $job_id, $ConfigurationName, $gcBinPath, $Path."
    $null = $dscOperation.PublishDscConfiguration($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath, $Path)
}
