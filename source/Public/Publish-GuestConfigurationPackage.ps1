
<#
    .SYNOPSIS
        Publish a Guest Configuration policy package to Azure blob storage.
        The goal is to simplify the number of steps by scoping to a specific
        task.

        Generates a SAS token with read and list access to the blob with a limited lifespan.

        Requires a resource group, storage account, and container
        to be pre-staged. For details on how to pre-stage these things see the
        documentation for the Az Storage cmdlets.
        https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-powershell.

    .PARAMETER Path
        The path of the Guest Configuration package to publish

    .PARAMETER ResourceGroupName
        The name of the resource group that contains the Azure storage account you would like to publish to

    .PARAMETER StorageAccountName
        The name of the Azure storage account you would like to publish to

    .PARAMETER StorageContainerName
        The name of the blob container in Azure storage account you would like to publish to

    .PARAMETER SASExpirationInDays
        The number of days until the generated SAS token expires.
        The default value is (3 * 365) which is 3 years.

    .PARAMETER Force
        Indicates that this cmdlet overwrites an existing blob without prompting you for confirmation.

    .EXAMPLE
        Publish-GuestConfigurationPackage -Path ./package.zip -ResourceGroupName 'resourcegroup' -StorageAccountName 'sa12345'

    .OUTPUTS
        The URI of the uploaded package with a SAS token to access it.
        [PSCustomObject]@{
            ContentUri = $uriWithSAS
        }
#>

function Publish-GuestConfigurationPackage
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountName,

        [Parameter(Mandatory = $true)]
        [String]
        $StorageContainerName,

        [Parameter()]
        [int]
        $SASExpirationInDays = (365 * 3),

        [Parameter()]
        [Switch]
        $Force
    )

    # Test that path is valid
    $Path = Resolve-Path -Path $Path

    if (-not (Test-Path $Path -PathType 'Leaf'))
    {
        throw "Could not find a file at the path '$Path'"
    }

    $package = Get-Item -Path $Path

    # Get Storage Context
    $storageAccountContext = New-AzStorageContext -StorageAccountName $StorageAccountName

    $setAzStorageBlobContentParams = @{
        Context   = $storageAccountContext
        Container = $StorageContainerName
        Blob      = $package.Name
        File      = $Path
        Force     = $Force
    }

    # Upload file
    $null = Set-AzStorageBlobContent @setAzStorageBlobContentParams

    # Get url with SAS token
    $startTime = Get-Date
    $newAzStorageBlobSASTokenParams = @{
        Context    = $storageAccountContext
        Container  = $StorageContainerName
        Blob       = $package.Name
        StartTime  = $startTime
        ExpiryTime = $startTime.AddDays($SASExpirationInDays)
        Permission = 'rl'
        FullUri    = $true
    }

    $uriWithSAS = New-AzStorageBlobSASToken @newAzStorageBlobSASTokenParams

    # Output
    return [PSCustomObject]@{
        ContentUri = $uriWithSAS
    }
}
