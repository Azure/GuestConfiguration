function Install-GuestConfigurationMonkeyPatch
{
    [CmdletBinding()]
    [OutputType([void])]
    param ( )

    $monkeyPatchConfigFile = Join-Path -Path $MyInvocation.MyCommand.Module.ModuleBase -ChildPath 'MonkeyPatch/MonkeyPatch.json'
    $MonkeyPatchDefinition = Get-Content -Path $monkeyPatchConfigFile -ErrorAction SilentlyContinue |
        ConvertFrom-Json -ErrorAction Stop

    # Making some variables available for ExpandString
    $gcBinPath = Get-GuestConfigBinaryPath
    $guestConfigurationPolicyPath = Get-GuestConfigPolicyPath
    $OsPlatform = Get-OSPlatform

    $monkeyPatchDefinition.psobject.properties.Where{
        $OsPlatform -match $_.Name
    }.Foreach{
        # do all things that apply to the current OS Platform
        Write-Verbose -Message "Processing MonkeyPatch tasks for '$($_.Name)'."
        # Copy Item
        Push-Location -StackName MonkeyPatch -Path (Join-Path -Path $PSCmdlet.SessionState.Module.ModuleBase -ChildPath 'MonkeyPatch')
        try
        {
            $_.Value.Copy.Foreach{
                Write-Debug -Message ($_ | ConvertTo-Json )
                $destination = $ExecutionContext.InvokeCommand.ExpandString($_.Destination)
                $source = $ExecutionContext.InvokeCommand.ExpandString($_.Source)
                Write-Verbose -Message "Copy-Item -Path '$source' -Destination '$destination' -Recurse -Force"
                Copy-Item -Path $source  -Destination $destination -Recurse -Force
            }
        }
        finally
        {
            Pop-Location -StackName MonkeyPatch
        }
    }
}
