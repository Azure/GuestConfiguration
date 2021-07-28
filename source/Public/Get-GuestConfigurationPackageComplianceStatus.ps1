function Get-GuestConfigurationPackageComplianceStatus
{
    [CmdletBinding()]
    [Experimental('GuestConfiguration.SetScenario', 'Show')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Path,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Hashtable[]]
        $Parameter = @()
    )

    begin
    {
        # Determine if verbose is enabled to pass down to other functions
        $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
        $systemPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Process")
        $gcBinPath = Get-GuestConfigBinaryPath
        $guestConfigurationPolicyPath = Get-GuestConfigPolicyPath

    }

    process
    {
        try
        {
            if ($PSBoundParameters.ContainsKey('Force') -and $Force)
            {
                $withForce = $true
            }
            else
            {
                $withForce = $false
            }

            $packagePath = Install-GuestConfigurationPackage -Path $Path -Force:$withForce

            Write-Debug -Message "Looking into Package '$PackagePath' for MOF document."

            $packageName = Get-GuestConfigurationPackageName -Path $PackagePath

            # Confirm mof exists
            $packageMof = Join-Path -Path $packagePath -ChildPath "$packageName.mof"
            $dscDocument = Get-Item -Path $packageMof -ErrorAction 'SilentlyContinue'

            if (-not $dscDocument)
            {
                throw "Invalid Guest Configuration package, failed to find dsc document at '$packageMof' path."
            }

            # update configuration parameters
            if ($Parameter.Count -gt 0)
            {
                Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
            }

            # Publish policy package
            Publish-DscConfiguration -ConfigurationName $packageName -Path $PackagePath -Verbose:$verbose

            # Set LCM settings to force load powershell module.
            $metaConfigPath = Join-Path -Path $PackagePath -ChildPath "$packageName.metaconfig.json"
            Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'debugMode' -Value 'ForceModuleImport'

            Set-DscLocalConfigurationManager -ConfigurationName $packageName -Path $PackagePath -Verbose:$verbose


            # Clear Inspec profiles
            Remove-Item -Path $(Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue

            $getResult = @()
            $getResult = $getResult + (Get-DscConfiguration -ConfigurationName $packageName -Verbose:$verbose)
            return $getResult
        }
        finally
        {
            $env:PSModulePath = $systemPSModulePath
        }
    }
}
