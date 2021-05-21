
<#
    .SYNOPSIS
        Creates a new policy for guest configuration.

    .PARAMETER PolicyFolderPath
        Folder where policy exists.

    .PARAMETER PolicyInfo
        Policy information.

    .EXAMPLE
        $PolicyInfo = @{
            FileName                 = $FileName
            DisplayName              = $DisplayName
            Description              = $Description
            Platform                 = $Platform
            ConfigurationName        = $policyName
            ConfigurationVersion     = $Version
            ContentUri               = $ContentUri
            ContentHash              = $contentHash
            AssignmentType           = $Mode
            ReferenceId              = "Deploy_$policyName"
            ParameterInfo            = $ParameterInfo
            UseCertificateValidation = $packageIsSigned
            Category                 = $Category
            Tag                      = $Tag
        }
        New-GuestConfigurationPolicyDefinition -PolicyFolderPath $policyDefinitionsPath -PolicyInfo $PolicyInfo

#>
function New-GuestConfigurationPolicyDefinition
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        # TODO Rename this?
        $PolicyInfo
    )

    Write-Verbose -Message "Creating new Guest Configuration Policy to '$PolicyFolderPath'."

    if (Test-Path -Path $PolicyFolderPath)
    {
        $null = Remove-Item -Path $PolicyFolderPath -Force -Recurse -ErrorAction 'SilentlyContinue'
    }

    $null = New-Item -Path $PolicyFolderPath -ItemType 'Directory'

    # Determine DINE or AINE
    if ($PolicyInfo.FileName -eq 'DeployIfNotExists.json')
    {
        # DINE:
        foreach ($currentDeployPolicyInfo in $PolicyInfo)
        {
            $currentDeployPolicyInfo['FolderPath'] = $PolicyFolderPath
            New-GuestConfigurationDeployPolicyDefinition @currentDeployPolicyInfo
        }
    }
    else
    {
        # AINE:
        foreach ($currentAuditPolicyInfo in $PolicyInfo)
        {
            $currentAuditPolicyInfo['FolderPath'] = $PolicyFolderPath
            New-GuestConfigurationAuditPolicyDefinition @currentAuditPolicyInfo
        }
    }
}
