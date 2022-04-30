function New-TestCertificate
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    param ()

    # Create a code signing cert
    $myCert = New-SelfSignedCertificate -Type 'CodeSigningCert' -DnsName 'GCModuleTestOnly' -HashAlgorithm 'SHA256'

    # Export the certificates

    $myPwd = ConvertTo-SecureString -String 'Password1234' -Force -AsPlainText
    $myCert | Export-PfxCertificate -FilePath 'C:\demo\GCPrivateKey.pfx' -Password $myPwd
    $myCert | Export-Certificate -FilePath 'C:\demo\GCPublicKey.cer' -Force

    # Import the certificate
    $null = Import-PfxCertificate -FilePath 'C:\demo\GCPrivateKey.pfx' -Password $myPwd -CertStoreLocation 'Cert:\LocalMachine\My'

    # Sign the package
    $certToSignThePackage = Get-ChildItem -Path  'Cert:\LocalMachine\My' | Where-Object { ($_.Subject -eq 'CN=GCModuleTestOnly') }
    return $certToSignThePackage
}
