<#
    .SYNOPSIS
        Publish a Guest Configuration policy package to Azure blob storage.
        The goal is to simplify the number of steps by scoping to a specific
        task.

        Generates a SAS token with a 3-year lifespan, to mitigate the risk
        of a malicious person discovering the published content.

        Requires a resource group, storage account, and container
        to be pre-staged. For details on how to pre-stage these things see the
        documentation for the Az Storage cmdlets.
        https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-powershell.

    .Parameter Path
        Location of the .zip file containing the Guest Configuration artifacts

    .Parameter ResourceGroupName
        The Azure resource group for the storage account

    .Parameter StorageAccountName
        The name of the storage account for where the package will be published
        Storage account names must be globally unique

    .Parameter StorageContainerName
        Name of the storage container in Azure Storage account (default: "guestconfiguration")

    .Example
        Publish-GuestConfigurationPackage -Path ./package.zip -ResourceGroupName 'resourcegroup' -StorageAccountName 'sa12345'

    .OUTPUTS
        Return a publicly accessible URI containing a SAS token with a 3-year expiration.
#>

function Publish-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ResourceGroupName,

        [parameter(Position = 2, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $StorageAccountName,

        [string] $StorageContainerName = 'guestconfiguration',

        [switch] $Force
    )

    # Get Storage Context
    $Context = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName | `
        ForEach-Object { $_.Context }

    # Blob name from file name
    $BlobName = Get-Item $Path | ForEach-Object { $_.Name }

    # Upload file
    if ($true -eq $Force) {
        $Blob = Set-AzStorageBlobContent -Context $Context `
            -Container $StorageContainerName `
            -Blob $BlobName `
            -File $Path `
            -Force
    }
    else {
        $Blob = Set-AzStorageBlobContent -Context $Context `
            -Container $StorageContainerName `
            -Blob $BlobName `
            -File $Path
    }

    # Get url with SAS token
    # THREE YEAR EXPIRATION
    $StartTime = Get-Date
    $SAS = New-AzStorageBlobSASToken -Context $Context `
        -Container $StorageContainerName `
        -Blob $BlobName `
        -StartTime $StartTime `
        -ExpiryTime $StartTime.AddYears('3') `
        -Permission 'rl' `
        -FullUri

    # Create object to use property names
    $ContentUri = New-Object -TypeName PSObject -Property @{
        ContentUri = $SAS
    }

    # Output
    return $ContentUri
}
