######################################################
#  End to end Guest Configuration module reporting test
#  Verify report is sent for every consistency run of a 
#  configuration assignement.
######################################################

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

$IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
$IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO

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
                [ValidateSet('DSC', 'InSpec', 'WinDSC')]
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

                $dscDestinationFolderPath = New-Item -Path $DestinationFolderPath -Name 'DSCConfig' -ItemType Directory
                $dscDestinationMOFPath = Join-Path -Path $dscDestinationFolderPath -ChildPath 'localhost.mof'
                $null = Set-Content -Path $dscDestinationMOFPath -Value $dscConfig
            
                $filesToIncludeFolderPath = Join-Path -Path $DestinationFolderPath -ChildPath 'FilesToInclude'
                New-Item $filesToIncludeFolderPath -ItemType Directory
                $filesToIncludeFilePath = Join-Path -Path $filesToIncludeFolderPath -ChildPath 'file.txt'
                $filesToIncludeContent = 'test' | Set-Content -Path $filesToIncludeFilePath
            }
            #endregion
        
            #region Linux DSC config
            if ('Inspec' -eq $Type) {
                $dscConfig = @'
instance of MSFT_ChefInSpecResource as $MSFT_ChefInSpecResource1ref
{
Name = "linux-path";
ResourceID = "[ChefInSpecResource]Audit Linux path exists";
ModuleVersion = "3.1.0";
SourceInfo = "::7::1::ChefInSpecResource";
ModuleName = "GuestConfiguration";
ConfigurationName = "DSCConfig";
GithubPath = "linux-path/Modules/linux-path/";
};

instance of OMI_ConfigurationDocument
{
Version="2.0.0";
MinimumCompatibleVersion = "1.0.0";
CompatibleVersionAdditionalProperties= {"Omi_BaseResource:ConfigurationName"};
Name="DSCConfig";
};                
'@

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
                $inspecDestinationFolderPath = New-Item -Path $DestinationFolderPath -Name 'InspecConfig' -ItemType Directory
                $inspecDestinationMOFPath = Join-Path -Path $inspecDestinationFolderPath -ChildPath 'localhost.mof'
                $null = Set-Content -Path $inspecDestinationMOFPath -Value $dscConfig    

                # creates directory for Inspec profile
                $InSpecProfilePath = Join-Path -Path $inspecDestinationFolderPath -ChildPath $inSpecProfileName
                $null = New-Item -ItemType Directory -Path $InSpecProfilePath
        
                # creates Inspec profile required Yml file
                $InSpecProfileYmlFilePath = Join-Path -Path $InSpecProfilePath -ChildPath 'inspec.yml'
                $null = Set-Content -Path $InSpecProfileYmlFilePath -Value $inSpecProfile
        
                # creates directory for Inspec controls (component of Inspec profile)
                $InSpecControlsPath = Join-Path -Path $InSpecProfilePath -ChildPath 'controls'
                $null = New-Item -ItemType Directory -Path $InSpecControlsPath
        
                # creates Inspec controls required Ruby file
                $InSpecControlsRubyFilePath = Join-Path -Path $InSpecControlsPath -ChildPath "$inSpecProfileName.rb"
                $null = Set-Content -Path $InSpecControlsRubyFilePath -Value $inSpecProfileRB
            }
            #endregion 

            #region Windows DSC config using invalid resources
            if ('WinDSC' -eq $Type) {
                $dscConfig = @'
instance of MSFT_FileDirectoryConfiguration as $MSFT_FileDirectoryConfiguration1ref
{
ResourceID = "[File]test";
Ensure = "Present";
Contents = "test";
DestinationPath = "c:\\test";
ModuleName = "PSDesiredStateConfiguration";
SourceInfo = "::1::76::file";
ModuleVersion = "1.0";
ConfigurationName = "file";
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
        }
        #TODO
        function New-TestGCPolicyParameters {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [String]
                $DestinationFolderPath,

                [Parameter(Mandatory = $true)]
                [ValidateSet('Windows', 'Linux')]
                [String]
                $Platform
            )
        
            if (Test-CurrentMachineIsWindows) {
                $computerInfo = Get-ComputerInfo
                $currentWindowsOSString = $computerInfo.WindowsProductName
            }
            else {
                $currentWindowsOSString = 'Non-Windows'
            }
            
            if ('Windows' -eq $Platform) {
                $newGCPolicyParameters = @{
                    ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
                    DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
                    Description = 'Policy to audit a Windows service'
                    Path        = $DestinationFolderPath
                    Version     = '1.0.0.0'
                    Platform    = 'Windows'
                }
            }
            elseif ('Linux' -eq $Platform) {
                $newGCPolicyParameters = @{
                    ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
                    DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
                    Description = 'Policy to audit a Linux path'
                    Path        = $DestinationFolderPath
                    Version     = '1.0.0.0'
                    Platform    = 'Linux'
                }
            }
        
            return $newGCPolicyParameters
        }

        function New-PublishGCPackageParameters {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [String]
                $Path,

                [Parameter(Mandatory = $true)]
                [String]
                $DateStamp
            )

            # Create test Resource Group
            $resourceGroup = New-AzResourceGroup "GC_Module_$DateStamp" -Location 'westus'

            # Create test Storage Account
            $randomString = (get-date).ticks.tostring().Substring(12)
            $storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName `
                -Name "sa$randomString" `
                -SkuName Standard_LRS `
                -Location 'westus'

            $ctx = $storageAccount.Context

            # Storage Container
            $containerName = "guestconfiguration"
            New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob
            
            $publishGCPackageParameters = @{
                Path               = $Path
                ResourceGroupName  = "GC_Module_$DateStamp"
                StorageAccountName = "sa$randomString"
            }
        
            return $publishGCPackageParameters
        }

        function Get-AzMocks {
            [CmdletBinding()]
            param()
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

            $firstPSModulePathFolder = ($Env:PSModulePath -split $delimiter)[0]
            Copy-Item $gcModuleFolderPath (Join-Path $firstPSModulePathFolder 'GuestConfiguration') -Recurse
        
            $gcModulePath = Join-Path (Join-Path $firstPSModulePathFolder 'GuestConfiguration') 'GuestConfiguration.psd1'
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
        
            Write-Verbose "Running in Azure DevOps: $env:ADO" -Verbose
            $NotWindows = $($IsLinux -or $IsMacOS)
            Write-Verbose "Running on Linux or MacOS: $NotWindows" -Verbose
            $psTitleLine = "POWERSHELL INFO"
            Write-Verbose -Message "`n$psTitleLine`n$('-' * $psTitleLine.length) $($PSVersionTable | Format-List | Out-String)"  -Verbose
            Write-ModuleInfo -ModuleName 'Pester'
            Write-EnvironmentVariableInfo
        }
    
        Initialize-MachineForGCTesting
        
        Write-EnvironmentInfo
    
        # Set up test paths
        $dscConfigFolderPath = Join-Path -Path $TestDrive -ChildPath 'DSCConfig'
        $mofPath = Join-Path -Path $dscConfigFolderPath -ChildPath 'localhost.mof'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $policyName = 'testPolicy'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'
        $unsignedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'UnsignedPackage'
        $filesToIncludeFolderPath = Join-Path -Path $TestDrive -ChildPath 'FilesToInclude'
        $filesToIncludePackagePath = Join-Path -Path $testOutputPath -ChildPath 'FilesToIncludePackage'
        $filesToIncludeExtractionPath = Join-Path $testOutputPath -ChildPath 'FilesToIncludeUnsignedPackage'
        $extractedFilesToIncludePath = Join-Path -Path $filesToIncludeExtractionPath -ChildPath 'FilesToInclude'
        $mofFilePath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath "$policyName.mof"
        $inSpecFolderPath = Join-Path -Path $TestDrive -ChildPath 'InspecConfig'
        $inspecMofPath = Join-Path -Path $inSpecFolderPath -ChildPath 'localhost.mof'
        $inspecPackagePath = Join-Path -Path $testOutputPath -ChildPath 'InspecPackage'
        $inspecExtractionPath = Join-Path $testOutputPath -ChildPath 'InspecUnsignedPackage'
        $inspecProfileName = 'linux-path'
        $extractedInSpecPath = Join-Path -Path $inspecExtractionPath -ChildPath (Join-Path 'Modules' $inspecProfileName)
        $signedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'SignedPackage'
        $currentDateString = Get-Date -Format "yyyy-MM-dd HH:mm"
        $expectedPolicyType = 'Custom'
        $expectedContentHash = 'D421E3C8BB2298AEC5CFD95607B91241B7D5A2C88D54262ED304CA1FD01370F3'
        $testPolicyNameWindows = 'AuditWindowsService'
        $testPolicyNameLinux = 'AuditWindowsService'
        $testOutputPathWindows = Join-Path -Path $TestDrive -ChildPath 'policyDefinitionsWindows'
        $testOutputPathLinux = Join-Path -Path $TestDrive -ChildPath 'policyDefinitionsLinux'

        $Date = Get-Date
        $DateStamp = "$($Date.Hour)_$($Date.Minute)_$($Date.Second)_$($Date.Month)-$($Date.Day)-$($Date.Year)"
        
        $newGCPolicyParametersWindows = New-TestGCPolicyParameters -DestinationFolderPath $testOutputPathWindows -Platform 'Windows'
        $newGCPolicyParametersLinux = New-TestGCPolicyParameters -DestinationFolderPath $testOutputPathLinux -Platform 'Linux'
        
        New-TestDscConfiguration -DestinationFolderPath $TestDrive
        New-TestDscConfiguration -DestinationFolderPath $TestDrive -Type 'Inspec'

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

        It 'creates custom policy package' {
            $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath
            Test-Path -Path $package.Path | Should -BeTrue
            $package.Name | Should -Be $policyName
        }

        It 'does not overwrite a custom policy package when -Force is not specified' {
            { New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -ErrorAction Stop } | Should -Throw
        }

        It 'overwrites a custom policy package when -Force is specified' {
            { New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force -ErrorAction Stop } | Should -Not -Throw
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
            $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $filesToIncludePackagePath -FilesToInclude $FilesToIncludeFolderPath
            $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $filesToIncludeExtractionPath) } | Should -Not -Throw
            Test-Path -Path $extractedFilesToIncludePath | Should -BeTrue
            $extractedFile = Join-Path $extractedFilesToIncludePath 'file.txt'
            Test-Path -Path $extractedFile | Should -BeTrue
            Get-Content $extractedFile | Should -Be 'test'
        }

        It 'Implements -ChefInspecProfilePath parameter' {
            $package = New-GuestConfigurationPackage -Configuration $inspecMofPath -Name $policyName -Path $inspecPackagePath -ChefInspecProfilePath $inSpecFolderPath
            $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $inspecExtractionPath) } | Should -Not -Throw
            $extractedInspecPath | Should -Exist
            $inspecYmlExtractedFile = Join-Path $extractedInspecPath 'inspec.yml'
            $inspecYmlExtractedFile | Should -Exist
            $inspecControlsExtractedFile = Join-Path $extractedInspecPath 'controls'
            $inspecControlsExtractedFile | Should -Exist
            $inspecRbExtractedFile = Join-Path $inspecControlsExtractedFile 'linux-path.rb'
            $inspecRbExtractedFile | Should -Exist
        }
    }
    Context 'Test-GuestConfigurationPackage' {

        It 'Validate that the resource compliance results are as expected on Windows' -Skip:($IsLinux -or $IsMacOS) {
            $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path
            $testPackageResult.complianceStatus | Should -Be $false
            $testPackageResult.resources[0].ModuleName | Should -Be 'ComputerManagementDsc'
            $testPackageResult.resources[0].complianceStatus | Should -Be $false
            $testPackageResult.resources[0].ConfigurationName | Should -Be 'DSCConfig'
            $testPackageResult.resources[0].IsSingleInstance | Should -Be 'Yes'
        }

        It 'Validate that the resource compliance results are as expected on Linux' -Skip:($IsWindows -or $IsMacOS) {
            $package = New-GuestConfigurationPackage -Configuration $inspecMofPath -Name $policyName -Path $inspecPackagePath -ChefInspecProfilePath $inSpecFolderPath
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path
            $testPackageResult.complianceStatus | Should -Be $true
            $testPackageResult.resources[0].ModuleName | Should -Be 'GuestConfiguration'
            $testPackageResult.resources[0].complianceStatus | Should -Be $true
            $testPackageResult.resources[0].ConfigurationName | Should -Be 'DSCConfig'
        }
    } 
    Context 'Protect-GuestConfigurationPackage' {
        
        It 'Signed package should exist at output path' -Skip:($IsLinux -or $IsMacOS) {
            $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath
            New-TestCertificate
            $certificatePath = "Cert:\LocalMachine\My"
            $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
            $protectPackageResult = Protect-GuestConfigurationPackage -Path $package.Path -Certificate $certificate 
            Test-Path -Path $protectPackageResult.Path | Should -BeTrue
        }
    
        It 'Signed package should be extractable' -Skip:($IsLinux -or $IsMacOS) {
            $signedFileName = $policyName + "_signed.zip"
            $package = Get-Item "$testPackagePath/$policyName/$signedFileName"
            # Set up type needed for package extraction
            $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.FullName, $signedPackageExtractionPath) } | Should -Not -Throw
        }

        It '.cat file should exist in the extracted package' -Skip:($IsLinux -or $IsMacOS) {
            $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath "$policyName.cat"
            Test-Path -Path $catFilePath | Should -BeTrue
        }

        It 'Extracted .cat file thumbprint should match certificate thumbprint' -Skip:($IsLinux -or $IsMacOS) {
            $certificatePath = "Cert:\LocalMachine\My"
            $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
            $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath "$policyName.cat"
            $authenticodeSignature = Get-AuthenticodeSignature -FilePath $catFilePath
            $authenticodeSignature.SignerCertificate.Thumbprint | Should -Be $certificate.Thumbprint
        }
    }
    Context 'Publish-GuestConfigurationPackage' {

        It 'Should be able to publish packages and return a valid Uri' -Skip:($notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
            Login-ToTestAzAccount
            $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath
            $publishGCPackageParameters = New-PublishGCPackageParameters -Path $package.Path -DateStamp $DateStamp
            $Uri = Publish-GuestConfigurationPackage -Path $publishGCPackageParameters.Path -ResourceGroupName $publishGCPackageParameters.ResourceGroupName -StorageAccountName $publishGCPackageParameters.StorageAccountName
            $Uri.ContentUri | Should -Not -BeNullOrEmpty
            $Uri.ContentUri | Should -BeOfType 'String'
            $Uri.ContentUri | Should -Not -Contain '@'
            { Invoke-WebRequest -Uri $Uri.ContentUri -OutFile $TestDrive/downloadedPackage.zip } | Should -Not -Throw
        }
    }
    Context 'New-GuestConfigurationPolicy' {

        It 'New-GuestConfigurationPolicy should output path to generated policies' -Skip:($IsNotWindowsAndIsAzureDevOps) {
            if ($notReleaseBuild) {
                function Get-AzContext {}
                Get-AzMocks
            }
            else {
                Login-ToTestAzAccount
            }
            $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyParametersWindows
            $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue
            
            $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyParametersLinux
            $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
        }

        It 'Generated Audit policy file should exist' -Skip:($IsNotWindowsAndIsAzureDevOps) {
            $auditPolicyFileWindows = Join-Path -Path $testOutputPathWindows -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileWindows | Should -BeTrue
            
            $auditPolicyFileLinux = Join-Path -Path $testOutputPathLinux -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileLinux | Should -BeTrue
        }

        It 'Audit policy should contain expected content' -Skip:($IsNotWindowsAndIsAzureDevOps) {

            $auditPolicyFileWindows = Join-Path -Path $testOutputPathWindows -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentWindows = Get-Content $auditPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentWindows.properties.displayName.Contains($newGCPolicyParametersWindows.DisplayName) | Should -BeTrue
            $auditPolicyContentWindows.properties.description.Contains($newGCPolicyParametersWindows.Description) | Should -BeTrue
            $auditPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentWindows.properties.policyType | Should -Be $expectedPolicyType
            $auditPolicyContentWindows.properties.policyRule.then.details.name | Should -Be $testPolicyNameWindows
            $auditPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'

            $auditPolicyFileLinux = Join-Path -Path $testOutputPathLinux -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentLinux = Get-Content $auditPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentLinux.properties.displayName.Contains($newGCPolicyParametersLinux.DisplayName) | Should -BeTrue
            $auditPolicyContentLinux.properties.description.Contains($newGCPolicyParametersLinux.Description) | Should -BeTrue
            $auditPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentLinux.properties.policyType | Should -Be $expectedPolicyType
            $auditPolicyContentLinux.properties.policyRule.then.details.name | Should -Be $testPolicyNameLinux
            $auditPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
        }
    }
    Context 'Publish-GuestConfigurationPolicy' {

        It 'Should be able to publish policies' -Skip:($notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
            Login-ToTestAzAccount
            $newGCPolicyResult = New-GuestConfigurationPolicy @newGCPolicyParametersWindows
            { $publishGCPolicyResult = $newGCPolicyResult | Publish-GuestConfigurationPolicy } | Should -Not -Throw
        }

        It 'Should be able to retrieve 1 published policies' -Skip:($notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
            Login-ToTestAzAccount
            $existingPolicies = @(Get-AzPolicyDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParametersWindows.DisplayName) ) } )
            write-host $($existingPolicies | ForEach-Object Properties)
            $null -ne $existingPolicies | Should -BeTrue
            $existingPolicies.Count | Should -Be 1
        }
    }  
    AfterAll {
        if ($ReleaseBuild) {
            Login-ToTestAzAccount
            # Cleanup
            
            $existingPolicy = @(Get-AzPolicyDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParameters.DisplayName) ) } )
            if ($null -ne $existingPolicy) {
                $null = Remove-AzPolicyDefinition -Name $existingPolicy.Name -Force
            }

            $RG = Get-AzResourceGroup "GC_Module_$DateStamp" -ErrorAction SilentlyContinue
            if ($null -ne $RG) {
                $null = Remove-AzResourceGroup "GC_Module_$DateStamp" -Force
            }
        }
    }
}
