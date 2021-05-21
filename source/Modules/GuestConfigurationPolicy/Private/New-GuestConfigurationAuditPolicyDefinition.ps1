<#
    .SYNOPSIS
        Creates a new audit policy definition for a guest configuration policy.
#>
function New-GuestConfigurationAuditPolicyDefinition
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
        $ReferenceId,

        [Parameter()]
        [Hashtable[]]
        $ParameterInfo,

        [Parameter()]
        [String]
        $ContentUri,

        [Parameter()]
        [String]
        $ContentHash,

        [AssignmentType]
        $AssignmentType,

        [Parameter()]
        [bool]
        $UseCertificateValidation = $false,

        [Parameter()]
        [String]
        $Category = 'Guest Configuration',

        [Parameter()]
        [String]
        $Guid,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter()]
        [Hashtable[]]
        $Tag
    )

    $filePath = Join-Path -Path $FolderPath -ChildPath $FileName
    Write-Verbose -Message "Creating Guest Configuration Audit Policy Definition to '$filePath'."

    if (-not [String]::IsNullOrEmpty($Guid))
    {
        $auditPolicyGuid = $Guid
    }
    else
    {
        $auditPolicyGuid = [Guid]::NewGuid()
    }

    $ParameterMapping = @{ }
    $ParameterDefinitions = @{ }
    $auditPolicyContentHashtable = [Ordered]@{ }

    if ($null -ne $ParameterInfo)
    {
        $ParameterMapping = Get-ParameterMappingForAINE $ParameterInfo
        $ParameterDefinitions = Get-ParameterDefinitionsAINE $ParameterInfo
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

    $auditPolicyContentHashtable = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType  = 'Custom'
            mode        = 'All'
            description = $Description
            metadata    = [Ordered]@{
                category           = $Category
                guestConfiguration = [Ordered]@{
                    name                   = $ConfigurationName
                    version                = $ConfigurationVersion
                    contentType            = "Custom"
                    contentUri             = $ContentUri
                    contentHash            = $ContentHash
                    configurationParameter = $ParameterMapping
                }
            }
            parameters  = $ParameterDefinitions

        }
        id         = "/providers/Microsoft.Authorization/policyDefinitions/$auditPolicyGuid"
        name       = $auditPolicyGuid
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
            effect  = 'auditIfNotExists'
            details = [Ordered]@{
                type = 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
                name = $ConfigurationName
            }
        }
    }

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
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftWindowsServer'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageSKU"
                                notLike = '2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftSQLServer'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageOffer"
                                notLike = 'SQL2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{
                                field  = "Microsoft.Compute/imageOffer"
                                equals = 'dsvm-windows'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
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
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'batch'
                            },
                            [Ordered]@{
                                field  = "Microsoft.Compute/imageOffer"
                                equals = 'rendering-windows2016'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'cis-windows-server-201*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'pivotal'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'bosh-windows-server*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'cloud-infrastructure-services'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'ad*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                anyOf = @(
                                    [Ordered]@{
                                        field  = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                        like  = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{
                                anyOf = @(
                                    [Ordered]@{
                                        field  = "Microsoft.Compute/imageSKU"
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{
                                                field   = "Microsoft.Compute/imageSKU"
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field   = "Microsoft.Compute/imageOffer"
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
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "windows*"
            }
        )
    }
    elseif ($Platform -ieq 'Linux')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
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
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'OpenLogic'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'CentOS*'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'Oracle'
                            },
                            [Ordered]@{
                                field  = "Microsoft.Compute/imageOffer"
                                equals = 'Oracle-Linux'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageSKU"
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

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "linux*"
            }
        )
    }
    else
    {
        throw "The specified platform '$Platform' is not currently supported by this script."
    }

    # if there is atleast one tag
    if ($PSBoundParameters.ContainsKey('Tag') -AND $null -ne $Tag)
    {
        # capture existing 'anyOf' section
        $anyOf = $policyRuleHashtable['if']
        # replace with new 'allOf' at top order
        $policyRuleHashtable['if'] = [Ordered]@{
            allOf = @(
            )
        }
        # add tags section under new 'allOf'
        $policyRuleHashtable['if']['allOf'] += [Ordered]@{
            allOf = @(
            )
        }
        # re-insert 'anyOf' under new 'allOf' after tags 'allOf'
        $policyRuleHashtable['if']['allOf'] += $anyOf
        # add each tag individually to tags 'allOf'
        for ($i = 0; $i -lt $Tag.count; $i++)
        {
            # if there is atleast one tag
            if (-not [string]::IsNullOrEmpty($Tag[$i].Keys))
            {
                $policyRuleHashtable['if']['allOf'][0]['allOf'] += [Ordered]@{
                    field  = "tags.$($Tag[$i].Keys)"
                    equals = "$($Tag[$i].Values)"
                }
            }
        }
    }

    $existenceConditionList = [Ordered]@{
        allOf = [System.Collections.ArrayList]@()
    }

    $existenceConditionList['allOf'].Add([Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
        equals = 'Compliant'
    })

    if ($null -ne $ParameterInfo)
    {
        $parametersExistenceCondition = Get-GuestConfigurationAssignmentParametersExistenceConditionSection -ParameterInfo $ParameterInfo
        $existenceConditionList['allOf'].Add($parametersExistenceCondition)
    }

    $policyRuleHashtable['then']['details']['existenceCondition'] = $existenceConditionList

    $auditPolicyContentHashtable['properties']['policyRule'] = $policyRuleHashtable

    $auditPolicyContent = ConvertTo-Json -InputObject $auditPolicyContentHashtable -Depth 100 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }
    $formattedAuditPolicyContent = Format-Json -Json $auditPolicyContent

    if (Test-Path -Path $filePath)
    {
        Write-Error -Message "A file at the policy destination path '$filePath' already exists. Please remove this file or specify a different destination path."
    }
    else
    {
        $null = New-Item -Path $filePath -ItemType 'File' -Value $formattedAuditPolicyContent
    }

    return $auditPolicyGuid
}
