function Get-GuestConfigurationPackageComplianceStatus
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [System.Name]
        $Package,

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

        # Unzip Guest Configuration binaries if missing
        if (-not (Test-Path -Path $gcBinPath))
        {
            Install-GuestConfigurationAgent -verbose:$verbose
            # We may want to be a bit more clever with checking which version is installed
        }
    }

    process
    {
        try
        {
            if ($Package -as [uri] -or ((Test-Path -PathType 'Leaf' -Path $Package) -and $Package -match '\.zip$'))
            {
                $PackagePath = Install-GuestConfigurationPackage -Path $Package
            }
            else
            {
                Write-Debug -Message "The Package is the Package Name. It has to exist."
                $PackagePath = Join-Path -Path $guestConfigurationPolicyPath -ChildPath $Package -Resolve -ErrorAction 'Stop'
            }

            $packageName = [System.IO.Path]::GetFileNameWithoutExtension($PackagePath)
            $dscDocument = Get-Item -Path (Join-Path -Path $PackagePath -ChildPath ('{0}.mof' -f $packageName)) -ErrorAction 'Stop'

            if (-not $dscDocument)
            {
                throw "Invalid policy package, failed to find dsc document in policy package."
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
            # If metaconfig already exists, append
            if (Test-Path $metaConfigPath)
            {
                $metaConfigObject = Get-Content -Path $metaConfigPath | ConvertFrom-Json -AsHashTable
                $metaConfigObject["debugMode"] = "ForceModuleImport"
                $metaConfigObject | ConvertTo-Json | Out-File $metaConfigPath -Encoding ascii -Force
            }
            else
            {
                "{""debugMode"":""ForceModuleImport""}" | Out-File $metaConfigPath -Encoding ascii
            }

            Set-DscLocalConfigurationManager -ConfigurationName $packageName -Path $PackagePath -Verbose:$verbose


            # Clear Inspec profiles
            Remove-Item -Path $(Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue

            $testResult = Test-DscConfiguration -ConfigurationName $packageName -Verbose:$verbose
            $getResult = @()
            $getResult = $getResult + (Get-DscConfiguration -ConfigurationName $packageName -Verbose:$verbose)

            $testResult.resources_not_in_desired_state | ForEach-Object {
                $resourceId = $_;
                if ($getResult.count -gt 1)
                {
                    for ($i = 0; $i -lt $getResult.Count; $i++)
                    {
                        if ($getResult[$i].ResourceId -ieq $resourceId)
                        {
                            $getResult[$i] = $getResult[$i] | Select-Object *, @{
                                n = 'complianceStatus'
                                e = { $false }
                            }
                        }
                    }
                }
                elseif ($getResult.ResourceId -ieq $resourceId)
                {
                    $getResult = $getResult | Select-Object *, @{
                        n = 'complianceStatus'
                        e = { $false }
                    }
                }
            }

            $testResult.resources_in_desired_state | ForEach-Object {
                $resourceId = $_
                if ($getResult.count -gt 1)
                {
                    for ($i = 0; $i -lt $getResult.Count; $i++)
                    {
                        if ($getResult[$i].ResourceId -ieq $resourceId)
                        {
                            $getResult[$i] = $getResult[$i] | Select-Object *, @{
                                n = 'complianceStatus'
                                e = { $true }
                            }
                        }
                    }
                }
                elseif ($getResult.ResourceId -ieq $resourceId)
                {
                    $getResult = $getResult | Select-Object *, @{
                        n = 'complianceStatus'
                        e = { $true }
                    }
                }
            }

            [PSCustomObject]@{
                complianceStatus = $testResult.compliance_state
                resources        = $getResult
            }
        }
        finally
        {
            $env:PSModulePath = $systemPSModulePath
        }
    }
}
