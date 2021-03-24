function New-TestCertificate
{
    [CmdletBinding()]
    param ()

    # Create self signed certificate
    $certificatePath = "Cert:\LocalMachine\My"
    $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1

    if ($null -eq $certificate)
    {
        $newSelfsignedCertificateExParams = @{
            Subject            = "CN=testcert"
            EKU                = 'Code Signing'
            KeyUsage           = 'KeyEncipherment, DataEncipherment, DigitalSignature'
            SAN                = $env:ComputerName
            FriendlyName       = 'DSC Credential Encryption certificate'
            Exportable         = $true
            StoreLocation      = 'LocalMachine'
            KeyLength          = 2048
            ProviderName       = 'Microsoft Enhanced Cryptographic Provider v1.0'
            AlgorithmName      = 'RSA'
            SignatureAlgorithm = 'SHA256'
        }

        $null = New-SelfsignedCertificateEx @newSelfsignedCertificateExParams

    }

    $command = @'
$Cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { ($_.Subject -eq 'CN=testcert') } | Select-Object -First 1
Export-Certificate -FilePath "$TestDrive/exported.cer" -Cert $Cert
Import-Certificate -FilePath "$TestDrive/exported.cer" -CertStoreLocation Cert:\LocalMachine\Root
'@
    powershell.exe -NoProfile -NonInteractive -Command $command
}
