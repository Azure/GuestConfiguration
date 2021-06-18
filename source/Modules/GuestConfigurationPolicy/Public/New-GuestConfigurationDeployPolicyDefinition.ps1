function New-GuestConfigurationDeployPolicyDefinition
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FileName,

        [Parameter(Mandatory = $true)]
        [String]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [String]
        $Description,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentHash,

        [Parameter()]
        [AssignmentType]
        $AssignmentType,

        [Parameter(Mandatory = $true)]
        [String]
        $ReferenceId,

        [Parameter()]
        [Hashtable[]]
        $ParameterInfo,

        [Parameter()]
        [String]
        $Guid,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter()]
        [bool]
        $UseCertificateValidation = $false,

        [Parameter()]
        [String]
        $Category = 'Guest Configuration',

        [Parameter()]
        [Hashtable[]]
        $Tag
    )


    $filePath = Join-Path -Path $FolderPath -ChildPath $FileName
    Write-Verbose -Message "Creating Guest Configuration Deploy Policy Definition to '$filePath'."

    if (-not [String]::IsNullOrEmpty($Guid))
    {
        $deployPolicyGuid = $Guid
    }
    else
    {
        $deployPolicyGuid = [Guid]::NewGuid()
    }

    $ParameterMapping = @{ }
    $ParameterDefinitions = @{ }
    $PolicyContentHashtable = [Ordered]@{ }
    $existenceConditionList = [Ordered]@{
        allOf = [System.Collections.ArrayList]@()
    }

    if ($null -ne $ParameterInfo)
    {
        $ParameterMapping = Get-ParameterMappingForDINE -ParameterInfo $ParameterInfo
        $ParameterDefinitions = Get-ParameterDefinition -ParameterInfo $ParameterInfo
    }

    $ParameterDefinitions['IncludeArcMachines'] += [Ordered]@{
        type          = "string"
        metadata      = [Ordered]@{
            displayName = 'Include Arc connected servers'
            description = 'By selecting this option, you agree to be charged monthly per Arc connected machine.'
        }

        allowedValues = @('True', 'False')
        defaultValue  = 'False'
    }

    $deployPolicyContentHashtable = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType  = 'Custom'
            mode        = 'Indexed'
            description = $Description
            metadata    = [Ordered]@{
                version = $ConfigurationVersion
                category          = $Category
                requiredProviders = @(
                    'Microsoft.GuestConfiguration'
                )
            }
            parameters  = $ParameterDefinitions
        }
    }

    $policyRuleHashtable = [Ordered]@{
        if   = [Ordered]@{
            anyOf = @(
                [Ordered]@{
                    allOf = @(
                        [Ordered]@{
                            field  = 'type'
                            equals = "Microsoft.Compute/virtualMachines"
                        }
                    )
                },
                [Ordered]@{
                    allOf = @(
                        [Ordered]@{
                            value  = "[parameters('IncludeArcMachines')]"
                            equals = "true"
                        },
                        [Ordered]@{
                            field  = "type"
                            equals = "Microsoft.HybridCompute/machines"
                        }
                    )
                }
            )
        }
        then = [Ordered]@{
            effect  = 'deployIfNotExists'
            details = [Ordered]@{
                type              = 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
                name              = $ConfigurationName
                roleDefinitionIds = @('/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c')
            }
        }
    }

    $deploymentHashtable = [Ordered]@{
        properties = [Ordered]@{
            mode       = 'incremental'
            parameters = [Ordered]@{
                vmName            = [Ordered]@{
                    value = "[field('name')]"
                }
                location          = [Ordered]@{
                    value = "[field('location')]"
                }
                type              = [Ordered]@{
                    value = "[field('type')]"
                }
                configurationName = [Ordered]@{
                    value = $ConfigurationName
                }
                contentUri        = [Ordered]@{
                    value = $ContentUri
                }
                contentHash       = [Ordered]@{
                    value = $ContentHash
                }
            }
            template   = [Ordered]@{
                '$schema'      = 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion = '1.0.0.0'
                parameters     = [Ordered]@{
                    vmName            = [Ordered]@{
                        type = 'string'
                    }
                    location          = [Ordered]@{
                        type = 'string'
                    }
                    type              = [Ordered]@{
                        type = 'string'
                    }
                    configurationName = [Ordered]@{
                        type = 'string'
                    }
                    contentUri        = [Ordered]@{
                        type = 'string'
                    }
                    contentHash       = [Ordered]@{
                        type = 'string'
                    }
                }
                resources      = @()
            }
        }
    }

    $guestConfigurationAssignmentHashtable = @(
        # Compute
        [Ordered]@{
            condition  = "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]"
            apiVersion = '2018-11-20'
            type       = 'Microsoft.Compute/virtualMachines/providers/guestConfigurationAssignments'
            name       = "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('configurationName'))]"
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                guestConfiguration = [Ordered]@{
                    name            = "[parameters('configurationName')]"
                    version         = $ConfigurationVersion
                    contentUri      = "[parameters('contentUri')]"
                    contentHash     = "[parameters('contentHash')]"
                    assignmentType  = "$AssignmentType"
                    configurationParameter = $ParameterMapping
                }
            }
        }
        # Hybrid Compute
        [Ordered]@{
            condition  = "[equals(toLower(parameters('type')), toLower('microsoft.hybridcompute/machines'))]"
            apiVersion = '2018-11-20'
            type       = 'Microsoft.HybridCompute/machines/providers/guestConfigurationAssignments'
            name       = "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('configurationName'))]"
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                guestConfiguration = [Ordered]@{
                    name        = "[parameters('configurationName')]"
                    contentUri  = "[parameters('contentUri')]"
                    contentHash = "[parameters('contentHash')]"
                    assignmentType  = "$AssignmentType"
                    version     = $ConfigurationVersion
                    configurationParameter = $ParameterMapping
                }
            }
        }
    )

    if ($Platform -ieq 'Windows')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in    = @(
                            'esri',
                            'incredibuild',
                            'MicrosoftDynamicsAX',
                            'MicrosoftSharepoint',
                            'MicrosoftVisualStudio',
                            'MicrosoftWindowsDesktop',
                            'MicrosoftWindowsServerHPCPack'
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'MicrosoftWindowsServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'MicrosoftSQLServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageOffer'
                                notLike = 'SQL2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'dsvm-windows'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'standard-data-science-vm',
                                    'windows-data-science-vm'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'batch'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'rendering-windows2016'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'cis-windows-server-201*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'pivotal'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'bosh-windows-server*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloud-infrastructure-services'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'ad*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                anyOf = @(
                                    [Ordered]@{
                                        field  = 'Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration'
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = 'Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType'
                                        like  = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{
                                anyOf = @(
                                    [Ordered]@{
                                        field  = 'Microsoft.Compute/imageSKU'
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{
                                                field   = 'Microsoft.Compute/imageSKU'
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field   = 'Microsoft.Compute/imageOffer'
                                                notLike = 'SQL2008*'
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = 'Microsoft.HybridCompute/imageOffer'
                like  = 'windows*'
            }
        )
    }
    elseif ($Platform -ieq 'Linux')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = 'Microsoft.Compute/imagePublisher'
                        in    = @(
                            'microsoft-aks',
                            'qubole-inc',
                            'datastax',
                            'couchbase',
                            'scalegrid',
                            'checkpoint',
                            'paloaltonetworks'
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'OpenLogic'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'CentOS*'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Oracle'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'Oracle-Linux'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'RedHat'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'RHEL',
                                    'RHEL-HA'
                                    'RHEL-SAP',
                                    'RHEL-SAP-APPS',
                                    'RHEL-SAP-HA',
                                    'RHEL-SAP-HANA'
                                )
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'RedHat'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'osa',
                                    'rhel-byos'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'cis-centos-7-l1',
                                    'cis-centos-7-v2-1-1-l1'
                                    'cis-centos-8-l1',
                                    'cis-debian-linux-8-l1',
                                    'cis-debian-linux-9-l1',
                                    'cis-nginx-centos-7-v1-1-0-l1',
                                    'cis-oracle-linux-7-v2-0-0-l1',
                                    'cis-oracle-linux-8-l1',
                                    'cis-postgresql-11-centos-linux-7-level-1',
                                    'cis-rhel-7-l2',
                                    'cis-rhel-7-v2-2-0-l1',
                                    'cis-rhel-8-l1',
                                    'cis-suse-linux-12-v2-0-0-l1',
                                    'cis-ubuntu-linux-1604-v1-0-0-l1',
                                    'cis-ubuntu-linux-1804-l1'

                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'credativ'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'Debian'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '7*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Suse'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'SLES*'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '11*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Canonical'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'UbuntuServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '12*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'linux-data-science-vm-ubuntu',
                                    'azureml'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloudera'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'cloudera-centos-os'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloudera'
                            },
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'cloudera-altus-centos-os'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'linux*'
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "linux*"
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = 'Microsoft.HybridCompute/imageOffer'
                like  = 'linux*'
            }
        )

    }
    else
    {
        throw "The specified platform '$Platform' is not currently supported by this script."
    }

    # If there is at least one tag
    if ($PSBoundParameters.ContainsKey('Tag') -AND $null -ne $Tag)
    {
        # Capture existing 'anyOf' section
        $anyOf = $policyRuleHashtable['if']
        # Replace with new 'allOf' at top order
        $policyRuleHashtable['if'] = [Ordered]@{
            allOf = @(
            )
        }

        # Add tags section under new 'allOf'
        $policyRuleHashtable['if']['allOf'] += [Ordered]@{
            allOf = @(
            )
        }

        # Re-insert 'anyOf' under new 'allOf' after tags 'allOf'
        $policyRuleHashtable['if']['allOf'] += $anyOf
        # Add each tag individually to tags 'allOf'
        for ($i = 0; $i -lt $Tag.count; $i++)
        {
            # If there is at least one tag
            if (-not [string]::IsNullOrEmpty($Tag[$i].Keys))
            {
                $policyRuleHashtable['if']['allOf'][0]['allOf'] += [Ordered]@{
                    field  = "tags.$($Tag[$i].Keys)"
                    equals = "$($Tag[$i].Values)"
                }
            }
        }
    }

    # Handle adding parameters if needed
    if ($null -ne $ParameterInfo -and $ParameterInfo.Count -gt 0)
    {
        $parameterValueConceatenatedStringList = @()

        if (-not $deployPolicyContentHashtable['properties'].Contains('parameters'))
        {
            $deployPolicyContentHashtable['properties']['parameters'] = [Ordered]@{ }
        }

        foreach ($guestConfigurationAssignment in $guestConfigurationAssignmentHashtable)
        {
            if (-not $guestConfigurationAssignment['properties']['guestConfiguration'].Contains('configurationParameter'))
            {
                $guestConfigurationAssignment['properties']['guestConfiguration']['configurationParameter'] = @()
            }
        }

        # Parameter Hash Section
        $parameterValueConceatenatedStringList = @()
        foreach ($parameterPair in $ParameterMapping) {
            $name = $parameterPair.name
            $value = $parameterPair.value -replace "[][]",""

            $currentParameterValueConcatenatedString = "'$name', '=', $value"
            $parameterValueConceatenatedStringList += $currentParameterValueConcatenatedString
        }

        $allParameterValueConcantenatedString = $parameterValueConceatenatedStringList -join ", ',', "
        $parameterExistenceConditionEqualsValue = "[base64(concat($allParameterValueConcantenatedString))]"
        $existenceConditionList['allOf'].Add([Ordered]@{
            field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
            equals = $parameterExistenceConditionEqualsValue
        })

        # Adding parameters into the deploymentHashTable
        foreach ($currentParameterInfo in $parameterInfo)
        {
            # Add values in Deployment > Properties > Parameter section
            if ($currentParameterInfo.ContainsKey('DeploymentValue'))
            {
                $deploymentHashtable['properties']['parameters'] += [Ordered]@{
                    $currentParameterInfo.ReferenceName = [Ordered]@{
                        value = $currentParameterInfo.DeploymentValue
                    }
                }
            }
            else
            {
                $deploymentHashtable['properties']['parameters'] += [Ordered]@{
                    $currentParameterInfo.ReferenceName = [Ordered]@{
                        value = "[parameters('$($currentParameterInfo.ReferenceName)')]"
                    }
                }
            }

            # Add Type to Deployment > Properties > Template > Parameters section
            $deploymentHashtable['properties']['template']['parameters'] += [Ordered]@{
                $currentParameterInfo.ReferenceName = [Ordered]@{
                    type = $currentParameterInfo.Type
                }
            }
        }
    }

    # Existence Condition section
    $existenceConditionList['allOf'].Add([Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/contentHash'
        equals = "$ContentHash"
    })
    $existenceConditionList['allOf'].Add([Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
        equals = 'Compliant'
    })

    $policyRuleHashtable['then']['details']['existenceCondition'] = $existenceConditionList

    # Deployment Section
    $policyRuleHashtable['then']['details']['deployment'] = $deploymentHashtable
    $policyRuleHashtable['then']['details']['deployment']['properties']['template']['resources'] += $guestConfigurationAssignmentHashtable
    $deployPolicyContentHashtable['properties']['policyRule'] = $policyRuleHashtable

    $deployPolicyContentHashtable += [Ordered]@{
        id   = "/providers/Microsoft.Authorization/policyDefinitions/$deployPolicyGuid"
        type = "Microsoft.Authorization/policyDefinitions"
        name = $deployPolicyGuid
    }

    $deployPolicyContent = ConvertTo-Json -InputObject $deployPolicyContentHashtable -Depth 100 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }
    $formattedDeployPolicyContent = Format-Json -Json $deployPolicyContent

    if (Test-Path -Path $filePath)
    {
        Write-Error -Message "A file at the policy destination path '$filePath' already exists. Please remove this file or specify a different destination path."
    }
    else
    {
        $null = New-Item -Path $filePath -ItemType 'File' -Value $formattedDeployPolicyContent
    }

    return $deployPolicyGuid
}
