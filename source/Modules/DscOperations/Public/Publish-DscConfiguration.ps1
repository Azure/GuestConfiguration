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
    if (-not (Test-Path -Path $Path))
    {
        throw "Guest Config DSC Config not found at path $testPath"
    }

    Remove-Item (Get-GuestConfigLogPath) -ErrorAction SilentlyContinue -Force

    $gcWorkerPath = Get-GuestConfigWorkerBinaryPath
    Start-Process $gcWorkerPath -ArgumentList  "-o publish_assignment -a  $ConfigurationName -p $Path" -Wait -NoNewWindow
    Start-Sleep -Milliseconds 500
    Write-GCOperationConsoleMessages -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
}
