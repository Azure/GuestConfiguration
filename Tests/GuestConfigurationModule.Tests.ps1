######################################################
#  End to end Guest Configuration module reporting test
#  Verify report is sent for every consistency run of a 
#  configuration assignement.
######################################################

function Get-IsAzureDevOps {
    if ($Env:AGENT_JOBSTATUS -eq 'Succeeded' ) {
        $true
    }
    else { $false }
}

function Get-OSPlatform {
    [OutputType([String])]
    [CmdletBinding()]
    param()

    $platform = 'Windows'

    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        $platform = 'Windows'
    }
    elseif ($PSVersionTable.PSEdition -eq 'Core') {
        if ($IsWindows) {
            $platform = 'Windows'
        }
        elseif ($IsLinux) {
            $platform = 'Linux'
        }
        elseif ($IsMacOS) {
            $platform = 'MacOS'
        }
    }

    return $platform
}

$IsNotAzureDevOps = $false -eq (Get-IsAzureDevOps)
$IsNotWindows = 'Windows' -ne (Get-OSPlatform)
$IsNotWindowsAndIsAzureDevOps = $IsNotWindows -AND (Get-IsAzureDevOps)
$IsPester4 = (Get-Module 'Pester').version.Major -eq '4'

if ($Env:BUILD_DEFINITIONNAME -eq 'PowerShell.GuestConfiguration (Private)') {
    $releaseBuild = $true
    write-host "AZ MOCKS: Az cmdlets are NOT mocked"
}
else {
    $notReleaseBuild = $true
    write-host "AZ MOCKS: Az cmdlets are mocked"
}

Describe 'Test Guest Configuration Custom Policy cmdlets' {
    BeforeAll {
        function Get-OSPlatform {
            [OutputType([String])]
            [CmdletBinding()]
            param()
        
            $platform = 'Windows'
        
            if ($PSVersionTable.PSEdition -eq 'Desktop') {
                $platform = 'Windows'
            }
            elseif ($PSVersionTable.PSEdition -eq 'Core') {
                if ($IsWindows) {
                    $platform = 'Windows'
                }
                elseif ($IsLinux) {
                    $platform = 'Linux'
                }
                elseif ($IsMacOS) {
                    $platform = 'MacOS'
                }
            }
        
            return $platform
        }

        function Test-CurrentMachineIsWindows {
            [OutputType([Boolean])]
            [CmdletBinding()]
            param ()
        
            $currentOSPlatform = Get-OSPlatform
            $currentMachineIsWindows = $currentOSPlatform -ieq 'Windows'
            return $currentMachineIsWindows
        }
        
        function New-TestCertificate {
            [CmdletBinding()]
            param ()
        
            # Create self signed certificate
            $certificatePath = "Cert:\LocalMachine\My"
            $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
            if ($null -eq $certificate) {
                $selfSignedCertModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'New-SelfSignedCertificateEx.ps1'
                Import-Module -Name $selfSignedCertModulePath -Force 
                $null = New-SelfsignedCertificateEx `
                    -Subject "CN=testcert" `
                    -EKU 'Code Signing' `
                    -KeyUsage 'KeyEncipherment, DataEncipherment, DigitalSignature' `
                    -SAN $env:ComputerName `
                    -FriendlyName 'DSC Credential Encryption certificate' `
                    -Exportable `
                    -StoreLocation 'LocalMachine' `
                    -KeyLength 2048 `
                    -ProviderName 'Microsoft Enhanced Cryptographic Provider v1.0' `
                    -AlgorithmName 'RSA' `
                    -SignatureAlgorithm 'SHA256'
            }
        
            $command = @'
$Cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { ($_.Subject -eq 'CN=testcert') } | Select-Object -First 1
Export-Certificate -FilePath "$TestDrive/exported.cer" -Cert $Cert
Import-Certificate -FilePath "$TestDrive/exported.cer" -CertStoreLocation Cert:\LocalMachine\Root
'@                
            powershell.exe -NoProfile -NonInteractive -Command $command
        }
        
        function New-TestDscConfiguration {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [String]
                $DestinationFolderPath,
        
                [Parameter()]
                [ValidateSet('DSC', 'InSpec')]
                [String]
                $Type = 'DSC'
            )
        
            if ($false -eq (Test-CurrentMachineIsWindows)) {
                Import-Module 'PSDesiredStateConfiguration'
            }
        
            #region Windows DSC config
            if ('DSC' -eq $Type) {
                Install-Module -Name 'ComputerManagementDsc' -RequiredVersion '8.2.0' -Force
                $dscConfig = @'
instance of DSC_TimeZone as $DSC_TimeZone1ref
{
ModuleName = "ComputerManagementDsc";
IsSingleInstance = "Yes";
ResourceID = "[TimeZone]TimeZoneExample";
SourceInfo = "::7::9::TimeZone";
TimeZone = "Tonga Standard Time";
ModuleVersion = "8.2.0";
ConfigurationName = "DSCConfig";
};

instance of OMI_ConfigurationDocument
{
Version="2.0.0";
MinimumCompatibleVersion = "1.0.0";
CompatibleVersionAdditionalProperties= {"Omi_BaseResource:ConfigurationName"};
Name="DSCConfig";
};
'@
            }
            #endregion
        
            #region Linux DSC config
            if ('InSpec' -eq $Type) {
                $dscConfig = @"
Configuration DSCConfig
{
Import-DscResource -ModuleName 'GuestConfiguration'

Node 'localhost'
{
ChefInSpecResource 'Audit Linux path exists'
{
    Name = 'linux-path'
}
}
}
DSCConfig -OutputPath $DestinationFolderPath
"@
                $inSpecProfileName = 'linux-path'
                $inSpecProfile = @"
name: $inSpecProfileName
title: Test profile
maintainer: Test
summary: Test profile
license: MIT
version: 1.0.0
supports:
- os-family: unix
"@
                $inSpecProfileRB = @"
describe file('/tmp') do
it { should exist }
end
"@
            }
            #endregion
        
            $DestinationFolderPath = New-Item -Path $TestDrive -Name 'DSCConfig' -ItemType Directory
            $destinationMOFPath = Join-Path -Path $DestinationFolderPath -ChildPath 'localhost.mof'
        
            $null = Set-Content -Path $destinationMOFPath -Value $dscConfig

            $filesToIncludeFolderPath = Join-Path -Path $TestDrive -ChildPath 'FilesToInclude'
            New-Item $filesToIncludeFolderPath -ItemType Directory
            $filesToIncludeFilePath = Join-Path -Path $filesToIncludeFolderPath -ChildPath 'file.txt'
            $filesToIncludeContent = 'test' | Set-Content -Path $filesToIncludeFilePath
        
            if ('InSpec' -eq $Type) {
                # creates directory for InSpec profile
                $InSpecProfilePath = Join-Path -Path $TestDrive -ChildPath $inSpecProfileName
                $null = New-Item -ItemType Directory -Path $InSpecProfilePath
        
                # creates InSpec profile required Yml file
                $InSpecProfileYmlFilePath = Join-Path -Path $InSpecProfilePath -ChildPath 'inspec.yml'
                $null = Set-Content -Path $InSpecProfileYmlFilePath -Value $inSpecProfile
        
                # creates directory for InSpec controls (component of InSpec profile)
                $InSpecControlsPath = Join-Path -Path $InSpecProfilePath -ChildPath 'controls'
                $null = New-Item -ItemType Directory -Path $InSpecControlsPath
        
                # creates InSpec controls required Ruby file
                $InSpecControlsRubyFilePath = Join-Path -Path $InSpecControlsPath -ChildPath "$inSpecProfileName.rb"
                $null = Set-Content -Path $InSpecControlsRubyFilePath -Value $inSpecProfileRB
            }
        }
        
        function New-TestGCPolicyParameters {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [String]
                $DestinationFolderPath
            )
        
            if (Test-CurrentMachineIsWindows) {
                $computerInfo = Get-ComputerInfo
                $currentWindowsOSString = $computerInfo.WindowsProductName
            }
            else {
                $currentWindowsOSString = 'Non-Windows'
            }
            
            $newGCPolicyParameters = @{
                ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
                DisplayName = "[Test] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
                Description = 'Policy to audit a Windows service'
                Path        = Join-Path -Path $DestinationFolderPath -ChildPath 'policyDefinitions'
                Version     = '1.0.0.0'
            }
        
            return $newGCPolicyParameters
        }

        function Get-AzMocks {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [Hashtable]
                $newGCPolicyParameters
            )
            Mock Get-AzContext -MockWith { @{Name = 'Subscription'; Subscription = @{Id = 'Id' } } } -Verifiable          
            Mock Get-AzPolicyDefinition -Verifiable
            Mock New-AzPolicyDefinition -Verifiable
            Mock Get-AzPolicySetDefinition -Verifiable
            Mock New-AzPolicySetDefinition -Verifiable
            Write-Host '   [i] Mocked Az commands' -ForegroundColor Cyan
        }
        
        function Initialize-MachineForGCTesting {
            [CmdletBinding()]
            param ()
        
            Write-Verbose -Message 'Setting up machine for Guest Configuration module testing...' -Verbose
        
            # Make sure traffic is using TLS 1.2 as all Azure services reject connections below 1.2
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
            if (Test-CurrentMachineIsWindows) {
                Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process'
            }
        
            $gcModuleFolderPath = Split-Path -Path $PSScriptRoot -Parent
            if (Test-CurrentMachineIsWindows) {
                $delimiter = ";"
            }
            else {
                $delimiter = ":"
            }
            $Env:PSModulePath = "$gcModuleFolderPath" + "$delimiter" + "$Env:PSModulePath"
        
            $gcModulePath = Join-Path $gcModuleFolderPath 'GuestConfiguration.psd1'
            Import-Module $gcModulePath -Force
            Write-ModuleInfo -ModuleName 'GuestConfiguration'
        }
        
        function Write-ModuleInfo {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [String]
                $ModuleName
            )
        
            $titleLine = "$($ModuleName.ToUpper()) MODULE INFO"
        
            Write-Verbose -Message "`n$titleLine`n$('-' * $titleLine.length)" -Verbose
            $moduleInfo = Get-Module -Name $ModuleName
            if ($null -ne $moduleInfo) {
                Write-Verbose -Message "$($moduleInfo | Format-List | Out-String)" -Verbose
            }
            else {
                Write-Verbose -Message "Module '$ModuleName' not loaded" -Verbose
            }
        }
        
        function Write-EnvironmentVariableInfo {
            [CmdletBinding()]
            param ()
        
            $titleLine = "ENVIRONMENT VARIABLE INFO"
            Write-Verbose -Message "`n$titleLine`n$('-' * $titleLine.length)" -Verbose
        
            $envVars = Get-ChildItem -Path "env:*"
            Write-Verbose -Message "$($envVars | sort-object name | Out-String)" -Verbose
        }
        
        function Write-EnvironmentInfo {
            [CmdletBinding()]
            param ()
        
            $psTitleLine = "POWERSHELL INFO"
            Write-Verbose -Message "`n$psTitleLine`n$('-' * $psTitleLine.length) $($PSVersionTable | Format-List | Out-String)"  -Verbose
            Write-ModuleInfo -ModuleName 'Pester'
            Write-EnvironmentVariableInfo
        }
    
        Initialize-MachineForGCTesting
        
        Write-EnvironmentInfo
    
        # Set up test paths
        $dscConfigFolderPath = Join-Path -Path $TestDrive -ChildPath 'DSCConfig'
        $filesToIncludeFolderPath = Join-Path -Path $TestDrive -ChildPath 'FilesToInclude'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $newPolicyDirectory = Join-Path -Path $testOutputPath -ChildPath 'policyDefinitions'
        $policyName = 'testPolicy'
        $mofDocPath = Join-Path -Path $dscConfigFolderPath -ChildPath 'localhost.mof'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'package'
        $filesToIncludePackagePath = Join-Path -Path $testOutputPath -ChildPath 'filesToIncludePackage'
        $unsignedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'UnsignedPackage'
        $filesToIncludeExtractionPath = Join-Path $testOutputPath -ChildPath 'filesToIncludeUnsignedPackage'
        $mofFilePath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath "$policyName.mof"
        $extractedFilesToIncludePath = Join-Path -Path $filesToIncludeExtractionPath -ChildPath 'FilesToInclude'
        $signedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'SignedPackage'
        $currentDateString = Get-Date -Format "yyyy-MM-dd HH:mm"
        $expectedPolicyType = 'Custom'
        $expectedContentHash = 'D421E3C8BB2298AEC5CFD95607B91241B7D5A2C88D54262ED304CA1FD01370F3'
        $testPolicyName = 'AuditWindowsService'
        
        $newGCPolicyParameters = New-TestGCPolicyParameters $testOutputPath

        New-TestDscConfiguration -DestinationFolderPath $dscConfigFolderPath

        if ($Env:BUILD_DEFINITIONNAME -eq 'PowerShell.GuestConfiguration (Private)' -AND $false -eq $IsMacOS) {
            # TODO
            # Az PowerShell login from macOS currently has issue
            # https://github.com/microsoft/azure-pipelines-tasks/issues/12030
            
            # Import the AzHelper module
            $gcModuleFolderPath = Split-Path -Path $PSScriptRoot -Parent
            $helperModulesFolderPath = Join-Path -Path $gcModuleFolderPath -ChildPath 'Tests'
            $azHelperModulePath = Join-Path -Path $helperModulesFolderPath -ChildPath 'AzHelper.psm1'
            Write-Verbose -Message "Importing AzHelper module..." -Verbose
            Import-Module -Name $azHelperModulePath
        
            if ($false -eq (Test-ServicePrincipalAccountInEnviroment)) {
                Throw "Current machine does not have a service principal available. Test environment should have been set up manually. Please ensure you are logged in to an Azure account and the GuestConfiguration and ComputerManagementDsc modules are installed."
            }
        }
        else {
            $notReleaseBuild = $true
        }

        if ($releaseBuild -AND (Test-CurrentMachineIsWindows)) {
            # TODO
            # Az PowerShell login from macOS currently has issue
            # https://github.com/microsoft/azure-pipelines-tasks/issues/12030
            Install-AzLibraries
        }
    }
    Context 'Module fundamentals' {
            
        It 'has the agent binaries from the project feed' -Skip:$IsNotAzureDevOps {
            Test-Path "$PSScriptRoot/../bin/DSC_Windows.zip" | Should -BeTrue
            Test-Path "$PSScriptRoot/../bin/DSC_Linux.zip" | Should -BeTrue
        }
        
        It 'has a PowerShell module manifest that meets functional requirements' {
            Test-ModuleManifest -Path "$PSScriptRoot/../GuestConfiguration.psd1" | Should -Not -BeNullOrEmpty
            $? | Should -BeTrue
        }

        It 'imported the module successfully' {
            Get-Module GuestConfiguration | ForEach-Object { $_.Name } | Should -Be 'GuestConfiguration'
        }

        It 'does not throw while running Script Analyzer' {
            $scriptanalyzer = Invoke-ScriptAnalyzer -path "$PSScriptRoot/../" -Severity Error -Recurse -IncludeDefaultRules -ExcludeRule 'PSAvoidUsingConvertToSecureStringWithPlainText'
            $scriptanalyzer | Should -Be $Null
        }

        It 'has text in help examples' {
            foreach ($function in $publicFunctions) {
                Get-Help $function | ForEach-Object { $_.Examples } | Should -Not -BeNullOrEmpty
            }
        }
    }
    Context 'New-GuestConfigurationPackage' {

        It 'creates Custom policy package' {
            $package = New-GuestConfigurationPackage -Configuration $mofDocPath -Name $policyName -Path $testPackagePath
            Test-Path -Path $package.Path | Should -BeTrue
            $package.Name | Should -Be $policyName
        }

        It 'Verify the package can be extracted' {
            $package = Get-Item "$testPackagePath/$policyName/$policyName.zip"

            # Set up type needed for package extraction
            $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.FullName, $unsignedPackageExtractionPath) } | Should -Not -Throw
        }
  
        It 'Verify extracted mof document exists' {
            Test-Path -Path $mofFilePath | Should -BeTrue
        }

        It 'Verify all required modules are included in the package' {
            $extractedModulesPath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath 'Modules'
            $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4) 
            for ($numResources = 0; $numResources -lt $resourcesInMofDocument.Count; $numResources++) {
                if ($resourcesInMofDocument[$numResources].CimInstanceProperties.Name -contains 'ModuleName') {
                    $resourceModuleName = $resourcesInMofDocument[$numResources].ModuleName
                    $resourceModulePath = Join-Path -Path $extractedModulesPath -ChildPath $resourceModuleName
                    Test-Path -Path $resourceModulePath | Should -BeTrue
                }
            }
        }

        It 'Should not include -FilesToInclude by default' {
            Test-Path -Path $extractedFilesToIncludePath | Should -BeFalse
        }

        It 'Implements -FilesToInclude parameter' {
            $package = New-GuestConfigurationPackage -Configuration $mofDocPath -Name $policyName -Path $filesToIncludePackagePath -FilesToInclude $FilesToIncludeFolderPath
            $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $filesToIncludeExtractionPath) } | Should -Not -Throw
            Test-Path -Path $extractedFilesToIncludePath | Should -BeTrue
            $extractedFile = Join-Path $extractedFilesToIncludePath 'file.txt'
            Test-Path -Path $extractedFile | Should -BeTrue
            Get-Content $extractedFile | Should -Be 'test'
        }
    }
    Context 'Test-GuestConfigurationPackage' {

        It 'Validate that the resource compliance results are as expected' -Skip:$IsNotWindows {
            $package = New-GuestConfigurationPackage -Configuration $mofDocPath -Name $policyName -Path $testPackagePath
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path
            $testPackageResult.complianceStatus | Should -Be $false
            $testPackageResult.resources[0].ModuleName | Should -Be 'ComputerManagementDsc'
            $testPackageResult.resources[0].complianceStatus | Should -Be $false
            $testPackageResult.resources[0].ConfigurationName | Should -Be 'DSCConfig'
            $testPackageResult.resources[0].IsSingleInstance | Should -Be 'Yes'
        }
    } 
    Context 'Protect-GuestConfigurationPackage' {
        
        It 'Signed package should exist at output path' -Skip:$IsNotWindows {
            $package = New-GuestConfigurationPackage -Configuration $mofDocPath -Name $policyName -Path $testPackagePath
            New-TestCertificate
            $certificatePath = "Cert:\LocalMachine\My"
            $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
            $protectPackageResult = Protect-GuestConfigurationPackage -Path $package.Path -Certificate $certificate 
            Test-Path -Path $protectPackageResult.Path | Should -BeTrue
        }
    
        It 'Signed package should be extractable' -Skip:$IsNotWindows {
            $signedFileName = $policyName + "_signed.zip"
            $package = Get-Item "$testPackagePath/$policyName/$signedFileName"
            # Set up type needed for package extraction
            $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.FullName, $signedPackageExtractionPath) } | Should -Not -Throw
        }

        It '.cat file should exist in the extracted package' -Skip:$IsNotWindows {
            $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath "$policyName.cat"
            Test-Path -Path $catFilePath | Should -BeTrue
        }

        It 'Extracted .cat file thumbprint should match certificate thumbprint' -Skip:$IsNotWindows {
            $certificatePath = "Cert:\LocalMachine\My"
            $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
            $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath "$policyName.cat"
            $authenticodeSignature = Get-AuthenticodeSignature -FilePath $catFilePath
            $authenticodeSignature.SignerCertificate.Thumbprint | Should -Be $certificate.Thumbprint
        }
    }
    Context 'New-GuestConfigurationPolicy' {

        It 'New-GuestConfigurationPolicy should output path to generated policies' -Skip:($IsPester4 -or $IsNotWindowsAndIsAzureDevOps) {
            if ($notReleaseBuild) {
                function Get-AzContext {}
                Get-AzMocks -newGCPolicyParameters $newGCPolicyParameters
            }
            else {
                Login-ToTestAzAccount
            }
            $newGCPolicyResult = New-GuestConfigurationPolicy @newGCPolicyParameters
            $newGCPolicyResult.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResult.Path | Should -BeTrue
        }

        It 'Generated Audit policy file should exist' -Skip:($IsPester4 -or $IsNotWindowsAndIsAzureDevOps) {
            $auditPolicyFile = Join-Path -Path $newPolicyDirectory -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFile | Should -BeTrue
        }

        It 'Audit policy should contain expected content' -Skip:($IsPester4 -or $IsNotWindowsAndIsAzureDevOps) {
            $auditPolicyFile = Join-Path -Path $newPolicyDirectory -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContent = Get-Content $auditPolicyFile | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContent.properties.displayName.Contains($newGCPolicyParameters.DisplayName) | Should -BeTrue
            $auditPolicyContent.properties.description.Contains($newGCPolicyParameters.Description) | Should -BeTrue
            $auditPolicyContent.properties.policyType | Should -Be $expectedPolicyType
            $auditPolicyContent.properties.policyRule.then.details.name | Should -Be $testPolicyName
        }
    }
    Context 'Publish-GuestConfigurationPolicy' {

        It 'Should be able to publish policies' -Skip:($IsPester4 -or $notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
            Login-ToTestAzAccount
            $newGCPolicyResult = New-GuestConfigurationPolicy @newGCPolicyParameters
            { $publishGCPolicyResult = $newGCPolicyResult | Publish-GuestConfigurationPolicy } | Should -Not -Throw
        }

        It 'Should be able to retrieve 2 published policies' -Skip:($IsPester4 -or $notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
            Login-ToTestAzAccount
            $existingPolicies = @(Get-AzPolicyDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParameters.DisplayName) ) } )
            write-host $($existingPolicies | % Properties)
            $null -ne $existingPolicies | Should -BeTrue
            $existingPolicies.Count | Should -Be 2
        }
        
        It 'Should be able to retrieve 1 published initiative' -Skip:($IsPester4 -or $notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
            Login-ToTestAzAccount
            $existingInitiatives = @(Get-AzPolicySetDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParameters.DisplayName) ) } )
            $null -ne $existingInitiatives | Should -BeTrue
            $existingInitiatives.Count | Should -Be 1
        }
    }  
    AfterAll {
        if ($ReleaseBuild) {
            Login-ToTestAzAccount
            # Cleanup
            $existingInitiatives = @(Get-AzPolicySetDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParameters.DisplayName) ) } )

            foreach ($existingInitiative in $existingInitiatives) {
                $null = Remove-AzPolicySetDefinition -Name $existingInitiative.Name -Force
            }

            foreach ($existingPolicy in $existingPolicies) {
                $null = Remove-AzPolicyDefinition -Name $existingPolicy.Name -Force
            }
        }
    }
}
