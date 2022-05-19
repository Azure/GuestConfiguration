
<#
    .SYNOPSIS
        Signs a Guest Configuration package using either a certificate on Windows
        or GPG keys on Linux.

    .PARAMETER Path
        The path of the Guest Configuration package to sign.

    .PARAMETER Certificate
        The 'Code Signing' certificate to sign the package with.
        This is only supported on Windows.

        This certificate will need to be installed on machines running this package.

        See examples for how to generate a test certificate.

    .PARAMETER PrivateGpgKeyPath
        The private GPG key path to sign the package with.
        This is only supported on Linux.

        See examples for how to generate this key.

    .PARAMETER PublicGpgKeyPath
        The public GPG key path to sign the package with.
        This is only supported on Linux.

        This key will need to be installed on any machines running this package at the path:
            /usr/local/share/ca-certificates/gc/pub_keyring.gpg

        See examples for how to generate this key.

    .EXAMPLE
        # Windows
        # Please note that self-signed certs should not be used in production, only testing

        # Create a code signing cert
        $myCert = New-SelfSignedCertificate -Type 'CodeSigningCert' -DnsName 'GCEncryptionCertificate' -HashAlgorithm 'SHA256'

        # Export the certificates
        $myPwd = ConvertTo-SecureString -String 'Password1234' -Force -AsPlainText
        $myCert | Export-PfxCertificate -FilePath 'C:\demo\GCPrivateKey.pfx' -Password $myPwd
        $myCert | Export-Certificate -FilePath 'C:\demo\GCPublicKey.cer' -Force

        # Import the certificate
        Import-PfxCertificate -FilePath 'C:\demo\GCPrivateKey.pfx' -Password $myPwd -CertStoreLocation 'Cert:\LocalMachine\My'

        # Sign the package
        $certToSignThePackage = Get-ChildItem -Path cert:\LocalMachine\My | Where-Object {($_.Subject-eq "CN=GCEncryptionCertificate") }
        Protect-GuestConfigurationPackage -Path C:\demo\AuditWindowsService.zip -Certificate $certToSignThePackage -Verbose

    .EXAMPLE
        # Linux
        # Generate gpg key
        gpg --gen-key

        # Export public key
        gpg --output public.gpg --export <email-id used to generate gpg key>
        # Export private key
        gpg --output private.gpg --export-secret-key <email-id used to generate gpg key>

        # Sign Linux policy package
        Protect-GuestConfigurationPackage -Path ./not_installed_application_linux.zip -PrivateGpgKeyPath ./private.gpg -PublicGpgKeyPath ./public.gpg -Verbose

    .OUTPUTS
        Returns the name of the configuration in the package and the path of the output signed Guest Configuration package.
        $result = [PSCustomObject]@{
            Name = $configurationName
            Path = $signedPackageFilePath
        }
#>
function Protect-GuestConfigurationPackage
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Certificate")]
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "GpgKeys")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        [Parameter(Mandatory = $true, ParameterSetName = "Certificate")]
        [ValidateNotNullOrEmpty()]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]
        $Certificate,

        [Parameter(Mandatory = $true, ParameterSetName = "GpgKeys")]
        [ValidateNotNullOrEmpty()]
        [String]
        $PrivateGpgKeyPath,

        [Parameter(Mandatory = $true, ParameterSetName = "GpgKeys")]
        [ValidateNotNullOrEmpty()]
        [String]
        $PublicGpgKeyPath
    )

    $os = Get-OSPlatform

    if ($PSCmdlet.ParameterSetName -eq 'GpgKeys' -and $os -ine 'Linux')
    {
        throw 'GPG key signing is only supported on Linux.'
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Certificate' -and $os -ine 'Windows')
    {
        throw 'Certificate signing is only supported on Windows.'
    }

    $Path = Resolve-RelativePath -Path $Path
    if (-not (Test-Path $Path -PathType 'Leaf'))
    {
        throw "Could not find a file at the path '$Path'"
    }

    if ($PSCmdlet.ParameterSetName -eq 'GpgKeys')
    {
        $PrivateGpgKeyPath = Resolve-RelativePath -Path $PrivateGpgKeyPath
        if (-not (Test-Path -Path $PrivateGpgKeyPath))
        {
            throw "Could not find the private GPG key file at the path '$PrivateGpgKeyPath'"
        }

        $PublicGpgKeyPath = Resolve-RelativePath -Path $PublicGpgKeyPath
        if (-not (Test-Path -Path $PublicGpgKeyPath))
        {
            throw "Could not find the public GPG key file at the path '$PublicGpgKeyPath'"
        }
    }

    $package = Get-Item -Path $Path
    $packageDirectory = $package.Directory
    $packageFileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

    $signedPackageName = "$($packageFileName)_signed.zip"

    $signedPackageFilePath = Join-Path -Path $packageDirectory -ChildPath $signedPackageName
    if (Test-Path -Path $signedPackageFilePath)
    {
        $null = Remove-Item -Path $signedPackageFilePath -Force
    }

    $tempDirectory = Reset-GCWorkerTempDirectory

    try
    {
        # Unzip policy package.
        $null = Expand-Archive -Path $Path -DestinationPath $tempDirectory

        # Find and validate the mof file
        $mofFilePattern = '*.mof'
        $mofChildItems = @( Get-ChildItem -Path $tempDirectory -Filter $mofFilePattern -File )

        if ($mofChildItems.Count -eq 0)
        {
            throw "No .mof file found in the package. The Guest Configuration package must include a compiled DSC configuration (.mof) with the same name as the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
        }
        elseif ($mofChildItems.Count -gt 1)
        {
            throw "Found more than one .mof file in the extracted Guest Configuration package. Please remove any extra .mof files from the root of the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
        }

        $mofFile = $mofChildItems[0]
        $configurationName = $mofFile.BaseName

        if ($PSCmdlet.ParameterSetName -eq 'Certificate')
        {
            # Create catalog file
            $catalogFilePath = Join-Path -Path $tempDirectory -ChildPath "$configurationName.cat"

            if (Test-Path -Path $catalogFilePath)
            {
                $null = Remove-Item -Path $catalogFilePath -Force
            }

            Write-Verbose -Message "Creating the catalog file at '$catalogFilePath'"
            $null = New-FileCatalog -Path $tempDirectory -CatalogFilePath $catalogFilePath -CatalogVersion 2

            # Sign catalog file
            Write-Verbose -Message "Signing the catalog file at '$catalogFilePath'"
            $codeSignOutput = Set-AuthenticodeSignature -Certificate $Certificate -FilePath $catalogFilePath

            # Validate that file was signed
            $signature = Get-AuthenticodeSignature -FilePath $catalogFilePath
            if ($null -eq $signature.SignerCertificate)
            {
                throw $codeSignOutput.StatusMessage
            }
            elseif ($signature.SignerCertificate.Thumbprint -ne $Certificate.Thumbprint)
            {
                throw $codeSignOutput.StatusMessage
            }
        }
        else
        {
            $ascFilePath = Join-Path -Path $tempDirectory -ChildPath "$configurationName.asc"
            $hashFilePath = Join-Path -Path $tempDirectory -ChildPath "$configurationName.sha256sums"

            Write-Verbose -Message "Creating hash file at '$hashFilePath'"

            Push-Location -Path $tempDirectory
            try
            {
                bash -c "find ./ -type f -print0 | xargs -0 sha256sum | grep -v sha256sums > $hashFilePath"
            }
            finally
            {
                Pop-Location
            }

            Write-Verbose -Message "Signing hash file at '$hashFilePath'"
            gpg --import $PrivateGpgKeyPath
            gpg --no-default-keyring --keyring $PublicGpgKeyPath --output $ascFilePath --armor --detach-sign $hashFilePath
        }

        # Zip the signed Guest Configuration package
        Write-Verbose -Message "Creating the signed Guest Configuration package at '$signedPackageFilePath'"
        $archiveSourcePath = Join-Path -Path $tempDirectory -ChildPath '*'
        $null = Compress-Archive -Path $archiveSourcePath -DestinationPath $signedPackageFilePath

        $result = [PSCustomObject]@{
            Name = $configurationName
            Path = $signedPackageFilePath
        }
    }
    finally
    {
        $null = Reset-GCWorkerTempDirectory
    }

    return $result
}
