Configuration AzureOSBaseline 
{
    Import-DscResource -ModuleName GuestConfiguration
    if( $ConfigurationData.NonNodeData."F6C7CDD1_B504_4E9E_A272_1AA2F441DAA3".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit MPSSVC Rule-Level Policy Change"
        {
            RuleId = "{F6C7CDD1-B504-4E9E-A272-1AA2F441DAA3}"
            AzId = "AZ-WIN-00111"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit MPSSVC Rule-Level Policy Change"
            Severity = "Critical"
            Subcategory = "{0CCE9232-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."F6C7CDD1_B504_4E9E_A272_1AA2F441DAA3".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ACD96120_83A4_44A9_9E62_127012287E49".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Other Object Access Events"
        {
            RuleId = "{ACD96120-83A4-44A9-9E62-127012287E49}"
            AzId = "AZ-WIN-00113"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Other Object Access Events"
            Severity = "Critical"
            Subcategory = "{0CCE9227-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."ACD96120_83A4_44A9_9E62_127012287E49".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."103DE8E8_643E_4B0E_B4A4_A85830239A53".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Account Lockout"
        {
            RuleId = "{103DE8E8-643E-4B0E-B4A4-A85830239A53}"
            AzId = "CCE-37133-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Account Lockout"
            Severity = "Critical"
            Subcategory = "{0CCE9217-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."103DE8E8_643E_4B0E_B4A4_A85830239A53".ExpectedValue
            RemediateValue = "Failure"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."42DB0BEC_E47F_49F6_A0AF_59798F0FEEFE".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Authentication Policy Change"
        {
            RuleId = "{42DB0BEC-E47F-49F6-A0AF-59798F0FEEFE}"
            AzId = "CCE-38327-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Authentication Policy Change"
            Severity = "Critical"
            Subcategory = "{0CCE9230-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."42DB0BEC_E47F_49F6_A0AF_59798F0FEEFE".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4f8fd732_facf_4184_a29c_61fdd40db89d".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Credential Validation"
        {
            RuleId = "{4f8fd732-facf-4184-a29c-61fdd40db89d}"
            AzId = "CCE-37741-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Credential Validation"
            Severity = "Critical"
            Subcategory = "{0CCE923F-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."4f8fd732_facf_4184_a29c_61fdd40db89d".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."BABDA20B_1BC0_4204_9745_0CD584DCBB2B".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Group Membership"
        {
            RuleId = "{BABDA20B-1BC0-4204-9745-0CD584DCBB2B}"
            AzId = "AZ-WIN-00026"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Group Membership"
            Severity = "Critical"
            Subcategory = "{0CCE9249-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."BABDA20B_1BC0_4204_9745_0CD584DCBB2B".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e1174067_f117_4d7f_9584_fd93eedd566f".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Logoff"
        {
            RuleId = "{e1174067-f117-4d7f-9584-fd93eedd566f}"
            AzId = "CCE-38237-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Logoff"
            Severity = "Critical"
            Subcategory = "{0CCE9216-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."e1174067_f117_4d7f_9584_fd93eedd566f".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5b5ac074_b108_4acf_aeca_5baabc276538".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Logon"
        {
            RuleId = "{5b5ac074-b108-4acf-aeca-5baabc276538}"
            AzId = "CCE-38036-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Logon"
            Severity = "Critical"
            Subcategory = "{0CCE9215-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."5b5ac074_b108_4acf_aeca_5baabc276538".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ACC56724_35E6_4EAD_A87F_E12B98B396D5".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Other Account Management Events"
        {
            RuleId = "{ACC56724-35E6-4EAD-A87F-E12B98B396D5}"
            AzId = "CCE-37855-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Other Account Management Events"
            Severity = "Critical"
            Subcategory = "{0CCE923A-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."ACC56724_35E6_4EAD_A87F_E12B98B396D5".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $false
        }
    }
    if( $ConfigurationData.NonNodeData."FA518C7B_96BC_45E6_8FEE_2C99186A010D".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Other Logon/Logoff Events"
        {
            RuleId = "{FA518C7B-96BC-45E6-8FEE-2C99186A010D}"
            AzId = "CCE-36322-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Other Logon/Logoff Events"
            Severity = "Critical"
            Subcategory = "{0CCE921C-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."FA518C7B_96BC_45E6_8FEE_2C99186A010D".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5046d960_670d_4fef_973a_cf242a97147e".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit PNP Activity"
        {
            RuleId = "{5046d960-670d-4fef-973a-cf242a97147e}"
            AzId = "AZ-WIN-00182"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit PNP Activity"
            Severity = "Critical"
            Subcategory = "{0CCE9248-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."5046d960_670d_4fef_973a_cf242a97147e".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."D5DB6E13_EEF5_45AC_A8F3_18A0B1FCD8F9".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Policy Change"
        {
            RuleId = "{D5DB6E13-EEF5-45AC-A8F3-18A0B1FCD8F9}"
            AzId = "CCE-38028-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Policy Change"
            Severity = "Critical"
            Subcategory = "{0CCE922F-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."D5DB6E13_EEF5_45AC_A8F3_18A0B1FCD8F9".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."6b3dc518_61f4_4a47_920c_0411674596a0".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Process Creation"
        {
            RuleId = "{6b3dc518-61f4-4a47-920c-0411674596a0}"
            AzId = "CCE-36059-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Process Creation"
            Severity = "Critical"
            Subcategory = "{0CCE922B-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."6b3dc518_61f4_4a47_920c_0411674596a0".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b88b1d85_5f3c_4235_91ab_6d8b5e767311".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Removable Storage"
        {
            RuleId = "{b88b1d85-5f3c-4235-91ab-6d8b5e767311}"
            AzId = "CCE-37617-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Removable Storage"
            Severity = "Critical"
            Subcategory = "{0CCE9245-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."b88b1d85_5f3c_4235_91ab_6d8b5e767311".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."515db7da_c244_445b_b093_cf3c09ad8970".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Security Group Management"
        {
            RuleId = "{515db7da-c244-445b-b093-cf3c09ad8970}"
            AzId = "CCE-38034-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Security Group Management"
            Severity = "Critical"
            Subcategory = "{0CCE9237-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."515db7da_c244_445b_b093_cf3c09ad8970".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."761F9127_3D19_44AF_87A2_09B10B21ECF2".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Security State Change"
        {
            RuleId = "{761F9127-3D19-44AF-87A2-09B10B21ECF2}"
            AzId = "CCE-38114-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Security State Change"
            Severity = "Critical"
            Subcategory = "{0CCE9210-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."761F9127_3D19_44AF_87A2_09B10B21ECF2".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8042F614_F21E_4DCA_BA3F_C8B25523B6B2".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Security System Extension"
        {
            RuleId = "{8042F614-F21E-4DCA-BA3F-C8B25523B6B2}"
            AzId = "CCE-36144-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Security System Extension"
            Severity = "Critical"
            Subcategory = "{0CCE9211-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."8042F614_F21E_4DCA_BA3F_C8B25523B6B2".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."AA426F30_E6FF_4C6A_9D59_2EF82A504157".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Sensitive Privilege Use"
        {
            RuleId = "{AA426F30-E6FF-4C6A-9D59-2EF82A504157}"
            AzId = "CCE-36267-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Sensitive Privilege Use"
            Severity = "Critical"
            Subcategory = "{0CCE9228-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."AA426F30_E6FF_4C6A_9D59_2EF82A504157".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8ee0776b_3b84_47bf_9594_e14e29fcc8ff".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Special Logon"
        {
            RuleId = "{8ee0776b-3b84-47bf-9594-e14e29fcc8ff}"
            AzId = "CCE-36266-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Special Logon"
            Severity = "Critical"
            Subcategory = "{0CCE921B-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."8ee0776b_3b84_47bf_9594_e14e29fcc8ff".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."D5056B06_4651_4698_B5D2_83E6B092E471".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit System Integrity"
        {
            RuleId = "{D5056B06-4651-4698-B5D2-83E6B092E471}"
            AzId = "CCE-37132-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit System Integrity"
            Severity = "Critical"
            Subcategory = "{0CCE9212-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."D5056B06_4651_4698_B5D2_83E6B092E471".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7e4d9fe1_eb3f_49ac_bb5b_d417df7e6d6c".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit User Account Management"
        {
            RuleId = "{7e4d9fe1-eb3f-49ac-bb5b-d417df7e6d6c}"
            AzId = "CCE-37856-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit User Account Management"
            Severity = "Critical"
            Subcategory = "{0CCE9235-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."7e4d9fe1_eb3f_49ac_bb5b_d417df7e6d6c".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."116B0718_B9FB_4B6F_855D_05C6CA97369E".Enabled -eq $true ) {
        ASM_Registry "Network access: Remotely accessible registry paths"
        {
            RuleId = "{116B0718-B9FB-4B6F-855D-05C6CA97369E}"
            AzId = "CCE-37194-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Remotely accessible registry paths"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths"
            Value = "Machine"
            Type = "REG_MULTI_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."116B0718_B9FB_4B6F_855D_05C6CA97369E".ExpectedValue
            RemediateValue = "System\CurrentControlSet\Control\ProductOptions|#|System\CurrentControlSet\Control\Server Applications|#|Software\Microsoft\Windows NT\CurrentVersion"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."E261CE65_922A_4573_B2F4_EAF7633CD97C".Enabled -eq $true ) {
        ASM_Registry "Network access: Remotely accessible registry paths and sub-paths"
        {
            RuleId = "{E261CE65-922A-4573-B2F4-EAF7633CD97C}"
            AzId = "CCE-36347-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Remotely accessible registry paths and sub-paths"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths"
            Value = "Machine"
            Type = "REG_MULTI_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."E261CE65_922A_4573_B2F4_EAF7633CD97C".ExpectedValue
            RemediateValue = "System\CurrentControlSet\Control\Print\Printers|#|System\CurrentControlSet\Services\Eventlog|#|Software\Microsoft\OLAP Server|#|Software\Microsoft\Windows NT\CurrentVersion\Print|#|Software\Microsoft\Windows NT\CurrentVersion\Windows|#|System\CurrentControlSet\Control\ContentIndex|#|System\CurrentControlSet\Control\Terminal Server|#|System\CurrentControlSet\Control\Terminal Server\UserConfig|#|System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration|#|Software\Microsoft\Windows NT\CurrentVersion\Perflib|#|System\CurrentControlSet\Services\SysmonLog"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."EA1BBC42_7C24_4CED_8EA7_7B16FF4763B5".Enabled -eq $true ) {
        ASM_Registry "Detect change from default RDP port"
        {
            RuleId = "{EA1BBC42-7C24-4CED-8EA7-7B16FF4763B5}"
            AzId = "AZ-WIN-00156"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Detect change from default RDP port"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            Value = "PortNumber"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."EA1BBC42_7C24_4CED_8EA7_7B16FF4763B5".ExpectedValue
            RemediateValue = "3389"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."f3117bf3_e54a_496a_9976_74b1caca3105".Enabled -eq $true ) {
        ASM_Registry "Configure local setting override for reporting to Microsoft MAPS"
        {
            RuleId = "{f3117bf3-e54a-496a-9976-74b1caca3105}"
            AzId = "AZ-WIN-00173"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Configure local setting override for reporting to Microsoft MAPS"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet"
            Value = "LocalSettingOverrideSpynetReporting"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."f3117bf3_e54a_496a_9976_74b1caca3105".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a002b800_92a4_45cb_bbee_76c91739ddff".Enabled -eq $true ) {
        ASM_Registry "Disable SMB v1 server"
        {
            RuleId = "{a002b800-92a4-45cb-bbee-76c91739ddff}"
            AzId = "AZ-WIN-00175"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Disable SMB v1 server"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
            Value = "SMB1"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."a002b800_92a4_45cb_bbee_76c91739ddff".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."843079e3_4803_4b52_8b36_c554c4623204".Enabled -eq $true ) {
        ASM_Registry "Disable Windows Search Service"
        {
            RuleId = "{843079e3-4803-4b52-8b36-c554c4623204}"
            AzId = "AZ-WIN-00176"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Disable Windows Search Service"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Services\Wsearch"
            Value = "Start"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."843079e3_4803_4b52_8b36_c554c4623204".ExpectedValue
            RemediateValue = "4"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4054c4db_7927_4344_87b4_156c1d681598".Enabled -eq $true ) {
        ASM_Registry "Scan removable drives"
        {
            RuleId = "{4054c4db-7927-4344-87b4-156c1d681598}"
            AzId = "AZ-WIN-00177"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Scan removable drives"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\Scan"
            Value = "DisableRemovableDriveScanning"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4054c4db_7927_4344_87b4_156c1d681598".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."31F2F70A_685F_4E0A_96BA_CB0C0E83768B".Enabled -eq $true ) {
        ASM_Registry "Send file samples when further analysis is required"
        {
            RuleId = "{31F2F70A-685F-4E0A-96BA-CB0C0E83768B}"
            AzId = "AZ-WIN-00126"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Send file samples when further analysis is required"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet"
            Value = "SubmitSamplesConsent"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."31F2F70A_685F_4E0A_96BA_CB0C0E83768B".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a917e66c_e3e4_4a7b_8f72_e8163994aabc".Enabled -eq $true ) {
        ASM_Registry "Turn on behavior monitoring"
        {
            RuleId = "{a917e66c-e3e4-4a7b-8f72-e8163994aabc}"
            AzId = "AZ-WIN-00178"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn on behavior monitoring"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
            Value = "DisableBehaviorMonitoring"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."a917e66c_e3e4_4a7b_8f72_e8163994aabc".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3715ec67_6cd4_49c0_8c82_27001a0e332b".Enabled -eq $true ) {
        ASM_Registry "Accounts: Limit local account use of blank passwords to console logon only"
        {
            RuleId = "{3715ec67-6cd4-49c0-8c82-27001a0e332b}"
            AzId = "CCE-37615-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Accounts: Limit local account use of blank passwords to console logon only"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "LimitBlankPasswordUse"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3715ec67_6cd4_49c0_8c82_27001a0e332b".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."abb1bcab_f4da_4a9c_be63_7564a0bca7b8".Enabled -eq $true ) {
        ASM_Registry "Allow Basic authentication"
        {
            RuleId = "{abb1bcab-f4da-4a9c-be63-7564a0bca7b8}"
            AzId = "CCE-36254-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow Basic authentication"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
            Value = "AllowBasic"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."abb1bcab_f4da_4a9c_be63_7564a0bca7b8".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."484c747f_1418_4c27_a944_c3b1e1690b33".Enabled -eq $true ) {
        ASM_Registry "Allow indexing of encrypted files"
        {
            RuleId = "{484c747f-1418-4c27-a944-c3b1e1690b33}"
            AzId = "CCE-38277-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow indexing of encrypted files"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            Value = "AllowIndexingEncryptedStoresOrItems"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."484c747f_1418_4c27_a944_c3b1e1690b33".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."11ca2201_2673_4f04_bad3_3265e1a53a5b".Enabled -eq $true ) {
        ASM_Registry "Allow Input Personalization"
        {
            RuleId = "{11ca2201-2673-4f04-bad3-3265e1a53a5b}"
            AzId = "AZ-WIN-00168"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow Input Personalization"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\InputPersonalization"
            Value = "AllowInputPersonalization"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."11ca2201_2673_4f04_bad3_3265e1a53a5b".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."DE7AF76F_E469_4A4E_94FD_99F0CCCD54B6".Enabled -eq $true ) {
        ASM_Registry "Allow Microsoft accounts to be optional"
        {
            RuleId = "{DE7AF76F-E469-4A4E-94FD-99F0CCCD54B6}"
            AzId = "CCE-38354-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow Microsoft accounts to be optional"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "MSAOptional"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."DE7AF76F_E469_4A4E_94FD_99F0CCCD54B6".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."14afe28a_6199_49ff_9789_dabb89ed714e".Enabled -eq $true ) {
        ASM_Registry "Allow Diagnostic Data"
        {
            RuleId = "{14afe28a-6199-49ff-9789-dabb89ed714e}"
            AzId = "AZ-WIN-00169"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow Diagnostic Data"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            Value = "AllowTelemetry"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."14afe28a_6199_49ff_9789_dabb89ed714e".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2785f384_9901_4c9d_8dca_8ff2b5068fde".Enabled -eq $true ) {
        ASM_Registry "Allow unencrypted traffic"
        {
            RuleId = "{2785f384-9901-4c9d-8dca-8ff2b5068fde}"
            AzId = "CCE-38223-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow unencrypted traffic"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
            Value = "AllowUnencryptedTraffic"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."2785f384_9901_4c9d_8dca_8ff2b5068fde".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5d42c180_4350_49ec_9bb6_e51e1258022c".Enabled -eq $true ) {
        ASM_Registry "Allow user control over installs"
        {
            RuleId = "{5d42c180-4350-49ec-9bb6-e51e1258022c}"
            AzId = "CCE-36400-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow user control over installs"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Installer"
            Value = "EnableUserControl"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."5d42c180_4350_49ec_9bb6_e51e1258022c".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2eda113a_0fb7_446c_856a_83e010d36671".Enabled -eq $true ) {
        ASM_Registry "Always install with elevated privileges"
        {
            RuleId = "{2eda113a-0fb7-446c-856a-83e010d36671}"
            AzId = "CCE-37490-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Always install with elevated privileges"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Installer"
            Value = "AlwaysInstallElevated"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."2eda113a_0fb7_446c_856a_83e010d36671".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."D9794F70_E03C_40E5_A812_D2878C0EB6D5".Enabled -eq $true ) {
        ASM_Registry "Always prompt for password upon connection"
        {
            RuleId = "{D9794F70-E03C-40E5-A812-D2878C0EB6D5}"
            AzId = "CCE-37929-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Always prompt for password upon connection"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "fPromptForPassword"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."D9794F70_E03C_40E5_A812_D2878C0EB6D5".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."DEC8589F_4E06_4A11_9C6C_2B1464F07075".Enabled -eq $true ) {
        ASM_Registry "Application: Control Event Log behavior when the log file reaches its maximum size"
        {
            RuleId = "{DEC8589F-4E06-4A11-9C6C-2B1464F07075}"
            AzId = "CCE-37775-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Application: Control Event Log behavior when the log file reaches its maximum size"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
            Value = "Retention"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."DEC8589F_4E06_4A11_9C6C_2B1464F07075".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."E7E377D1_D6E0_4ACC_A073_75B3243A646E".Enabled -eq $true ) {
        ASM_Registry "Application: Specify the maximum log file size (KB)"
        {
            RuleId = "{E7E377D1-D6E0-4ACC-A073-75B3243A646E}"
            AzId = "CCE-37948-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Application: Specify the maximum log file size (KB)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
            Value = "MaxSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."E7E377D1_D6E0_4ACC_A073_75B3243A646E".ExpectedValue
            RemediateValue = "32768"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."0179CC92_EF40_40B9_9AAA_41AAF3F9F355".Enabled -eq $true ) {
        ASM_Registry "Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings"
        {
            RuleId = "{0179CC92-EF40-40B9-9AAA-41AAF3F9F355}"
            AzId = "CCE-37850-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "SCENoApplyLegacyAuditPolicy"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."0179CC92_EF40_40B9_9AAA_41AAF3F9F355".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."6907b165_e70a_4b88_b624_3e32a15c93b1".Enabled -eq $true ) {
        ASM_Registry "Audit: Shut down system immediately if unable to log security audits"
        {
            RuleId = "{6907b165-e70a-4b88-b624-3e32a15c93b1}"
            AzId = "CCE-35907-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit: Shut down system immediately if unable to log security audits"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "CrashOnAuditFail"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."6907b165_e70a_4b88_b624_3e32a15c93b1".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."CAC31D47_C8EA_440F_AF85_7697F483B21E".Enabled -eq $true ) {
        ASM_Registry "Block user from showing account details on sign-in"
        {
            RuleId = "{CAC31D47-C8EA-440F-AF85-7697F483B21E}"
            AzId = "AZ-WIN-00138"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Block user from showing account details on sign-in"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows\System"
            Value = "BlockUserFromShowingAccountDetailsOnSignin"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."CAC31D47_C8EA_440F_AF85_7697F483B21E".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3C336CEE_A852_4673_82E9_C7E130AF7BC7".Enabled -eq $true ) {
        ASM_Registry "Boot-Start Driver Initialization Policy"
        {
            RuleId = "{3C336CEE-A852-4673-82E9-C7E130AF7BC7}"
            AzId = "CCE-37912-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Boot-Start Driver Initialization Policy"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Policies\EarlyLaunch"
            Value = "DriverLoadPolicy"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3C336CEE_A852_4673_82E9_C7E130AF7BC7".ExpectedValue
            RemediateValue = "3"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7450d70c_391d_4932_be4a_3f3bfecc0eb5".Enabled -eq $true ) {
        ASM_Registry "Configure Offer Remote Assistance"
        {
            RuleId = "{7450d70c-391d-4932-be4a-3f3bfecc0eb5}"
            AzId = "CCE-36388-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Configure Offer Remote Assistance"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "fAllowUnsolicited"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."7450d70c_391d_4932_be4a_3f3bfecc0eb5".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b17eabc0_5d73_4861_acc8_d5b97bc53f12".Enabled -eq $true ) {
        ASM_Registry "Configure Solicited Remote Assistance"
        {
            RuleId = "{b17eabc0-5d73-4861-acc8-d5b97bc53f12}"
            AzId = "CCE-37281-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Configure Solicited Remote Assistance"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "fAllowToGetHelp"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b17eabc0_5d73_4861_acc8_d5b97bc53f12".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1E3AE441_8BD6_4736_94AA_AC56A430131C".Enabled -eq $true ) {
        ASM_Registry "Configure Windows SmartScreen"
        {
            RuleId = "{1E3AE441-8BD6-4736-94AA-AC56A430131C}"
            AzId = "CCE-35859-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Configure Windows SmartScreen"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "EnableSmartScreen"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."1E3AE441_8BD6_4736_94AA_AC56A430131C".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e588914e_fbb8_4926_9ccf_8ea781b07610".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Continue experiences on this device' is set to 'Disabled'"
        {
            RuleId = "{e588914e-fbb8-4926-9ccf-8ea781b07610}"
            AzId = "AZ-WIN-00170"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Continue experiences on this device' is set to 'Disabled'"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "EnableCdp"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."e588914e_fbb8_4926_9ccf_8ea781b07610".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."01F87552_0D92_477A_91F6_1BEB5B0C8B0E".Enabled -eq $true ) {
        ASM_Registry "Devices: Allowed to format and eject removable media"
        {
            RuleId = "{01F87552-0D92-477A-91F6-1BEB5B0C8B0E}"
            AzId = "CCE-37701-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Devices: Allowed to format and eject removable media"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
            Value = "AllocateDASD"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."01F87552_0D92_477A_91F6_1BEB5B0C8B0E".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5502808d_7049_4378_b9f7_038b70777483".Enabled -eq $true ) {
        ASM_Registry "Devices: Prevent users from installing printer drivers"
        {
            RuleId = "{5502808d-7049-4378-b9f7-038b70777483}"
            AzId = "CCE-37942-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Devices: Prevent users from installing printer drivers"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers"
            Value = "AddPrinterDrivers"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."5502808d_7049_4378_b9f7_038b70777483".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."420CF8AF_038E_4D06_89A4_AA8BFAEC0191".Enabled -eq $true ) {
        ASM_Registry "Disallow Autoplay for non-volume devices"
        {
            RuleId = "{420CF8AF-038E-4D06-89A4-AA8BFAEC0191}"
            AzId = "CCE-37636-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Disallow Autoplay for non-volume devices"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Explorer"
            Value = "NoAutoplayfornonVolume"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."420CF8AF_038E_4D06_89A4_AA8BFAEC0191".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."34edb7eb_697c_4be9_8830_5aa5b031372e".Enabled -eq $true ) {
        ASM_Registry "Disallow Digest authentication"
        {
            RuleId = "{34edb7eb-697c-4be9-8830-5aa5b031372e}"
            AzId = "CCE-38318-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Disallow Digest authentication"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
            Value = "AllowDigest"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."34edb7eb_697c_4be9_8830_5aa5b031372e".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5FC2DC21_A630_45EE_A62D_5E3D87A45A84".Enabled -eq $true ) {
        ASM_Registry "Disallow WinRM from storing RunAs credentials"
        {
            RuleId = "{5FC2DC21-A630-45EE-A62D-5E3D87A45A84}"
            AzId = "CCE-36000-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Disallow WinRM from storing RunAs credentials"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
            Value = "DisableRunAs"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."5FC2DC21_A630_45EE_A62D_5E3D87A45A84".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."0979B47F_FBBF_46AD_8DEF_768256FA012A".Enabled -eq $true ) {
        ASM_Registry "Do not allow passwords to be saved"
        {
            RuleId = "{0979B47F-FBBF-46AD-8DEF-768256FA012A}"
            AzId = "CCE-36223-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not allow passwords to be saved"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "DisablePasswordSaving"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."0979B47F_FBBF_46AD_8DEF_768256FA012A".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."28B43132_0B7F_4839_9116_8C33AC9EE424".Enabled -eq $true ) {
        ASM_Registry "Do not delete temp folders upon exit"
        {
            RuleId = "{28B43132-0B7F-4839-9116-8C33AC9EE424}"
            AzId = "CCE-37946-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not delete temp folders upon exit"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "DeleteTempDirsOnExit"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."28B43132_0B7F_4839_9116_8C33AC9EE424".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1CE9D867_2A1F_4E0D_8EE9_BC3606F9302C".Enabled -eq $true ) {
        ASM_Registry "Do not display network selection UI"
        {
            RuleId = "{1CE9D867-2A1F-4E0D-8EE9-BC3606F9302C}"
            AzId = "CCE-38353-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not display network selection UI"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "DontDisplayNetworkSelectionUI"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."1CE9D867_2A1F_4E0D_8EE9_BC3606F9302C".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."BE3A95AF_EDC4_4252_A1C0_6C74F3B5B8A7".Enabled -eq $true ) {
        ASM_Registry "Do not display the password reveal button"
        {
            RuleId = "{BE3A95AF-EDC4-4252-A1C0-6C74F3B5B8A7}"
            AzId = "CCE-37534-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not display the password reveal button"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\CredUI"
            Value = "DisablePasswordReveal"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."BE3A95AF_EDC4_4252_A1C0_6C74F3B5B8A7".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."596D3922_71A7_49CE_B34B_1F5E63FF03DA".Enabled -eq $true ) {
        ASM_Registry "Do not show feedback notifications"
        {
            RuleId = "{596D3922-71A7-49CE-B34B-1F5E63FF03DA}"
            AzId = "AZ-WIN-00140"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not show feedback notifications"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            Value = "DoNotShowFeedbackNotifications"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."596D3922_71A7_49CE_B34B_1F5E63FF03DA".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."832730A2_CC1F_4F77_BB8C_6315D210666F".Enabled -eq $true ) {
        ASM_Registry "Do not use temporary folders per session"
        {
            RuleId = "{832730A2-CC1F-4F77-BB8C-6315D210666F}"
            AzId = "CCE-38180-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not use temporary folders per session"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "PerSessionTempDir"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."832730A2_CC1F_4F77_BB8C_6315D210666F".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."09ed81b2_8dba_4009_84f9_dcfd6009ed0d".Enabled -eq $true ) {
        ASM_Registry "Enable insecure guest logons"
        {
            RuleId = "{09ed81b2-8dba-4009-84f9-dcfd6009ed0d}"
            AzId = "AZ-WIN-00171"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable insecure guest logons"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
            Value = "AllowInsecureGuestAuth"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."09ed81b2_8dba_4009_84f9_dcfd6009ed0d".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7983C8B6_CECA_4475_B58C_5B1D7745CDE3".Enabled -eq $true ) {
        ASM_Registry "Enable RPC Endpoint Mapper Client Authentication"
        {
            RuleId = "{7983C8B6-CECA-4475-B58C-5B1D7745CDE3}"
            AzId = "CCE-37346-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable RPC Endpoint Mapper Client Authentication"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Rpc"
            Value = "EnableAuthEpResolution"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."7983C8B6_CECA_4475_B58C_5B1D7745CDE3".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3270E2D2_C01D_49FE_BAF7_950FB5BBE642".Enabled -eq $true ) {
        ASM_Registry "Enable Windows NTP Client"
        {
            RuleId = "{3270E2D2-C01D-49FE-BAF7-950FB5BBE642}"
            AzId = "CCE-37843-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable Windows NTP Client"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient"
            Value = "Enabled"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3270E2D2_C01D_49FE_BAF7_950FB5BBE642".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e6eab28a_1dc8_4fb5_b88b_4e10f239e67c".Enabled -eq $true ) {
        ASM_Registry "Enumerate administrator accounts on elevation"
        {
            RuleId = "{e6eab28a-1dc8-4fb5-b88b-4e10f239e67c}"
            AzId = "CCE-36512-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enumerate administrator accounts on elevation"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI"
            Value = "EnumerateAdministrators"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."e6eab28a_1dc8_4fb5_b88b_4e10f239e67c".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1648F727_644B_4454_A472_B1A803342E8A".Enabled -eq $true ) {
        ASM_Registry "Include command line in process creation events"
        {
            RuleId = "{1648F727-644B-4454-A472-B1A803342E8A}"
            AzId = "CCE-36925-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Include command line in process creation events"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
            Value = "ProcessCreationIncludeCmdLine_Enabled"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."1648F727_644B_4454_A472_B1A803342E8A".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."9e11215f_9b0b_4ca6_ad5b_d1a0c989af36".Enabled -eq $true ) {
        ASM_Registry "Interactive logon: Do not display last user name"
        {
            RuleId = "{9e11215f-9b0b-4ca6-ad5b-d1a0c989af36}"
            AzId = "CCE-36056-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Interactive logon: Do not display last user name"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "DontDisplayLastUserName"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."9e11215f_9b0b_4ca6_ad5b_d1a0c989af36".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c2e85522_5e4f_4295_8111_5b2ab815af32".Enabled -eq $true ) {
        ASM_Registry "Interactive logon: Do not require CTRL+ALT+DEL"
        {
            RuleId = "{c2e85522-5e4f-4295-8111-5b2ab815af32}"
            AzId = "CCE-37637-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Interactive logon: Do not require CTRL+ALT+DEL"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "DisableCAD"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."c2e85522_5e4f_4295_8111_5b2ab815af32".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."41a8be7d_69bd_48f4_ae77_9568cf7b15d1".Enabled -eq $true ) {
        ASM_Registry "Microsoft network client: Digitally sign communications (always)"
        {
            RuleId = "{41a8be7d-69bd-48f4-ae77-9568cf7b15d1}"
            AzId = "CCE-36325-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network client: Digitally sign communications (always)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
            Value = "RequireSecuritySignature"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."41a8be7d_69bd_48f4_ae77_9568cf7b15d1".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."342046f5_c7d3_46b7_96db_7e4be82542d3".Enabled -eq $true ) {
        ASM_Registry "Microsoft network client: Digitally sign communications (if server agrees)"
        {
            RuleId = "{342046f5-c7d3-46b7-96db-7e4be82542d3}"
            AzId = "CCE-36269-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network client: Digitally sign communications (if server agrees)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
            Value = "EnableSecuritySignature"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."342046f5_c7d3_46b7_96db_7e4be82542d3".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a14a2808_588b_4233_b342_9dc1cecf2b0a".Enabled -eq $true ) {
        ASM_Registry "Microsoft network client: Send unencrypted password to third-party SMB servers"
        {
            RuleId = "{a14a2808-588b-4233-b342-9dc1cecf2b0a}"
            AzId = "CCE-37863-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network client: Send unencrypted password to third-party SMB servers"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
            Value = "EnablePlainTextPassword"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."a14a2808_588b_4233_b342_9dc1cecf2b0a".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4383c5e5_ea15_4e94_a170_fd61b3fda9f1".Enabled -eq $true ) {
        ASM_Registry "Microsoft network server: Amount of idle time required before suspending session"
        {
            RuleId = "{4383c5e5-ea15-4e94-a170-fd61b3fda9f1}"
            AzId = "CCE-38046-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network server: Amount of idle time required before suspending session"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "AutoDisconnect"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4383c5e5_ea15_4e94_a170_fd61b3fda9f1".ExpectedValue
            RemediateValue = "15"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."032b5976_1c4b_4c68_bc5d_0c65e35306b2".Enabled -eq $true ) {
        ASM_Registry "Microsoft network server: Digitally sign communications (always)"
        {
            RuleId = "{032b5976-1c4b-4c68-bc5d-0c65e35306b2}"
            AzId = "CCE-37864-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network server: Digitally sign communications (always)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "RequireSecuritySignature"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."032b5976_1c4b_4c68_bc5d_0c65e35306b2".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b625a003_d015_436e_89fb_fb2dfe71ae0f".Enabled -eq $true ) {
        ASM_Registry "Microsoft network server: Digitally sign communications (if client agrees)"
        {
            RuleId = "{b625a003-d015-436e-89fb-fb2dfe71ae0f}"
            AzId = "CCE-35988-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network server: Digitally sign communications (if client agrees)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "EnableSecuritySignature"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b625a003_d015_436e_89fb_fb2dfe71ae0f".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."32899900_6b73_4cdd_906d_702e00bae698".Enabled -eq $true ) {
        ASM_Registry "Microsoft network server: Disconnect clients when logon hours expire"
        {
            RuleId = "{32899900-6b73-4cdd-906d-702e00bae698}"
            AzId = "CCE-37972-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network server: Disconnect clients when logon hours expire"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "EnableForcedLogoff"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."32899900_6b73_4cdd_906d_702e00bae698".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8191B0F8_0855_491F_9DED_7260DC79AF3E".Enabled -eq $true ) {
        ASM_Registry "Minimize the number of simultaneous connections to the Internet or a Windows Domain"
        {
            RuleId = "{8191B0F8-0855-491F-9DED-7260DC79AF3E}"
            AzId = "CCE-38338-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Minimize the number of simultaneous connections to the Internet or a Windows Domain"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy"
            Value = "fMinimizeConnections"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."8191B0F8_0855_491F_9DED_7260DC79AF3E".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."87822480_3af9_4cf1_b0d2_93ceb957b129".Enabled -eq $true ) {
        ASM_Registry "Network access: Do not allow anonymous enumeration of SAM accounts and shares"
        {
            RuleId = "{87822480-3af9-4cf1-b0d2-93ceb957b129}"
            AzId = "CCE-36077-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Do not allow anonymous enumeration of SAM accounts and shares"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "RestrictAnonymous"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."87822480_3af9_4cf1_b0d2_93ceb957b129".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."9503a7be_372f_4591_9dcd_f7de48b7f7e8".Enabled -eq $true ) {
        ASM_Registry "Network access: Do not allow anonymous enumeration of SAM accounts"
        {
            RuleId = "{9503a7be-372f-4591-9dcd-f7de48b7f7e8}"
            AzId = "CCE-36316-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Do not allow anonymous enumeration of SAM accounts"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "RestrictAnonymousSAM"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."9503a7be_372f_4591_9dcd_f7de48b7f7e8".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."f97fe90f_c009_4139_8562_9893e9c49b44".Enabled -eq $true ) {
        ASM_Registry "Network access: Let Everyone permissions apply to anonymous users"
        {
            RuleId = "{f97fe90f-c009-4139-8562-9893e9c49b44}"
            AzId = "CCE-36148-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Let Everyone permissions apply to anonymous users"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "EveryoneIncludesAnonymous"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."f97fe90f_c009_4139_8562_9893e9c49b44".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."f55109a7_2248_4c55_a7b0_bebdcb9530d5".Enabled -eq $true ) {
        ASM_Registry "Network access: Restrict anonymous access to Named Pipes and Shares"
        {
            RuleId = "{f55109a7-2248-4c55-a7b0-bebdcb9530d5}"
            AzId = "CCE-36021-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Restrict anonymous access to Named Pipes and Shares"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "RestrictNullSessAccess"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."f55109a7_2248_4c55_a7b0_bebdcb9530d5".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."E4C0C45F_6A72_4E66_B792_32A4EBF36F1C".Enabled -eq $true ) {
        ASM_Registry "Network access: Restrict clients allowed to make remote calls to SAM"
        {
            RuleId = "{E4C0C45F-6A72-4E66-B792-32A4EBF36F1C}"
            AzId = "AZ-WIN-00142"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Restrict clients allowed to make remote calls to SAM"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "RestrictRemoteSAM"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."E4C0C45F_6A72_4E66_B792_32A4EBF36F1C".ExpectedValue
            RemediateValue = "O:BAG:BAD:(A;;RC;;;BA)"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."EE6B9D20_8C62_4F14_8719_A425E09244ED".Enabled -eq $true ) {
        ASM_Registry "Network access: Shares that can be accessed anonymously"
        {
            RuleId = "{EE6B9D20-8C62-4F14-8719-A425E09244ED}"
            AzId = "CCE-38095-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Shares that can be accessed anonymously"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "NullSessionShares"
            Type = "REG_MULTI_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."EE6B9D20_8C62_4F14_8719_A425E09244ED".ExpectedValue
            RemediateValue = ""
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3e42b5fc_08b2_4a9a_ad80_dafe9033cbc3".Enabled -eq $true ) {
        ASM_Registry "Network access: Sharing and security model for local accounts"
        {
            RuleId = "{3e42b5fc-08b2-4a9a-ad80-dafe9033cbc3}"
            AzId = "CCE-37623-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Sharing and security model for local accounts"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "ForceGuest"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3e42b5fc_08b2_4a9a_ad80_dafe9033cbc3".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."E7D5034F_5652_4180_90C8_C49130ACB3C6".Enabled -eq $true ) {
        ASM_Registry "Network security: Allow Local System to use computer identity for NTLM"
        {
            RuleId = "{E7D5034F-5652-4180-90C8-C49130ACB3C6}"
            AzId = "CCE-38341-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: Allow Local System to use computer identity for NTLM"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "UseMachineId"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."E7D5034F_5652_4180_90C8_C49130ACB3C6".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."0b2803c7_33ac_4407_80f0_f09940bbe940".Enabled -eq $true ) {
        ASM_Registry "Network security: Allow LocalSystem NULL session fallback"
        {
            RuleId = "{0b2803c7-33ac-4407-80f0-f09940bbe940}"
            AzId = "CCE-37035-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: Allow LocalSystem NULL session fallback"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
            Value = "AllowNullSessionFallback"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."0b2803c7_33ac_4407_80f0_f09940bbe940".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8ad78d25_6140_4899_9565_e053ce7d9a66".Enabled -eq $true ) {
        ASM_Registry "Network Security: Allow PKU2U authentication requests to this computer to use online identities"
        {
            RuleId = "{8ad78d25-6140-4899-9565-e053ce7d9a66}"
            AzId = "CCE-38047-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network Security: Allow PKU2U authentication requests to this computer to use online identities"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa\pku2u"
            Value = "AllowOnlineID"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."8ad78d25_6140_4899_9565_e053ce7d9a66".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."979AE5A3_DBA6_47B1_9644_7E74ED6D7EAE".Enabled -eq $true ) {
        ASM_Registry "Network Security: Configure encryption types allowed for Kerberos"
        {
            RuleId = "{979AE5A3-DBA6-47B1-9644-7E74ED6D7EAE}"
            AzId = "CCE-37755-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network Security: Configure encryption types allowed for Kerberos"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
            Value = "SupportedEncryptionTypes"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."979AE5A3_DBA6_47B1_9644_7E74ED6D7EAE".ExpectedValue
            RemediateValue = "2147483640"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."9170cd13_5ab9_4c68_8904_a88756b36c6e".Enabled -eq $true ) {
        ASM_Registry "Network security: Do not store LAN Manager hash value on next password change"
        {
            RuleId = "{9170cd13-5ab9-4c68-8904-a88756b36c6e}"
            AzId = "CCE-36326-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: Do not store LAN Manager hash value on next password change"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "NoLMHash"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."9170cd13_5ab9_4c68_8904_a88756b36c6e".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."315CC7E3_7252_47CE_AF2F_9ABF243FAC16".Enabled -eq $true ) {
        ASM_Registry "Network security: LAN Manager authentication level"
        {
            RuleId = "{315CC7E3-7252-47CE-AF2F-9ABF243FAC16}"
            AzId = "CCE-36173-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: LAN Manager authentication level"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa"
            Value = "LmCompatibilityLevel"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."315CC7E3_7252_47CE_AF2F_9ABF243FAC16".ExpectedValue
            RemediateValue = "5"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4ff2ed85_48d7_4e38_bdb8_6c7df3286882".Enabled -eq $true ) {
        ASM_Registry "Network security: LDAP client signing requirements"
        {
            RuleId = "{4ff2ed85-48d7-4e38-bdb8-6c7df3286882}"
            AzId = "CCE-36858-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: LDAP client signing requirements"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LDAP"
            Value = "LDAPClientIntegrity"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4ff2ed85_48d7_4e38_bdb8_6c7df3286882".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2a074d39_eee4_4bfe_b1e7_4132c033a762".Enabled -eq $true ) {
        ASM_Registry "Network security: Minimum session security for NTLM SSP based (including secure RPC) clients"
        {
            RuleId = "{2a074d39-eee4-4bfe-b1e7-4132c033a762}"
            AzId = "CCE-37553-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: Minimum session security for NTLM SSP based (including secure RPC) clients"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
            Value = "NTLMMinClientSec"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."2a074d39_eee4_4bfe_b1e7_4132c033a762".ExpectedValue
            RemediateValue = "537395200"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."6ed9ad58_c9de_4a8b_9512_8fe5421ac8a7".Enabled -eq $true ) {
        ASM_Registry "Network security: Minimum session security for NTLM SSP based (including secure RPC) servers"
        {
            RuleId = "{6ed9ad58-c9de-4a8b-9512-8fe5421ac8a7}"
            AzId = "CCE-37835-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network security: Minimum session security for NTLM SSP based (including secure RPC) servers"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
            Value = "NTLMMinServerSec"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."6ed9ad58_c9de_4a8b_9512_8fe5421ac8a7".ExpectedValue
            RemediateValue = "537395200"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."21C5BCB7_432E_4EAA_A01A_0CDA8DB73E62".Enabled -eq $true ) {
        ASM_Registry "Prevent downloading of enclosures"
        {
            RuleId = "{21C5BCB7-432E-4EAA-A01A-0CDA8DB73E62}"
            AzId = "CCE-37126-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Prevent downloading of enclosures"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"
            Value = "DisableEnclosureDownload"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."21C5BCB7_432E_4EAA_A01A_0CDA8DB73E62".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."357272d2_2018_455e_935c_8777473661dd".Enabled -eq $true ) {
        ASM_Registry "Prohibit installation and configuration of Network Bridge on your DNS domain network"
        {
            RuleId = "{357272d2-2018-455e-935c-8777473661dd}"
            AzId = "CCE-38002-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Prohibit installation and configuration of Network Bridge on your DNS domain network"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Network Connections"
            Value = "NC_AllowNetBridge_NLA"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."357272d2_2018_455e_935c_8777473661dd".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4b2ea54f_7c16_4490_8687_cc52c3135b7e".Enabled -eq $true ) {
        ASM_Registry "Prohibit use of Internet Connection Sharing on your DNS domain network"
        {
            RuleId = "{4b2ea54f-7c16-4490-8687-cc52c3135b7e}"
            AzId = "AZ-WIN-00172"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Prohibit use of Internet Connection Sharing on your DNS domain network"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Network Connections"
            Value = "NC_ShowSharedAccessUI"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4b2ea54f_7c16_4490_8687_cc52c3135b7e".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."01D9A108_3379_4C5A_8236_1A724BCCCFF1".Enabled -eq $true ) {
        ASM_Registry "Require secure RPC communication"
        {
            RuleId = "{01D9A108-3379-4C5A-8236-1A724BCCCFF1}"
            AzId = "CCE-37567-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Require secure RPC communication"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "fEncryptRPCTraffic"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."01D9A108_3379_4C5A_8236_1A724BCCCFF1".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1B1DCDBF_D949_44DA_B942_0FC2EB225985".Enabled -eq $true ) {
        ASM_Registry "Security: Control Event Log behavior when the log file reaches its maximum size"
        {
            RuleId = "{1B1DCDBF-D949-44DA-B942-0FC2EB225985}"
            AzId = "CCE-37145-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Security: Control Event Log behavior when the log file reaches its maximum size"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
            Value = "Retention"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."1B1DCDBF_D949_44DA_B942_0FC2EB225985".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."C139DB2E_8DEA_418E_BF7C_372EC0278E31".Enabled -eq $true ) {
        ASM_Registry "Security: Specify the maximum log file size (KB)"
        {
            RuleId = "{C139DB2E-8DEA-418E-BF7C-372EC0278E31}"
            AzId = "CCE-37695-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Security: Specify the maximum log file size (KB)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
            Value = "MaxSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."C139DB2E_8DEA_418E_BF7C_372EC0278E31".ExpectedValue
            RemediateValue = "196608"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."93C677E7_E7C8_49C4_BB46_D40DAD88F17B".Enabled -eq $true ) {
        ASM_Registry "Set client connection encryption level"
        {
            RuleId = "{93C677E7-E7C8-49C4-BB46-D40DAD88F17B}"
            AzId = "CCE-36627-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Set client connection encryption level"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "MinEncryptionLevel"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."93C677E7_E7C8_49C4_BB46_D40DAD88F17B".ExpectedValue
            RemediateValue = "3"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7869DDEF_04AB_4CC5_90F2_5E6FD1540CBA".Enabled -eq $true ) {
        ASM_Registry "Set the default behavior for AutoRun"
        {
            RuleId = "{7869DDEF-04AB-4CC5-90F2-5E6FD1540CBA}"
            AzId = "CCE-38217-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Set the default behavior for AutoRun"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            Value = "NoAutorun"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."7869DDEF_04AB_4CC5_90F2_5E6FD1540CBA".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."31F0541C_879F_473D_BF6B_E0AEF89F0B45".Enabled -eq $true ) {
        ASM_Registry "Setup: Control Event Log behavior when the log file reaches its maximum size"
        {
            RuleId = "{31F0541C-879F-473D-BF6B-E0AEF89F0B45}"
            AzId = "CCE-38276-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Setup: Control Event Log behavior when the log file reaches its maximum size"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup"
            Value = "Retention"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."31F0541C_879F_473D_BF6B_E0AEF89F0B45".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5BFB71C2_897F_4CCB_B7D5_7181B1F2527A".Enabled -eq $true ) {
        ASM_Registry "Setup: Specify the maximum log file size (KB)"
        {
            RuleId = "{5BFB71C2-897F-4CCB-B7D5-7181B1F2527A}"
            AzId = "CCE-37526-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Setup: Specify the maximum log file size (KB)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup"
            Value = "MaxSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."5BFB71C2_897F_4CCB_B7D5_7181B1F2527A".ExpectedValue
            RemediateValue = "32768"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."fa4d7c0b_987e_47f6_bf8b_f38f49e7c00b".Enabled -eq $true ) {
        ASM_Registry "Shutdown: Allow system to be shut down without having to log on"
        {
            RuleId = "{fa4d7c0b-987e-47f6-bf8b-f38f49e7c00b}"
            AzId = "CCE-36788-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Shutdown: Allow system to be shut down without having to log on"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "ShutdownWithoutLogon"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."fa4d7c0b_987e_47f6_bf8b_f38f49e7c00b".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b784a87e_4aa2_4f61_8b3f_38abff6dac22".Enabled -eq $true ) {
        ASM_Registry "Sign-in last interactive user automatically after a system-initiated restart"
        {
            RuleId = "{b784a87e-4aa2-4f61-8b3f-38abff6dac22}"
            AzId = "CCE-36977-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Sign-in last interactive user automatically after a system-initiated restart"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "DisableAutomaticRestartSignOn"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b784a87e_4aa2_4f61_8b3f_38abff6dac22".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."0be33574_5e6c_4cfe_8b84_18819338eb6e".Enabled -eq $true ) {
        ASM_Registry "System objects: Require case insensitivity for non-Windows subsystems"
        {
            RuleId = "{0be33574-5e6c-4cfe-8b84-18819338eb6e}"
            AzId = "CCE-37885-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "System objects: Require case insensitivity for non-Windows subsystems"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Control\Session Manager\Kernel"
            Value = "ObCaseInsensitive"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."0be33574_5e6c_4cfe_8b84_18819338eb6e".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8db231ff_6c9a_46f8_84de_ebea4507ffe9".Enabled -eq $true ) {
        ASM_Registry "System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)"
        {
            RuleId = "{8db231ff-6c9a-46f8-84de-ebea4507ffe9}"
            AzId = "CCE-37644-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Session Manager"
            Value = "ProtectionMode"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."8db231ff_6c9a_46f8_84de_ebea4507ffe9".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8656ED1C_72E2_4D49_811B_AAEC42521AE0".Enabled -eq $true ) {
        ASM_Registry "System: Control Event Log behavior when the log file reaches its maximum size"
        {
            RuleId = "{8656ED1C-72E2-4D49-811B-AAEC42521AE0}"
            AzId = "CCE-36160-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "System: Control Event Log behavior when the log file reaches its maximum size"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
            Value = "Retention"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."8656ED1C_72E2_4D49_811B_AAEC42521AE0".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3E20B64C_0356_4E95_BA4E_2EBD51E10BB9".Enabled -eq $true ) {
        ASM_Registry "System: Specify the maximum log file size (KB)"
        {
            RuleId = "{3E20B64C-0356-4E95-BA4E-2EBD51E10BB9}"
            AzId = "CCE-36092-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "System: Specify the maximum log file size (KB)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
            Value = "MaxSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3E20B64C_0356_4E95_BA4E_2EBD51E10BB9".ExpectedValue
            RemediateValue = "32768"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."BEA7AFF2_DB2D_4DB7_BF47_0E475DB398A3".Enabled -eq $true ) {
        ASM_Registry "Turn off app notifications on the lock screen"
        {
            RuleId = "{BEA7AFF2-DB2D-4DB7-BF47-0E475DB398A3}"
            AzId = "CCE-35893-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off app notifications on the lock screen"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "DisableLockScreenAppNotifications"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."BEA7AFF2_DB2D_4DB7_BF47_0E475DB398A3".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."D0F025AF_B24B_49AB_9B75_60F485ED5407".Enabled -eq $true ) {
        ASM_Registry "Turn off Autoplay"
        {
            RuleId = "{D0F025AF-B24B-49AB-9B75-60F485ED5407}"
            AzId = "CCE-36875-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off Autoplay"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            Value = "NoDriveTypeAutoRun"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."D0F025AF_B24B_49AB_9B75_60F485ED5407".ExpectedValue
            RemediateValue = "255"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b2538b69_4020_4d50_9f63_581b673a014c".Enabled -eq $true ) {
        ASM_Registry "Turn off Data Execution Prevention for Explorer"
        {
            RuleId = "{b2538b69-4020-4d50-9f63-581b673a014c}"
            AzId = "CCE-37809-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off Data Execution Prevention for Explorer"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Explorer"
            Value = "NoDataExecutionPrevention"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b2538b69_4020_4d50_9f63_581b673a014c".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7B2C4A66_7E3A_421E_9E2B_CCB11762B20E".Enabled -eq $true ) {
        ASM_Registry "Turn off downloading of print drivers over HTTP"
        {
            RuleId = "{7B2C4A66-7E3A-421E-9E2B-CCB11762B20E}"
            AzId = "CCE-36625-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off downloading of print drivers over HTTP"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Printers"
            Value = "DisableWebPnPDownload"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."7B2C4A66_7E3A_421E_9E2B_CCB11762B20E".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a76d6552_cd22_4a2c_adc1_50f8705cad17".Enabled -eq $true ) {
        ASM_Registry "Turn off heap termination on corruption"
        {
            RuleId = "{a76d6552-cd22-4a2c-adc1-50f8705cad17}"
            AzId = "CCE-36660-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off heap termination on corruption"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Explorer"
            Value = "NoHeapTerminationOnCorruption"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."a76d6552_cd22_4a2c_adc1_50f8705cad17".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."0571E435_5C84_48BB_B1C9_6E7EAE13715A".Enabled -eq $true ) {
        ASM_Registry "Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com"
        {
            RuleId = "{0571E435-5C84-48BB-B1C9-6E7EAE13715A}"
            AzId = "CCE-37163-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Internet Connection Wizard"
            Value = "ExitOnMSICW"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."0571E435_5C84_48BB_B1C9_6E7EAE13715A".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4E4D02FA_8F06_4DD3_A443_CCE86DD8FB19".Enabled -eq $true ) {
        ASM_Registry "Turn off Microsoft consumer experiences"
        {
            RuleId = "{4E4D02FA-8F06-4DD3-A443-CCE86DD8FB19}"
            AzId = "AZ-WIN-00144"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off Microsoft consumer experiences"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            Value = "DisableWindowsConsumerFeatures"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4E4D02FA_8F06_4DD3_A443_CCE86DD8FB19".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."94276972_D64D_43BC_AE92_8B609F2D114B".Enabled -eq $true ) {
        ASM_Registry "Turn off multicast name resolution"
        {
            RuleId = "{94276972-D64D-43BC-AE92-8B609F2D114B}"
            AzId = "AZ-WIN-00145"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off multicast name resolution"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
            Value = "EnableMulticast"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."94276972_D64D_43BC_AE92_8B609F2D114B".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."94cc076f_0e88_4398_ac29_d0dc7170303f".Enabled -eq $true ) {
        ASM_Registry "Turn off shell protocol protected mode"
        {
            RuleId = "{94cc076f-0e88-4398-ac29-d0dc7170303f}"
            AzId = "CCE-36809-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off shell protocol protected mode"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            Value = "PreXPSP2ShellProtocolBehavior"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."94cc076f_0e88_4398_ac29_d0dc7170303f".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."37e5e1d9_b9d2_454b_bf3f_124682309155".Enabled -eq $true ) {
        ASM_Registry "Turn on convenience PIN sign-in"
        {
            RuleId = "{37e5e1d9-b9d2-454b-bf3f-124682309155}"
            AzId = "CCE-37528-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn on convenience PIN sign-in"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "AllowDomainPINLogon"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."37e5e1d9_b9d2_454b_bf3f_124682309155".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."967531f7_69cd_4a38_a517_3ebf4e5284cd".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Admin Approval Mode for the Built-in Administrator account"
        {
            RuleId = "{967531f7-69cd-4a38-a517-3ebf4e5284cd}"
            AzId = "CCE-36494-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Admin Approval Mode for the Built-in Administrator account"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "FilterAdministratorToken"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."967531f7_69cd_4a38_a517_3ebf4e5284cd".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."467c29d0_b1be_4113_937c_65583cedf2f0".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop"
        {
            RuleId = "{467c29d0-b1be-4113-937c-65583cedf2f0}"
            AzId = "CCE-36863-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "EnableUIADesktopToggle"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."467c29d0_b1be_4113_937c_65583cedf2f0".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."fc8a4401_ff7a_4a6d_add4_758acce6b76c".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode"
        {
            RuleId = "{fc8a4401-ff7a-4a6d-add4-758acce6b76c}"
            AzId = "CCE-37029-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "ConsentPromptBehaviorAdmin"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."fc8a4401_ff7a_4a6d_add4_758acce6b76c".ExpectedValue
            RemediateValue = "2"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ea132d56_9c29_4d2a_bc92_fc81f616e540".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Behavior of the elevation prompt for standard users"
        {
            RuleId = "{ea132d56-9c29-4d2a-bc92-fc81f616e540}"
            AzId = "CCE-36864-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Behavior of the elevation prompt for standard users"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "ConsentPromptBehaviorUser"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."ea132d56_9c29_4d2a_bc92_fc81f616e540".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."19a185ff_1009_4079_937a_dace5e3c2f50".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Detect application installations and prompt for elevation"
        {
            RuleId = "{19a185ff-1009-4079-937a-dace5e3c2f50}"
            AzId = "CCE-36533-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Detect application installations and prompt for elevation"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "EnableInstallerDetection"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."19a185ff_1009_4079_937a_dace5e3c2f50".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."600ea254_773b_43b5_be89_ca8221e96279".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Only elevate UIAccess applications that are installed in secure locations"
        {
            RuleId = "{600ea254-773b-43b5-be89-ca8221e96279}"
            AzId = "CCE-37057-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Only elevate UIAccess applications that are installed in secure locations"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "EnableSecureUIAPaths"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."600ea254_773b_43b5_be89_ca8221e96279".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1d099cbe_a327_42cd_9562_9896389c4263".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Run all administrators in Admin Approval Mode"
        {
            RuleId = "{1d099cbe-a327-42cd-9562-9896389c4263}"
            AzId = "CCE-36869-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Run all administrators in Admin Approval Mode"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "EnableLUA"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."1d099cbe_a327_42cd_9562_9896389c4263".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."21a9a771_ef63_419c_bee4_8619f19a77ff".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Switch to the secure desktop when prompting for elevation"
        {
            RuleId = "{21a9a771-ef63-419c-bee4-8619f19a77ff}"
            AzId = "CCE-36866-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Switch to the secure desktop when prompting for elevation"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "PromptOnSecureDesktop"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."21a9a771_ef63_419c_bee4_8619f19a77ff".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."61f7469c_c76a_4265_b84f_d838adb06436".Enabled -eq $true ) {
        ASM_Registry "User Account Control: Virtualize file and registry write failures to per-user locations"
        {
            RuleId = "{61f7469c-c76a-4265-b84f-d838adb06436}"
            AzId = "CCE-37064-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "User Account Control: Virtualize file and registry write failures to per-user locations"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "EnableVirtualization"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."61f7469c_c76a_4265_b84f_d838adb06436".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4A459B04_79C8_4FB3_9EA0_CF4B77EE58D7".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Firewall state"
        {
            RuleId = "{4A459B04-79C8-4FB3-9EA0-CF4B77EE58D7}"
            AzId = "CCE-36062-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Firewall state"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "EnableFirewall"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4A459B04_79C8_4FB3_9EA0_CF4B77EE58D7".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."68757CAC_7589_4ED9_A162_27E5926F2DEB".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Outbound connections"
        {
            RuleId = "{68757CAC-7589-4ED9-A162-27E5926F2DEB}"
            AzId = "CCE-36146-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Outbound connections"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "DefaultOutboundAction"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."68757CAC_7589_4ED9_A162_27E5926F2DEB".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."88338D83_A4E2_421B_B3F3_DB6BD2C694A0".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Settings: Apply local connection security rules"
        {
            RuleId = "{88338D83-A4E2-421B-B3F3-DB6BD2C694A0}"
            AzId = "CCE-38040-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Settings: Apply local connection security rules"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "AllowLocalIPsecPolicyMerge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."88338D83_A4E2_421B_B3F3_DB6BD2C694A0".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5F2D95D3_8744_4029_85C9_0BA7EA191531".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Settings: Apply local firewall rules"
        {
            RuleId = "{5F2D95D3-8744-4029-85C9-0BA7EA191531}"
            AzId = "CCE-37860-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Settings: Apply local firewall rules"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "AllowLocalPolicyMerge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."5F2D95D3_8744_4029_85C9_0BA7EA191531".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."D4CB5E92_F237_4F83_95FB_1DDE6BE6DB1B".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Settings: Display a notification"
        {
            RuleId = "{D4CB5E92-F237-4F83-95FB-1DDE6BE6DB1B}"
            AzId = "CCE-38041-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Settings: Display a notification"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "DisableNotifications"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."D4CB5E92_F237_4F83_95FB_1DDE6BE6DB1B".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."C8E1851A_FB32_4197_A1C0_D9DA262D37F1".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Firewall state"
        {
            RuleId = "{C8E1851A-FB32-4197-A1C0-D9DA262D37F1}"
            AzId = "CCE-38239-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Firewall state"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "EnableFirewall"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."C8E1851A_FB32_4197_A1C0_D9DA262D37F1".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."C98CFB4E_113F_4A25_A080_AB1F7D0F8F38".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Outbound connections"
        {
            RuleId = "{C98CFB4E-113F-4A25-A080-AB1F7D0F8F38}"
            AzId = "CCE-38332-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Outbound connections"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "DefaultOutboundAction"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."C98CFB4E_113F_4A25_A080_AB1F7D0F8F38".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."28B5CFB6_7548_44F9_9F43_A542644FA1FD".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Settings: Apply local connection security rules"
        {
            RuleId = "{28B5CFB6-7548-44F9-9F43-A542644FA1FD}"
            AzId = "CCE-36063-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Settings: Apply local connection security rules"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "AllowLocalIPsecPolicyMerge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."28B5CFB6_7548_44F9_9F43_A542644FA1FD".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."A636E099_8E2B_4653_A2BB_3689C151F9CC".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Settings: Apply local firewall rules"
        {
            RuleId = "{A636E099-8E2B-4653-A2BB-3689C151F9CC}"
            AzId = "CCE-37438-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Settings: Apply local firewall rules"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "AllowLocalPolicyMerge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."A636E099_8E2B_4653_A2BB_3689C151F9CC".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."D177F27B_8D9B_4BB1_A45C_5F3A11384D1F".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Settings: Display a notification"
        {
            RuleId = "{D177F27B-8D9B-4BB1-A45C-5F3A11384D1F}"
            AzId = "CCE-37621-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Settings: Display a notification"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "DisableNotifications"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."D177F27B_8D9B_4BB1_A45C_5F3A11384D1F".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5E33A15A_7DB0_4A1D_B771_DB3764F3A625".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Firewall state"
        {
            RuleId = "{5E33A15A-7DB0-4A1D-B771-DB3764F3A625}"
            AzId = "CCE-37862-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Firewall state"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "EnableFirewall"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."5E33A15A_7DB0_4A1D_B771_DB3764F3A625".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."753E721C_BE46_47F4_9571_8509CA5C1E61".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Outbound connections"
        {
            RuleId = "{753E721C-BE46-47F4-9571-8509CA5C1E61}"
            AzId = "CCE-37434-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Outbound connections"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "DefaultOutboundAction"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."753E721C_BE46_47F4_9571_8509CA5C1E61".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."10A43735_527C_46F0_A95C_954A8F9594DC".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Settings: Apply local connection security rules"
        {
            RuleId = "{10A43735-527C-46F0-A95C-954A8F9594DC}"
            AzId = "CCE-36268-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Settings: Apply local connection security rules"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "AllowLocalIPsecPolicyMerge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."10A43735_527C_46F0_A95C_954A8F9594DC".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."E82B54B4_EF4D_474C_B06E_036DD076CBEC".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Settings: Apply local firewall rules"
        {
            RuleId = "{E82B54B4-EF4D-474C-B06E-036DD076CBEC}"
            AzId = "CCE-37861-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Settings: Apply local firewall rules"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "AllowLocalPolicyMerge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."E82B54B4_EF4D_474C_B06E_036DD076CBEC".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."F34E3441_5977_432B_899B_119FC66E1B08".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Settings: Display a notification"
        {
            RuleId = "{F34E3441-5977-432B-899B-119FC66E1B08}"
            AzId = "CCE-38043-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Settings: Display a notification"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "DisableNotifications"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."F34E3441_5977_432B_899B_119FC66E1B08".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."A5A0D2D3_909D_4954_A083_4FB40FCDC181".Enabled -eq $true ) {
        ASM_Registry "Require user authentication for remote connections by using Network Level Authentication"
        {
            RuleId = "{A5A0D2D3-909D-4954-A083-4FB40FCDC181}"
            AzId = "AZ-WIN-00149"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Require user authentication for remote connections by using Network Level Authentication"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "UserAuthentication"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."A5A0D2D3_909D_4954_A083_4FB40FCDC181".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7470f80e_a3d3_4ca9_84e8_7a97a317b2e1".Enabled -eq $true ) {
        ASM_Registry "Shutdown: Clear virtual memory pagefile"
        {
            RuleId = "{7470f80e-a3d3-4ca9-84e8-7a97a317b2e1}"
            AzId = "AZ-WIN-00181"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Shutdown: Clear virtual memory pagefile"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Control\Session Manager\Memory Management"
            Value = "ClearPageFileAtShutdown"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."7470f80e_a3d3_4ca9_84e8_7a97a317b2e1".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3007D6C4_A091_4449_9D05_409319E65883".Enabled -eq $true ) {
        ASM_Registry "Specify the interval to check for definition updates"
        {
            RuleId = "{3007D6C4-A091-4449-9D05-409319E65883}"
            AzId = "AZ-WIN-00152"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Specify the interval to check for definition updates"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Microsoft Antimalware\Signature Updates"
            Value = "SignatureUpdateInterval"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3007D6C4_A091_4449_9D05_409319E65883".ExpectedValue
            RemediateValue = "8"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2B36F636_E882_4B90_92C1_1F55F325053B".Enabled -eq $true ) {
        ASM_Registry "System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies"
        {
            RuleId = "{2B36F636-E882-4B90-92C1-1F55F325053B}"
            AzId = "AZ-WIN-00155"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
            Value = "AuthenticodeEnabled"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."2B36F636_E882_4B90_92C1_1F55F325053B".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."B75811FE_AC22_4171_9511_27FEC5177351".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Allow unicast response"
        {
            RuleId = "{B75811FE-AC22-4171-9511-27FEC5177351}"
            AzId = "AZ-WIN-00088"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Allow unicast response"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "DisableUnicastResponsesToMulticastBroadcast"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."B75811FE_AC22_4171_9511_27FEC5177351".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3DCF28A5_E199_4B78_8933_7828DFDE4B9D".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Allow unicast response"
        {
            RuleId = "{3DCF28A5-E199-4B78-8933-7828DFDE4B9D}"
            AzId = "AZ-WIN-00089"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Allow unicast response"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "DisableUnicastResponsesToMulticastBroadcast"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3DCF28A5_E199_4B78_8933_7828DFDE4B9D".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."B72CC850_F180_4479_ABCE_2B72815AFEAD".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Allow unicast response"
        {
            RuleId = "{B72CC850-F180-4479-ABCE-2B72815AFEAD}"
            AzId = "AZ-WIN-00090"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Allow unicast response"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "DisableUnicastResponsesToMulticastBroadcast"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."B72CC850_F180_4479_ABCE_2B72815AFEAD".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a30f6d7d_f3dc_442c_8a1f_921123c6250c".Enabled -eq $true ) {
        ASM_SecurityPolicy "Bypass traverse checking"
        {
            RuleId = "{a30f6d7d-f3dc-442c-8a1f-921123c6250c}"
            AzId = "AZ-WIN-00184"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Bypass traverse checking"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeChangeNotifyPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."a30f6d7d_f3dc_442c_8a1f_921123c6250c".ExpectedValue
            RemediateValue = "Administrators, Authenticated Users, Backup Operators, Local Service, Network Service"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3f2d92c2_5850_4f2d_b245_f5089aa975dd".Enabled -eq $true ) {
        ASM_SecurityPolicy "Access this computer from the network"
        {
            RuleId = "{3f2d92c2-5850-4f2d-b245-f5089aa975dd}"
            AzId = "CCE-35818-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Access this computer from the network"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeNetworkLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."3f2d92c2_5850_4f2d_b245_f5089aa975dd".ExpectedValue
            RemediateValue = "Administrators, Authenticated Users"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."051545A4_179E_4C04_9E9B_8F33821EF36F".Enabled -eq $true ) {
        ASM_SecurityPolicy "Allow log on locally"
        {
            RuleId = "{051545A4-179E-4C04-9E9B-8F33821EF36F}"
            AzId = "CCE-37659-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow log on locally"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeInteractiveLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."051545A4_179E_4C04_9E9B_8F33821EF36F".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."574f0e8d_83ca_4a46_a6cd_8dd062ab32dd".Enabled -eq $true ) {
        ASM_SecurityPolicy "Allow log on through Remote Desktop Services"
        {
            RuleId = "{574f0e8d-83ca-4a46-a6cd-8dd062ab32dd}"
            AzId = "CCE-37072-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Allow log on through Remote Desktop Services"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeRemoteInteractiveLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."574f0e8d_83ca_4a46_a6cd_8dd062ab32dd".ExpectedValue
            RemediateValue = "Administrators, Remote Desktop Users"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e97bdde4_ccec_42e6_a17f_7993cb03a0d6".Enabled -eq $true ) {
        ASM_SecurityPolicy "Create symbolic links"
        {
            RuleId = "{e97bdde4-ccec-42e6-a17f-7993cb03a0d6}"
            AzId = "CCE-35823-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Create symbolic links"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeCreateSymbolicLinkPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."e97bdde4_ccec_42e6_a17f_7993cb03a0d6".ExpectedValue
            RemediateValue = "Administrators, NT VIRTUAL MACHINE\Virtual Machines"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."fbe348fd_0402_4e31_8482_66ae9ae82ea2".Enabled -eq $true ) {
        ASM_SecurityPolicy "Deny access to this computer from the network"
        {
            RuleId = "{fbe348fd-0402-4e31-8482-66ae9ae82ea2}"
            AzId = "CCE-37954-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Deny access to this computer from the network"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeDenyNetworkLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."fbe348fd_0402_4e31_8482_66ae9ae82ea2".ExpectedValue
            RemediateValue = "Guests"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."045634b9_61c9_414f_ad91_74dcfee9c076".Enabled -eq $true ) {
        ASM_SecurityPolicy "Enable computer and user accounts to be trusted for delegation"
        {
            RuleId = "{045634b9-61c9-414f-ad91-74dcfee9c076}"
            AzId = "CCE-36860-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable computer and user accounts to be trusted for delegation"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeEnableDelegationPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."045634b9_61c9_414f_ad91_74dcfee9c076".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5d72b92f_e6b0_4898_b24a_49241c3a70a4".Enabled -eq $true ) {
        ASM_SecurityPolicy "Manage auditing and security log"
        {
            RuleId = "{5d72b92f-e6b0-4898-b24a-49241c3a70a4}"
            AzId = "CCE-35906-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Manage auditing and security log"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeSecurityPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."5d72b92f_e6b0_4898_b24a_49241c3a70a4".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."131ecdaf_4a45_44ef_8d8e_eb7f4acf2fa6".Enabled -eq $true ) {
        ASM_SecurityPolicy "Access Credential Manager as a trusted caller"
        {
            RuleId = "{131ecdaf-4a45-44ef-8d8e-eb7f4acf2fa6}"
            AzId = "CCE-37056-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Access Credential Manager as a trusted caller"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeTrustedCredManAccessPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."131ecdaf_4a45_44ef_8d8e_eb7f4acf2fa6".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d3d9ac7b_8bcc_42e8_8752_29902eda04dd".Enabled -eq $true ) {
        ASM_SecurityPolicy "Accounts: Guest account status"
        {
            RuleId = "{d3d9ac7b-8bcc-42e8-8752-29902eda04dd}"
            AzId = "CCE-37432-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Accounts: Guest account status"
            Severity = "Critical"
            Category = "System Access"
            Key = "EnableGuestAccount"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."d3d9ac7b_8bcc_42e8_8752_29902eda04dd".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c7f8ee96_6b8e_47e8_80b1_2e0985edeafd".Enabled -eq $true ) {
        ASM_SecurityPolicy "Act as part of the operating system"
        {
            RuleId = "{c7f8ee96-6b8e-47e8-80b1-2e0985edeafd}"
            AzId = "CCE-36876-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Act as part of the operating system"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeTcbPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."c7f8ee96_6b8e_47e8_80b1_2e0985edeafd".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."877cfb8a_1504_4641_9caf_405768ff91f4".Enabled -eq $true ) {
        ASM_SecurityPolicy "Back up files and directories"
        {
            RuleId = "{877cfb8a-1504-4641-9caf-405768ff91f4}"
            AzId = "CCE-35912-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Back up files and directories"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeBackupPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."877cfb8a_1504_4641_9caf_405768ff91f4".ExpectedValue
            RemediateValue = "Administrators, Backup Operators, Server Operators"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8b6f479f_13a9_40d1_a2d6_bd9c27d2b7dc".Enabled -eq $true ) {
        ASM_SecurityPolicy "Change the system time"
        {
            RuleId = "{8b6f479f-13a9-40d1-a2d6-bd9c27d2b7dc}"
            AzId = "CCE-37452-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Change the system time"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeSystemtimePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."8b6f479f_13a9_40d1_a2d6_bd9c27d2b7dc".ExpectedValue
            RemediateValue = "Administrators, Server Operators, LOCAL SERVICE"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8ed0c2c5_af57_4434_9ae8_fe93bc39bfd0".Enabled -eq $true ) {
        ASM_SecurityPolicy "Change the time zone"
        {
            RuleId = "{8ed0c2c5-af57-4434-9ae8-fe93bc39bfd0}"
            AzId = "CCE-37700-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Change the time zone"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeTimeZonePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."8ed0c2c5_af57_4434_9ae8_fe93bc39bfd0".ExpectedValue
            RemediateValue = "Administrators, LOCAL SERVICE"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."04251e82_4442_4923_ac77_992891a5042b".Enabled -eq $true ) {
        ASM_SecurityPolicy "Create a pagefile"
        {
            RuleId = "{04251e82-4442-4923-ac77-992891a5042b}"
            AzId = "CCE-35821-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Create a pagefile"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeCreatePagefilePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."04251e82_4442_4923_ac77_992891a5042b".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d3f866fb_8adf_4ec6_adc7_93bb9ebcccdd".Enabled -eq $true ) {
        ASM_SecurityPolicy "Create a token object"
        {
            RuleId = "{d3f866fb-8adf-4ec6-adc7-93bb9ebcccdd}"
            AzId = "CCE-36861-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Create a token object"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeCreateTokenPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."d3f866fb_8adf_4ec6_adc7_93bb9ebcccdd".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c0a4a0ed_1585_4857_8e2b_30b1bb48c6ea".Enabled -eq $true ) {
        ASM_SecurityPolicy "Create global objects"
        {
            RuleId = "{c0a4a0ed-1585-4857-8e2b-30b1bb48c6ea}"
            AzId = "CCE-37453-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Create global objects"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeCreateGlobalPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."c0a4a0ed_1585_4857_8e2b_30b1bb48c6ea".ExpectedValue
            RemediateValue = "Administrators, SERVICE, LOCAL SERVICE, NETWORK SERVICE"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."03766d3c_81c2_438e_8192_91787f2ae69a".Enabled -eq $true ) {
        ASM_SecurityPolicy "Create permanent shared objects"
        {
            RuleId = "{03766d3c-81c2-438e-8192-91787f2ae69a}"
            AzId = "CCE-36532-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Create permanent shared objects"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeCreatePermanentPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."03766d3c_81c2_438e_8192_91787f2ae69a".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."49258884_b2f0_4a4e_b66a_6954bb8473bf".Enabled -eq $true ) {
        ASM_SecurityPolicy "Deny log on as a batch job"
        {
            RuleId = "{49258884-b2f0-4a4e-b66a-6954bb8473bf}"
            AzId = "CCE-36923-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Deny log on as a batch job"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeDenyBatchLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."49258884_b2f0_4a4e_b66a_6954bb8473bf".ExpectedValue
            RemediateValue = "Guests"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3b993f8f_245d_4f4e_9e8b_f94cbc71c3f6".Enabled -eq $true ) {
        ASM_SecurityPolicy "Deny log on as a service"
        {
            RuleId = "{3b993f8f-245d-4f4e-9e8b-f94cbc71c3f6}"
            AzId = "CCE-36877-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Deny log on as a service"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeDenyServiceLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."3b993f8f_245d_4f4e_9e8b_f94cbc71c3f6".ExpectedValue
            RemediateValue = "Guests"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b7432fc2_51ba_4ddf_83dd_ca7f92e670c1".Enabled -eq $true ) {
        ASM_SecurityPolicy "Deny log on locally"
        {
            RuleId = "{b7432fc2-51ba-4ddf-83dd-ca7f92e670c1}"
            AzId = "CCE-37146-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Deny log on locally"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeDenyInteractiveLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."b7432fc2_51ba_4ddf_83dd_ca7f92e670c1".ExpectedValue
            RemediateValue = "Guests"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."60e0c2c9_0b14_44fe_83d6_2b7095e06674".Enabled -eq $true ) {
        ASM_SecurityPolicy "Deny log on through Remote Desktop Services"
        {
            RuleId = "{60e0c2c9-0b14-44fe-83d6-2b7095e06674}"
            AzId = "CCE-36867-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Deny log on through Remote Desktop Services"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeDenyRemoteInteractiveLogonRight"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."60e0c2c9_0b14_44fe_83d6_2b7095e06674".ExpectedValue
            RemediateValue = "Guests"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."dad8097d_db46_4df3_9839_a8504e60c878".Enabled -eq $true ) {
        ASM_SecurityPolicy "Enforce password history"
        {
            RuleId = "{dad8097d-db46-4df3-9839-a8504e60c878}"
            AzId = "CCE-37166-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enforce password history"
            Severity = "Critical"
            Category = "System Access"
            Key = "PasswordHistorySize"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."dad8097d_db46_4df3_9839_a8504e60c878".ExpectedValue
            RemediateValue = "24"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3531261f_1644_4d10_9242_8e35ef386a83".Enabled -eq $true ) {
        ASM_SecurityPolicy "Force shutdown from a remote system"
        {
            RuleId = "{3531261f-1644-4d10-9242-8e35ef386a83}"
            AzId = "CCE-37877-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Force shutdown from a remote system"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeRemoteShutdownPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."3531261f_1644_4d10_9242_8e35ef386a83".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."46e66c68_266e_4bdc_9ebe_4c5164c0acfe".Enabled -eq $true ) {
        ASM_SecurityPolicy "Generate security audits"
        {
            RuleId = "{46e66c68-266e-4bdc-9ebe-4c5164c0acfe}"
            AzId = "CCE-37639-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Generate security audits"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeAuditPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."46e66c68_266e_4bdc_9ebe_4c5164c0acfe".ExpectedValue
            RemediateValue = "Local Service, Network Service, IIS APPPOOL\DefaultAppPool"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."98372fa4_c0dc_499a_a218_abc96fc04684".Enabled -eq $true ) {
        ASM_SecurityPolicy "Increase scheduling priority"
        {
            RuleId = "{98372fa4-c0dc-499a-a218-abc96fc04684}"
            AzId = "CCE-38326-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Increase scheduling priority"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeIncreaseBasePriorityPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."98372fa4_c0dc_499a_a218_abc96fc04684".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."50f4447d_0bdd_4e8c_ba06_2e0b22ec5d04".Enabled -eq $true ) {
        ASM_SecurityPolicy "Load and unload device drivers"
        {
            RuleId = "{50f4447d-0bdd-4e8c-ba06-2e0b22ec5d04}"
            AzId = "CCE-36318-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Load and unload device drivers"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeLoadDriverPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."50f4447d_0bdd_4e8c_ba06_2e0b22ec5d04".ExpectedValue
            RemediateValue = "Administrators, Print Operators"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."6e635d8c_3496_4c66_b734_c46ebccc5d38".Enabled -eq $true ) {
        ASM_SecurityPolicy "Lock pages in memory"
        {
            RuleId = "{6e635d8c-3496-4c66-b734-c46ebccc5d38}"
            AzId = "CCE-36495-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Lock pages in memory"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeLockMemoryPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."6e635d8c_3496_4c66_b734_c46ebccc5d38".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d43b43ec_abd0_4420_ba8c_d4e53b057205".Enabled -eq $true ) {
        ASM_SecurityPolicy "Maximum password age"
        {
            RuleId = "{d43b43ec-abd0-4420-ba8c-d4e53b057205}"
            AzId = "CCE-37167-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Maximum password age"
            Severity = "Critical"
            Category = "System Access"
            Key = "MaximumPasswordAge"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."d43b43ec_abd0_4420_ba8c_d4e53b057205".ExpectedValue
            RemediateValue = "42"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."45bdfbf8_155f_41f8_b9cf_72f1ba26c5be".Enabled -eq $true ) {
        ASM_SecurityPolicy "Minimum password age"
        {
            RuleId = "{45bdfbf8-155f-41f8-b9cf-72f1ba26c5be}"
            AzId = "CCE-37073-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Minimum password age"
            Severity = "Critical"
            Category = "System Access"
            Key = "MinimumPasswordAge"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."45bdfbf8_155f_41f8_b9cf_72f1ba26c5be".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."bc9d4fef_9e33_48fc_bcbd_b53e60caf4a2".Enabled -eq $true ) {
        ASM_SecurityPolicy "Minimum password length"
        {
            RuleId = "{bc9d4fef-9e33-48fc-bcbd-b53e60caf4a2}"
            AzId = "CCE-36534-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Minimum password length"
            Severity = "Critical"
            Category = "System Access"
            Key = "MinimumPasswordLength"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."bc9d4fef_9e33_48fc_bcbd_b53e60caf4a2".ExpectedValue
            RemediateValue = "14"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."25c07385_c03d_4f61_b4d2_13852635abb7".Enabled -eq $true ) {
        ASM_SecurityPolicy "Modify an object label"
        {
            RuleId = "{25c07385-c03d-4f61-b4d2-13852635abb7}"
            AzId = "CCE-36054-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Modify an object label"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeRelabelPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."25c07385_c03d_4f61_b4d2_13852635abb7".ExpectedValue
            RemediateValue = "No One"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."910405d5_3ee9_427c_baf1_77c69c7c209d".Enabled -eq $true ) {
        ASM_SecurityPolicy "Modify firmware environment values"
        {
            RuleId = "{910405d5-3ee9-427c-baf1-77c69c7c209d}"
            AzId = "CCE-38113-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Modify firmware environment values"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeSystemEnvironmentPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."910405d5_3ee9_427c_baf1_77c69c7c209d".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."299d1595_5ab2_4ef5_b287_6477c0df5178".Enabled -eq $true ) {
        ASM_SecurityPolicy "Password must meet complexity requirements"
        {
            RuleId = "{299d1595-5ab2-4ef5-b287-6477c0df5178}"
            AzId = "CCE-37063-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Password must meet complexity requirements"
            Severity = "Critical"
            Category = "System Access"
            Key = "PasswordComplexity"
            Type = "BOOLEAN"
            ExpectedValue = $ConfigurationData.NonNodeData."299d1595_5ab2_4ef5_b287_6477c0df5178".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."506fa45a_f043_46b0_bca9_da87e2f2618b".Enabled -eq $true ) {
        ASM_SecurityPolicy "Perform volume maintenance tasks"
        {
            RuleId = "{506fa45a-f043-46b0-bca9-da87e2f2618b}"
            AzId = "CCE-36143-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Perform volume maintenance tasks"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeManageVolumePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."506fa45a_f043_46b0_bca9_da87e2f2618b".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."aec3dc3b_3625_47ea_8e11_fef4b1be8adb".Enabled -eq $true ) {
        ASM_SecurityPolicy "Profile single process"
        {
            RuleId = "{aec3dc3b-3625-47ea-8e11-fef4b1be8adb}"
            AzId = "CCE-37131-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Profile single process"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeProfileSingleProcessPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."aec3dc3b_3625_47ea_8e11_fef4b1be8adb".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e61c2d81_389a_4e59_bf19_2a6db7a0dc0b".Enabled -eq $true ) {
        ASM_SecurityPolicy "Profile system performance"
        {
            RuleId = "{e61c2d81-389a-4e59-bf19-2a6db7a0dc0b}"
            AzId = "CCE-36052-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Profile system performance"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeSystemProfilePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."e61c2d81_389a_4e59_bf19_2a6db7a0dc0b".ExpectedValue
            RemediateValue = "Administrators, NT SERVICE\WdiServiceHost"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."08a4b141_c737_404e_8617_9830268e8bfa".Enabled -eq $true ) {
        ASM_SecurityPolicy "Replace a process level token"
        {
            RuleId = "{08a4b141-c737-404e-8617-9830268e8bfa}"
            AzId = "CCE-37430-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Replace a process level token"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeAssignPrimaryTokenPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."08a4b141_c737_404e_8617_9830268e8bfa".ExpectedValue
            RemediateValue = "LOCAL SERVICE, NETWORK SERVICE"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1baa8699_ca1c_466b_b17c_f8eab728b0ee".Enabled -eq $true ) {
        ASM_SecurityPolicy "Restore files and directories"
        {
            RuleId = "{1baa8699-ca1c-466b-b17c-f8eab728b0ee}"
            AzId = "CCE-37613-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Restore files and directories"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeRestorePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."1baa8699_ca1c_466b_b17c_f8eab728b0ee".ExpectedValue
            RemediateValue = "Administrators, Backup Operators"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ef0eefbb_e845_47f3_af9a_3409296d3264".Enabled -eq $true ) {
        ASM_SecurityPolicy "Shut down the system"
        {
            RuleId = "{ef0eefbb-e845-47f3-af9a-3409296d3264}"
            AzId = "CCE-38328-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Shut down the system"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeShutdownPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."ef0eefbb_e845_47f3_af9a_3409296d3264".ExpectedValue
            RemediateValue = "Administrators, Backup Operators"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."adb052b7_c17e_4b8c_86b8_d81b6a89af20".Enabled -eq $true ) {
        ASM_SecurityPolicy "Store passwords using reversible encryption"
        {
            RuleId = "{adb052b7-c17e-4b8c-86b8-d81b6a89af20}"
            AzId = "CCE-36286-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Store passwords using reversible encryption"
            Severity = "Critical"
            Category = "System Access"
            Key = "ClearTextPassword"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."adb052b7_c17e_4b8c_86b8_d81b6a89af20".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b8841a6a_97b1_485b_9f3c_e5ccef30d2e6".Enabled -eq $true ) {
        ASM_SecurityPolicy "Take ownership of files or other objects"
        {
            RuleId = "{b8841a6a-97b1-485b-9f3c-e5ccef30d2e6}"
            AzId = "CCE-38325-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Take ownership of files or other objects"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeTakeOwnershipPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."b8841a6a_97b1_485b_9f3c_e5ccef30d2e6".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."23d0f843_e7bf_40e9_82cb_6299b35e52ab".Enabled -eq $true ) {
        ASM_SecurityPolicy "Increase a process working set"
        {
            RuleId = "{23d0f843-e7bf-40e9-82cb-6299b35e52ab}"
            AzId = "AZ-WIN-00185"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Increase a process working set"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeIncreaseWorkingSetPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."23d0f843_e7bf_40e9_82cb_6299b35e52ab".ExpectedValue
            RemediateValue = "Administrators, Local Service"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ca5d1a59_f141_441d_a57e_6f8bdf078ff3".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Authorization Policy Change"
        {
            RuleId = "{ca5d1a59-f141-441d-a57e-6f8bdf078ff3}"
            AzId = "CCE-36320-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Authorization Policy Change"
            Severity = "Critical"
            Subcategory = "{0CCE9231-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."ca5d1a59_f141_441d_a57e_6f8bdf078ff3".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b2e8d5f9_3d4e_4b8b_b6a1_ddcd60f437b9".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Configure registry policy processing: Process even if the Group Policy objects have not changed' is set to 'Enabled: TRUE'"
        {
            RuleId = "{b2e8d5f9-3d4e-4b8b-b6a1-ddcd60f437b9}"
            AzId = "CCE-36169-1a"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Configure registry policy processing: Process even if the Group Policy objects have not changed' is set to 'Enabled: TRUE'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
            Value = "NoGPOListChanges"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b2e8d5f9_3d4e_4b8b_b6a1_ddcd60f437b9".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."29395413_af1d_4052_86c4_2b059fd4a778".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Directory Service Access"
        {
            RuleId = "{29395413-af1d-4052-86c4-2b059fd4a778}"
            AzId = "CCE-37433-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Directory Service Access"
            Severity = "Critical"
            Subcategory = "{0CCE923B-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."29395413_af1d_4052_86c4_2b059fd4a778".ExpectedValue
            RemediateValue = "Failure"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."6e6cd31c_e045_4b04_9fad_475aef45dd15".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Directory Service Changes"
        {
            RuleId = "{6e6cd31c-e045-4b04-9fad-475aef45dd15}"
            AzId = "CCE-37616-0"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Directory Service Changes"
            Severity = "Critical"
            Subcategory = "{0CCE923C-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."6e6cd31c_e045_4b04_9fad_475aef45dd15".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3b8a1eba_64e5_4117_b7bc_2cf5042de658".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'"
        {
            RuleId = "{3b8a1eba-64e5-4117-b7bc-2cf5042de658}"
            AzId = "CCE-36142-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
            Value = "RequireSignOrSeal"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3b8a1eba_64e5_4117_b7bc_2cf5042de658".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."915714e9_c2ae_42af_a391_c289db580e08".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'"
        {
            RuleId = "{915714e9-c2ae-42af-a391-c289db580e08}"
            AzId = "CCE-37130-2"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
            Value = "SealSecureChannel"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."915714e9_c2ae_42af_a391_c289db580e08".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b399c529_eeec_48dd_92e5_f1b2e14f12c9".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'"
        {
            RuleId = "{b399c529-eeec-48dd-92e5-f1b2e14f12c9}"
            AzId = "CCE-37222-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
            Value = "SignSecureChannel"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b399c529_eeec_48dd_92e5_f1b2e14f12c9".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e30d6758_fb3c_4e9d_8493_f717cd504cf4".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'"
        {
            RuleId = "{e30d6758-fb3c-4e9d-8493-f717cd504cf4}"
            AzId = "CCE-37431-4"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Services\Netlogon\Parameters"
            Value = "MaximumPasswordAge"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."e30d6758_fb3c_4e9d_8493_f717cd504cf4".ExpectedValue
            RemediateValue = "30"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ed9a6795_2803_4b77_9fc8_04f74aef49ed".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'"
        {
            RuleId = "{ed9a6795-2803-4b77-9fc8-04f74aef49ed}"
            AzId = "CCE-37614-5"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
            Value = "RequireStrongKey"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."ed9a6795_2803_4b77_9fc8_04f74aef49ed".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5c532b76_16c0_4a8c_ac67_015b93f458dc".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit IPsec Driver"
        {
            RuleId = "{5c532b76-16c0-4a8c-ac67-015b93f458dc}"
            AzId = "CCE-37853-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit IPsec Driver"
            Severity = "Critical"
            Subcategory = "{0CCE9213-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."5c532b76_16c0_4a8c_ac67_015b93f458dc".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3f78e74e_1601_4bcc_b2c0_5408642d4b81".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Other System Events"
        {
            RuleId = "{3f78e74e-1601-4bcc-b2c0-5408642d4b81}"
            AzId = "CCE-38030-3"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Other System Events"
            Severity = "Critical"
            Subcategory = "{0CCE9214-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."3f78e74e_1601_4bcc_b2c0_5408642d4b81".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."824438cc_72b2_4a24_b13b_7ff0954f0130".Enabled -eq $true ) {
        ASM_Registry "Caching of logon credentials must be limited"
        {
            RuleId = "{824438cc-72b2-4a24-b13b-7ff0954f0130}"
            AzId = "AZ-WIN-73651"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Caching of logon credentials must be limited"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
            Value = "CachedLogonsCount"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."824438cc_72b2_4a24_b13b_7ff0954f0130".ExpectedValue
            RemediateValue = "4"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c1557cd3_5d47_42af_b4e0_993ec42cd697".Enabled -eq $true ) {
        ASM_Registry "The Application Compatibility Program Inventory must be prevented from collecting data and sending the information to Microsoft."
        {
            RuleId = "{c1557cd3-5d47-42af-b4e0-993ec42cd697}"
            AzId = "AZ-WIN-73543"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "The Application Compatibility Program Inventory must be prevented from collecting data and sending the information to Microsoft."
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\AppCompat"
            Value = "DisableInventory"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."c1557cd3_5d47_42af_b4e0_993ec42cd697".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."691b418f_e20e_4d4a_b084_3b7563f38879".Enabled -eq $true ) {
        ASM_Registry "Interactive logon: Machine inactivity limit"
        {
            RuleId = "{691b418f-e20e-4d4a-b084-3b7563f38879}"
            AzId = "AZ-WIN-73645"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Interactive logon: Machine inactivity limit"
            Severity = "Important"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "InactivityTimeoutSecs"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."691b418f_e20e_4d4a_b084_3b7563f38879".ExpectedValue
            RemediateValue = "900"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a07ccc0e_fc6a_48d7_a46c_9c7d464c5439".Enabled -eq $true ) {
        ASM_Registry "Users must be required to enter a password to access private keys stored on the computer."
        {
            RuleId = "{a07ccc0e-fc6a-48d7-a46c-9c7d464c5439}"
            AzId = "AZ-WIN-73699"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Users must be required to enter a password to access private keys stored on the computer."
            Severity = "Important"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Cryptography"
            Value = "ForceKeyProtection"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."a07ccc0e_fc6a_48d7_a46c_9c7d464c5439".ExpectedValue
            RemediateValue = "2"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b6285a67_7909_4ac1_9e0d_b156a1494b46".Enabled -eq $true ) {
        ASM_Registry "Windows Server must be configured to use FIPS-compliant algorithms for encryption, hashing, and signing."
        {
            RuleId = "{b6285a67-7909-4ac1-9e0d-b156a1494b46}"
            AzId = "AZ-WIN-73701"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Server must be configured to use FIPS-compliant algorithms for encryption, hashing, and signing."
            Severity = "Important"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy"
            Value = "Enabled"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b6285a67_7909_4ac1_9e0d_b156a1494b46".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."403670e7_8c1b_4c09_81f8_9c2f3c3ebe30".Enabled -eq $true ) {
        ASM_Registry "Windows Server must be configured to prevent Internet Control Message Protocol (ICMP) redirects from overriding Open Shortest Path First (OSPF)-generated routes."
        {
            RuleId = "{403670e7-8c1b-4c09-81f8-9c2f3c3ebe30}"
            AzId = "AZ-WIN-73503"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Server must be configured to prevent Internet Control Message Protocol (ICMP) redirects from overriding Open Shortest Path First (OSPF)-generated routes."
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
            Value = "EnableICMPRedirect"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."403670e7_8c1b_4c09_81f8_9c2f3c3ebe30".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."feb86a88_2259_4ba0_b68e_2dbb7a43b4ce".Enabled -eq $true ) {
        ASM_Registry "Remote host allows delegation of non-exportable credentials"
        {
            RuleId = "{feb86a88-2259-4ba0-b68e-2dbb7a43b4ce}"
            AzId = "AZ-WIN-20199"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Remote host allows delegation of non-exportable credentials"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
            Value = "AllowProtectedCreds"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."feb86a88_2259_4ba0_b68e_2dbb7a43b4ce".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4d909207_5803_4047_9b53_1d5029d8fe4e".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Kerberos Authentication Service"
        {
            RuleId = "{4d909207-5803-4047-9b53-1d5029d8fe4e}"
            AzId = "AZ-WIN-00004"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Kerberos Authentication Service"
            Severity = "Critical"
            Subcategory = "{0CCE9242-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."4d909207_5803_4047_9b53_1d5029d8fe4e".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e40b12a5_37b5_44be_9824_97f4456924d9".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Directory Service Replication"
        {
            RuleId = "{e40b12a5-37b5-44be-9824-97f4456924d9}"
            AzId = "AZ-WIN-00093"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Directory Service Replication"
            Severity = "Critical"
            Subcategory = "{0CCE923D-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."e40b12a5_37b5_44be_9824_97f4456924d9".ExpectedValue
            RemediateValue = "No Auditing"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."04212107_de72_4eb7_a427_1876b5604a98".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Detailed File Share"
        {
            RuleId = "{04212107-de72-4eb7-a427-1876b5604a98}"
            AzId = "AZ-WIN-00100"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Detailed File Share"
            Severity = "Critical"
            Subcategory = "{0CCE9244-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."04212107_de72_4eb7_a427_1876b5604a98".ExpectedValue
            RemediateValue = "Failure"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."88b87546_b3c8_434f_9cc6_01e117033296".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Other Policy Change Events"
        {
            RuleId = "{88b87546-b3c8-434f-9cc6-01e117033296}"
            AzId = "AZ-WIN-00114"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Other Policy Change Events"
            Severity = "Critical"
            Subcategory = "{0CCE9234-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."88b87546_b3c8_434f_9cc6_01e117033296".ExpectedValue
            RemediateValue = "Failure"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."C9A0B1BF_D925_48D6_8BC6_FB137B5D8C3D".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Distribution Group Management"
        {
            RuleId = "{C9A0B1BF-D925-48D6-8BC6-FB137B5D8C3D}"
            AzId = "CCE-36265-7"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Distribution Group Management"
            Severity = "Critical"
            Subcategory = "{0CCE9238-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."C9A0B1BF_D925_48D6_8BC6_FB137B5D8C3D".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."164BCF05_B0FE_456F_8A25_04D7D920F88A".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit Computer Account Management"
        {
            RuleId = "{164BCF05-B0FE-456F-8A25-04D7D920F88A}"
            AzId = "CCE-38004-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit Computer Account Management"
            Severity = "Critical"
            Subcategory = "{0CCE9236-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."164BCF05_B0FE_456F_8A25_04D7D920F88A".ExpectedValue
            RemediateValue = "Success"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a15a5700_6efb_46af_bf52_1b1104f2aa20".Enabled -eq $true ) {
        ASM_Registry "Block all consumer Microsoft account user authentication"
        {
            RuleId = "{a15a5700-6efb-46af-bf52-1b1104f2aa20}"
            AzId = "AZ-WIN-20198"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Block all consumer Microsoft account user authentication"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\MicrosoftAccount"
            Value = "DisableUserAuth"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."a15a5700_6efb_46af_bf52_1b1104f2aa20".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."071cf127_7766_4551_9a72_788c23f17442".Enabled -eq $true ) {
        ASM_SecurityPolicy "Reset account lockout counter after"
        {
            RuleId = "{071cf127-7766-4551-9a72-788c23f17442}"
            AzId = "AZ-WIN-73309"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Reset account lockout counter after"
            Severity = "Important"
            Category = "System Access"
            Key = "ResetLockoutCount"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."071cf127_7766_4551_9a72_788c23f17442".ExpectedValue
            RemediateValue = "15"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2c4d3323_de56_450a_acda_75b55f60dba2".Enabled -eq $true ) {
        ASM_SecurityPolicy "Account lockout threshold"
        {
            RuleId = "{2c4d3323-de56-450a-acda-75b55f60dba2}"
            AzId = "AZ-WIN-73311"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Account lockout threshold"
            Severity = "Important"
            Category = "System Access"
            Key = "LockoutBadCount"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."2c4d3323_de56_450a_acda_75b55f60dba2".ExpectedValue
            RemediateValue = "3"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."b5c7204a_96b7_4fb9_a7fa_5201b89f5146".Enabled -eq $true ) {
        ASM_Registry "Turn on PowerShell Script Block Logging"
        {
            RuleId = "{b5c7204a-96b7-4fb9-a7fa-5201b89f5146}"
            AzId = "AZ-WIN-73591"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn on PowerShell Script Block Logging"
            Severity = "Important"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
            Value = "EnableScriptBlockLogging"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."b5c7204a_96b7_4fb9_a7fa_5201b89f5146".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."f7d5fa8e_54ed_4e3e_a531_8ed38114bdab".Enabled -eq $true ) {
        ASM_SecurityPolicy "Debug programs"
        {
            RuleId = "{f7d5fa8e-54ed-4e3e-a531-8ed38114bdab}"
            AzId = "AZ-WIN-73755"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Debug programs"
            Severity = "Critical"
            Category = "Privilege Rights"
            Key = "SeDebugPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."f7d5fa8e_54ed_4e3e_a531_8ed38114bdab".ExpectedValue
            RemediateValue = "Administrators"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8718a173_58d6_42ab_a37d_0819c398b5f5".Enabled -eq $true ) {
        ASM_SecurityPolicy "The Impersonate a client after authentication user right must only be assigned to Administrators, Service, Local Service, and Network Service."
        {
            RuleId = "{8718a173-58d6-42ab-a37d-0819c398b5f5}"
            AzId = "AZ-WIN-73785"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "The Impersonate a client after authentication user right must only be assigned to Administrators, Service, Local Service, and Network Service."
            Severity = "Important"
            Category = "Privilege Rights"
            Key = "SeImpersonatePrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."8718a173_58d6_42ab_a37d_0819c398b5f5".ExpectedValue
            RemediateValue = "Administrators,Service,Local Service,Network Service"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."99cd4fc9_bcf1_4def_8ce6_5a3c4ea8f8c9".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Configure registry policy processing: Do not apply during periodic background processing' is set to 'Enabled: FALSE'"
        {
            RuleId = "{99cd4fc9-bcf1-4def-8ce6-5a3c4ea8f8c9}"
            AzId = "CCE-36169-1"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Configure registry policy processing: Do not apply during periodic background processing' is set to 'Enabled: FALSE'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
            Value = "NoBackgroundPolicy"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."99cd4fc9_bcf1_4def_8ce6_5a3c4ea8f8c9".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."cb4110e4_23c8_46ab_9202_497a70efd077".Enabled -eq $true ) {
        ASM_Registry "Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'"
        {
            RuleId = "{cb4110e4-23c8-46ab-9202-497a70efd077}"
            AzId = "CCE-37508-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
            Value = "DisablePasswordChange"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."cb4110e4_23c8_46ab_9202_497a70efd077".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1926dc04_79ea_4a6e_9e35_892c27876bf5".Enabled -eq $true ) {
        ASM_AuditPolicy "Audit File Share"
        {
            RuleId = "{1926dc04-79ea-4a6e-9e35-892c27876bf5}"
            AzId = "AZ-WIN-00102"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Audit File Share"
            Severity = "Critical"
            Subcategory = "{0CCE9224-69AE-11D9-BED3-505054503030}"
            ExpectedValue = $ConfigurationData.NonNodeData."1926dc04_79ea_4a6e_9e35_892c27876bf5".ExpectedValue
            RemediateValue = "Success and Failure"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."16394616_4a4d_4416_9985_b8a3251eb70c".Enabled -eq $true ) {
        ASM_Registry "Disable SMB v1 client (remove dependency on LanmanWorkstation)"
        {
            RuleId = "{16394616-4a4d-4416-9985-b8a3251eb70c}"
            AzId = "AZ-WIN-00122"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Disable SMB v1 client (remove dependency on LanmanWorkstation)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\LanmanWorkstation"
            Value = "DependOnService"
            Type = "REG_MULTI_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."16394616_4a4d_4416_9985_b8a3251eb70c".ExpectedValue
            RemediateValue = "Bowser|#|MRxSmb20|#|NSI"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."20670f2c_01b1_4f5b_9dff_023c697babdb".Enabled -eq $true ) {
        ASM_Registry "Encryption Oracle Remediation for CredSSP protocol"
        {
            RuleId = "{20670f2c-01b1-4f5b-9dff-023c697babdb}"
            AzId = "AZ-WIN-201910"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Encryption Oracle Remediation for CredSSP protocol"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters"
            Value = "AllowEncryptionOracle"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."20670f2c_01b1_4f5b_9dff_023c697babdb".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."336d9398_7f8b_4743_bf48_9bddc7906984".Enabled -eq $true ) {
        ASM_Registry "WDigest Authentication"
        {
            RuleId = "{336d9398-7f8b-4743-bf48-9bddc7906984}"
            AzId = "AZ-WIN-73497"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "WDigest Authentication"
            Severity = "Important"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest"
            Value = "UseLogonCredential"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."336d9398_7f8b_4743_bf48_9bddc7906984".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2016, WS2019]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."f1943ce4_9d62_4aff_aa89_d8ddcab0173e".Enabled -eq $true ) {
        ASM_SecurityPolicy "Adjust memory quotas for a process"
        {
            RuleId = "{f1943ce4-9d62-4aff-aa89-d8ddcab0173e}"
            AzId = "CCE-10849-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Adjust memory quotas for a process"
            Severity = "Warning"
            Category = "Privilege Rights"
            Key = "SeIncreaseQuotaPrivilege"
            Type = "USERRIGHTS"
            ExpectedValue = $ConfigurationData.NonNodeData."f1943ce4_9d62_4aff_aa89_d8ddcab0173e".ExpectedValue
            RemediateValue = "Administrators, Local Service, Network Service"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c4718464_3486_4a14_9cfe_8ef78e8ec56b".Enabled -eq $true ) {
        ASM_Registry "Accounts: Block Microsoft accounts"
        {
            RuleId = "{c4718464-3486-4a14-9cfe-8ef78e8ec56b}"
            AzId = "AZ-WIN-202201"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Accounts: Block Microsoft accounts"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "NoConnectedUser"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."c4718464_3486_4a14_9cfe_8ef78e8ec56b".ExpectedValue
            RemediateValue = "3"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e8b0cc71_407d_4de9_a8db_4c60ef3ac70a".Enabled -eq $true ) {
        ASM_SecurityPolicy "Accounts: Rename administrator account"
        {
            RuleId = "{e8b0cc71-407d-4de9-a8db-4c60ef3ac70a}"
            AzId = "CCE-10976-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Accounts: Rename administrator account"
            Severity = "Warning"
            Category = "System Access"
            Key = "NewAdministratorName"
            Type = "STRING"
            ExpectedValue = $ConfigurationData.NonNodeData."e8b0cc71_407d_4de9_a8db_4c60ef3ac70a".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "NOTEQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."032b9c30_0082_4199_b1ae_2f1fcafd59c6".Enabled -eq $true ) {
        ASM_Registry "Interactive logon: Prompt user to change password before expiration"
        {
            RuleId = "{032b9c30-0082-4199-b1ae-2f1fcafd59c6}"
            AzId = "CCE-10930-6"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Interactive logon: Prompt user to change password before expiration"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
            Value = "PasswordExpiryWarning"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."032b9c30_0082_4199_b1ae_2f1fcafd59c6".ExpectedValue
            RemediateValue = "14"
            Remediate = $true
            AnalyzeOperation = "RANGE"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e9118234_b52b_4b54_ae1a_893a63fe859d".Enabled -eq $true ) {
        ASM_Registry "Microsoft network server: Server SPN target name validation level"
        {
            RuleId = "{e9118234-b52b-4b54-ae1a-893a63fe859d}"
            AzId = "CCE-10617-9"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Microsoft network server: Server SPN target name validation level"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Services\LanManServer\Parameters"
            Value = "SMBServerNameHardeningLevel"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."e9118234_b52b_4b54_ae1a_893a63fe859d".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."16f2e42a_e89d_43a3_b904_cb4d312a8e4a".Enabled -eq $true ) {
        ASM_SecurityPolicy "Network access: Allow anonymous SID/Name translation"
        {
            RuleId = "{16f2e42a-e89d-43a3-b904-cb4d312a8e4a}"
            AzId = "CCE-10024-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Network access: Allow anonymous SID/Name translation"
            Severity = "Warning"
            Category = "System Access"
            Key = "LSAAnonymousNameLookup"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."16f2e42a_e89d_43a3_b904_cb4d312a8e4a".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."514725e3_fa3e_4f3a_9d58_a31449937003".Enabled -eq $true ) {
        ASM_Registry "Limits print driver installation to Administrators"
        {
            RuleId = "{514725e3-fa3e-4f3a-9d58-a31449937003}"
            AzId = "AZ_WIN_202202"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Limits print driver installation to Administrators"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
            Value = "RestrictDriverInstallationToAdministrators"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."514725e3_fa3e_4f3a_9d58_a31449937003".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d74f926c_8ee5_4f06_8c59_2871197d8f41".Enabled -eq $true ) {
        ASM_Registry "Hardened UNC Paths - NETLOGON"
        {
            RuleId = "{d74f926c-8ee5-4f06-8c59-2871197d8f41}"
            AzId = "AZ_WIN_202250"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Hardened UNC Paths - NETLOGON"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths"
            Value = "\\*\NETLOGON"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."d74f926c_8ee5_4f06_8c59_2871197d8f41".ExpectedValue
            RemediateValue = "RequireMutualAuthentication=1, RequireIntegrity=1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."da9fef3f_5a75_43e0_aa0a_d1d8c23af706".Enabled -eq $true ) {
        ASM_Registry "Hardened UNC Paths - SYSVOL"
        {
            RuleId = "{da9fef3f-5a75-43e0-aa0a-d1d8c23af706}"
            AzId = "AZ_WIN_202251"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Hardened UNC Paths - SYSVOL"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths"
            Value = "\\*\SYSVOL"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."da9fef3f_5a75_43e0_aa0a_d1d8c23af706".ExpectedValue
            RemediateValue = "RequireMutualAuthentication=1, RequireIntegrity=1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."589fad5b_4d43_4f88_92d4_33af8dba19d6".Enabled -eq $true ) {
        ASM_Registry "Turn off background refresh of Group Policy"
        {
            RuleId = "{589fad5b-4d43-4f88-92d4-33af8dba19d6}"
            AzId = "CCE-14437-8"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off background refresh of Group Policy"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "DisableBkGndGroupPolicy"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."589fad5b_4d43_4f88_92d4_33af8dba19d6".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."0644341a_0db8_4ff6_8bfe_5751a9b3d1dc".Enabled -eq $true ) {
        ASM_Registry "Enumerate local users on domain-joined computers"
        {
            RuleId = "{0644341a-0db8-4ff6-8bfe-5751a9b3d1dc}"
            AzId = "AZ_WIN_202204"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enumerate local users on domain-joined computers"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "EnumerateLocalUsers"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."0644341a_0db8_4ff6_8bfe_5751a9b3d1dc".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALSORNOTEXISTS"
            ServerTypeFilter = "ServerType = [Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d2d187ef_0321_4e5e_95aa_ac03f16e6373".Enabled -eq $true ) {
        ASM_Registry "Configure Attack Surface Reduction rules"
        {
            RuleId = "{d2d187ef-0321-4e5e-95aa-ac03f16e6373}"
            AzId = "AZ_WIN_202205"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Configure Attack Surface Reduction rules"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR"
            Value = "ExploitGuard_ASR_Rules"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."d2d187ef_0321_4e5e_95aa_ac03f16e6373".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ca8da650_4a25_46fa_8aff_2a4b498de6a5".Enabled -eq $true ) {
        ASM_Registry "Prevent users and apps from accessing dangerous websites"
        {
            RuleId = "{ca8da650-4a25-46fa-8aff-2a4b498de6a5}"
            AzId = "AZ_WIN_202207"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Prevent users and apps from accessing dangerous websites"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"
            Value = "EnableNetworkProtection"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."ca8da650_4a25_46fa_8aff_2a4b498de6a5".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3085af32_217a_4e4b_ba6c_a81c342f8d2c".Enabled -eq $true ) {
        ASM_Registry "Do not allow drive redirection"
        {
            RuleId = "{3085af32-217a-4e4b-ba6c-a81c342f8d2c}"
            AzId = "AZ-WIN-73569"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not allow drive redirection"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
            Value = "fDisableCdm"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."3085af32_217a_4e4b_ba6c_a81c342f8d2c".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."181da750_0ecf_4af3_8724_ab1d6718fd6b".Enabled -eq $true ) {
        ASM_Registry "Turn on PowerShell Transcription"
        {
            RuleId = "{181da750-0ecf-4af3-8724-ab1d6718fd6b}"
            AzId = "AZ-WIN-202208"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn on PowerShell Transcription"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
            Value = "EnableTranscripting"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."181da750_0ecf_4af3_8724_ab1d6718fd6b".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ee69b98c_4bce_4af5_88b9_b8cee25b7524".Enabled -eq $true ) {
        ASM_Registry "Prevent users from modifying settings"
        {
            RuleId = "{ee69b98c-4bce-4af5-88b9-b8cee25b7524}"
            AzId = "AZ-WIN-202209"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Prevent users from modifying settings"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection"
            Value = "DisallowExploitProtectionOverride"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."ee69b98c_4bce_4af5_88b9_b8cee25b7524".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2f9a914c_e88c_401b_9c21_5ddb94b31b4a".Enabled -eq $true ) {
        ASM_Registry "Enable Structured Exception Handling Overwrite Protection (SEHOP)"
        {
            RuleId = "{2f9a914c-e88c-401b-9c21-5ddb94b31b4a}"
            AzId = "AZ-WIN-202210"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable Structured Exception Handling Overwrite Protection (SEHOP)"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
            Value = "DisableExceptionChainValidation"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."2f9a914c_e88c_401b_9c21_5ddb94b31b4a".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d1a15c43_08e0_4d7f_a3f1_e8253fa2083e".Enabled -eq $true ) {
        ASM_Registry "NetBT NodeType configuration"
        {
            RuleId = "{d1a15c43-08e0-4d7f-a3f1-e8253fa2083e}"
            AzId = "AZ-WIN-202211"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "NetBT NodeType configuration"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
            Value = "NodeType"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."d1a15c43_08e0_4d7f_a3f1_e8253fa2083e".ExpectedValue
            RemediateValue = "2"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."ae110ac5_8387_464d_8790_e29ffce8f8d9".Enabled -eq $true ) {
        ASM_Registry "MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning"
        {
            RuleId = "{ae110ac5-8387-464d-8790-e29ffce8f8d9}"
            AzId = "AZ-WIN-202212"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Services\Eventlog\Security"
            Value = "WarningLevel"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."ae110ac5_8387_464d_8790_e29ffce8f8d9".ExpectedValue
            RemediateValue = "90"
            Remediate = $true
            AnalyzeOperation = "LESSOREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d0b4769e_bbfa_4fe0_b6e8_1fd4977d76dd".Enabled -eq $true ) {
        ASM_Registry "MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing)"
        {
            RuleId = "{d0b4769e-bbfa-4fe0-b6e8-1fd4977d76dd}"
            AzId = "AZ-WIN-202213"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing)"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Services\Tcpip6\Parameters"
            Value = "DisableIPSourceRouting"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."d0b4769e_bbfa_4fe0_b6e8_1fd4977d76dd".ExpectedValue
            RemediateValue = "2"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8f624a01_c694_4d61_9d85_bf6d9a4be86d".Enabled -eq $true ) {
        ASM_Registry "MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers"
        {
            RuleId = "{8f624a01-c694-4d61-9d85-bf6d9a4be86d}"
            AzId = "AZ-WIN-202214"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Services\Netbt\Parameters"
            Value = "NoNameReleaseOnDemand"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."8f624a01_c694_4d61_9d85_bf6d9a4be86d".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e1b7d5ea_8e40_47ae_b53e_910959c6649e".Enabled -eq $true ) {
        ASM_Registry "MSS: (SafeDllSearchMode) Enable Safe DLL search mode (recommended)"
        {
            RuleId = "{e1b7d5ea-8e40-47ae-b53e-910959c6649e}"
            AzId = "AZ-WIN-202215"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "MSS: (SafeDllSearchMode) Enable Safe DLL search mode (recommended)"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SYSTEM\CurrentControlSet\Control\Session Manager"
            Value = "SafeDllSearchMode"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."e1b7d5ea_8e40_47ae_b53e_910959c6649e".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4a1c7313_02f4_46a3_a16f_5b4a12db44e4".Enabled -eq $true ) {
        ASM_Registry "Do not enumerate connected users on domain-joined computers"
        {
            RuleId = "{4a1c7313-02f4-46a3-a16f-5b4a12db44e4}"
            AzId = "AZ-WIN-202216"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Do not enumerate connected users on domain-joined computers"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows\System"
            Value = "DontEnumerateConnectedUsers"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4a1c7313_02f4_46a3_a16f_5b4a12db44e4".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."dd3e3ed2_65d2_484f_b909_c9001e347671".Enabled -eq $true ) {
        ASM_Registry "Turn off cloud consumer account state content"
        {
            RuleId = "{dd3e3ed2-65d2-484f-b909-c9001e347671}"
            AzId = "AZ-WIN-202217"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off cloud consumer account state content"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            Value = "DisableConsumerAccountStateContent"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."dd3e3ed2_65d2_484f_b909_c9001e347671".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1eb84c57_2252_466d_8504_c7d34fce2126".Enabled -eq $true ) {
        ASM_Registry "Turn on e-mail scanning"
        {
            RuleId = "{1eb84c57-2252-466d-8504-c7d34fce2126}"
            AzId = "AZ-WIN-202218"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn on e-mail scanning"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender\Scan"
            Value = "DisableEmailScanning"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."1eb84c57_2252_466d_8504_c7d34fce2126".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."dcb8d6a6_45b5_4c3c_8f12_86e0c3680a72".Enabled -eq $true ) {
        ASM_Registry "Configure detection for potentially unwanted applications"
        {
            RuleId = "{dcb8d6a6-45b5-4c3c-8f12-86e0c3680a72}"
            AzId = "AZ-WIN-202219"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Configure detection for potentially unwanted applications"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows Defender"
            Value = "PUAProtection"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."dcb8d6a6_45b5_4c3c_8f12_86e0c3680a72".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."f569293f_f00a_4f11_803c_b1fd2fecd7d8".Enabled -eq $true ) {
        ASM_Registry "Turn off Microsoft Defender AntiVirus"
        {
            RuleId = "{f569293f-f00a-4f11-803c-b1fd2fecd7d8}"
            AzId = "AZ-WIN-202220"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off Microsoft Defender AntiVirus"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows Defender"
            Value = "DisableAntiSpyware"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."f569293f_f00a_4f11_803c_b1fd2fecd7d8".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d243297a_f2a7_49b3_850c_28ceddcd6a5f".Enabled -eq $true ) {
        ASM_Registry "Scan all downloaded files and attachments"
        {
            RuleId = "{d243297a-f2a7-49b3-850c-28ceddcd6a5f}"
            AzId = "AZ-WIN-202221"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Scan all downloaded files and attachments"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows Defender\Real-Time Protection"
            Value = "DisableIOAVProtection"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."d243297a_f2a7_49b3_850c_28ceddcd6a5f".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."822cb00e_9414_44af_9ff3_20bedf3dfe54".Enabled -eq $true ) {
        ASM_Registry "Turn off real-time protection"
        {
            RuleId = "{822cb00e-9414-44af-9ff3-20bedf3dfe54}"
            AzId = "AZ-WIN-202222"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn off real-time protection"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows Defender\Real-Time Protection"
            Value = "DisableRealtimeMonitoring"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."822cb00e_9414_44af_9ff3_20bedf3dfe54".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."23d573d1_0d29_435c_bbc9_509b3c9cfa60".Enabled -eq $true ) {
        ASM_Registry "Turn on script scanning"
        {
            RuleId = "{23d573d1-0d29-435c-bbc9-509b3c9cfa60}"
            AzId = "AZ-WIN-202223"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Turn on script scanning"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "Software\Policies\Microsoft\Windows Defender\Real-Time Protection"
            Value = "DisableScriptScanning"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."23d573d1_0d29_435c_bbc9_509b3c9cfa60".ExpectedValue
            RemediateValue = "0"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."02e555c8_7deb_4fab_a565_d018af8ba39e".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Logging: Name"
        {
            RuleId = "{02e555c8-7deb-4fab-a565-d018af8ba39e}"
            AzId = "AZ-WIN-202224"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Logging: Name"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
            Value = "LogFilePath"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."02e555c8_7deb_4fab_a565_d018af8ba39e".ExpectedValue
            RemediateValue = "%SystemRoot%\System32\logfiles\firewall\domainfw.log"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c67e4967_4e36_4d6a_b1ee_bad7cd747c7c".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Logging: Size limit (KB)"
        {
            RuleId = "{c67e4967-4e36-4d6a-b1ee-bad7cd747c7c}"
            AzId = "AZ-WIN-202225"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Logging: Size limit (KB)"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
            Value = "LogFileSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."c67e4967_4e36_4d6a_b1ee_bad7cd747c7c".ExpectedValue
            RemediateValue = "16384"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."df94d448_eb5c_40f8_a2c1_35af6ba6e566".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Logging: Log dropped packets"
        {
            RuleId = "{df94d448-eb5c-40f8-a2c1-35af6ba6e566}"
            AzId = "AZ-WIN-202226"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Logging: Log dropped packets"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
            Value = "LogDroppedPackets"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."df94d448_eb5c_40f8_a2c1_35af6ba6e566".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."7a9e9e07_2e95_48ec_9a3b_7ee693e35711".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Logging: Log successful connections"
        {
            RuleId = "{7a9e9e07-2e95-48ec-9a3b-7ee693e35711}"
            AzId = "AZ-WIN-202227"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Logging: Log successful connections"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
            Value = "LogSuccessfulConnections"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."7a9e9e07_2e95_48ec_9a3b_7ee693e35711".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."52bb00ec_987c_4f16_a81d_96ef84259bea".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Inbound connections"
        {
            RuleId = "{52bb00ec-987c-4f16-a81d-96ef84259bea}"
            AzId = "AZ-WIN-202228"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Inbound connections"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
            Value = "DefaultInboundAction"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."52bb00ec_987c_4f16_a81d_96ef84259bea".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1196a355_37e4_4a6f_8a8e_740db0d73f09".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Domain: Inbound connections"
        {
            RuleId = "{1196a355-37e4-4a6f-8a8e-740db0d73f09}"
            AzId = "AZ-WIN-202252"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Domain: Inbound connections"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
            Value = "DefaultInboundAction"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."1196a355_37e4_4a6f_8a8e_740db0d73f09".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4c40870a_fe76_4e52_a71c_8344d17a9bc3".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Logging: Name"
        {
            RuleId = "{4c40870a-fe76-4e52-a71c-8344d17a9bc3}"
            AzId = "AZ-WIN-202229"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Logging: Name"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
            Value = "LogFilePath"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."4c40870a_fe76_4e52_a71c_8344d17a9bc3".ExpectedValue
            RemediateValue = "%SystemRoot%\System32\logfiles\firewall\privatefw.log"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."c3bdeda2_0740_42b6_aac2_7d7234f3a557".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Logging: Size limit (KB)"
        {
            RuleId = "{c3bdeda2-0740-42b6-aac2-7d7234f3a557}"
            AzId = "AZ-WIN-202230"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Logging: Size limit (KB)"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
            Value = "LogFileSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."c3bdeda2_0740_42b6_aac2_7d7234f3a557".ExpectedValue
            RemediateValue = "16384"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."be3bba5f_7bd3_4574_b6c2_93341e01b8c0".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Logging: Log dropped packets"
        {
            RuleId = "{be3bba5f-7bd3-4574-b6c2-93341e01b8c0}"
            AzId = "AZ-WIN-202231"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Logging: Log dropped packets"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
            Value = "LogDroppedPackets"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."be3bba5f_7bd3_4574_b6c2_93341e01b8c0".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."396f1552_406d_4b58_b4a6_fc56c75eb70a".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Private: Logging: Log successful connections"
        {
            RuleId = "{396f1552-406d-4b58-b4a6-fc56c75eb70a}"
            AzId = "AZ-WIN-202232"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Private: Logging: Log successful connections"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
            Value = "LogSuccessfulConnections"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."396f1552_406d_4b58_b4a6_fc56c75eb70a".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2f38577d_b711_4eb3_bdc8_b423fc013ed2".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Logging: Log successful connections"
        {
            RuleId = "{2f38577d-b711-4eb3-bdc8-b423fc013ed2}"
            AzId = "AZ-WIN-202233"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Logging: Log successful connections"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
            Value = "LogSuccessfulConnections"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."2f38577d_b711_4eb3_bdc8_b423fc013ed2".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d33c1242_a351_4a00_8a0c_0b50f44441ef".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Inbound connections"
        {
            RuleId = "{d33c1242-a351-4a00-8a0c-0b50f44441ef}"
            AzId = "AZ-WIN-202234"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Inbound connections"
            Severity = "Critical"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
            Value = "DefaultInboundAction"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."d33c1242_a351_4a00_8a0c_0b50f44441ef".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."2614f6be_da8e_4dbc_89d9_7ba4d63564c7".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Logging: Name"
        {
            RuleId = "{2614f6be-da8e-4dbc-89d9-7ba4d63564c7}"
            AzId = "AZ-WIN-202235"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Logging: Name"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
            Value = "LogFilePath"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."2614f6be_da8e_4dbc_89d9_7ba4d63564c7".ExpectedValue
            RemediateValue = "%SystemRoot%\System32\logfiles\firewall\publicfw.log"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."8c115a38_7ea4_4aa8_9115_c78e31bdb411".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Logging: Size limit (KB)"
        {
            RuleId = "{8c115a38-7ea4-4aa8-9115-c78e31bdb411}"
            AzId = "AZ-WIN-202236"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Logging: Size limit (KB)"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
            Value = "LogFileSize"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."8c115a38_7ea4_4aa8_9115_c78e31bdb411".ExpectedValue
            RemediateValue = "16384"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."4ef05db7_7bdc_4a89_b488_31893914e994".Enabled -eq $true ) {
        ASM_Registry "Windows Firewall: Public: Logging: Log dropped packets"
        {
            RuleId = "{4ef05db7-7bdc-4a89-b488-31893914e994}"
            AzId = "AZ-WIN-202237"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Windows Firewall: Public: Logging: Log dropped packets"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
            Value = "LogDroppedPackets"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."4ef05db7_7bdc_4a89_b488_31893914e994".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."5cde9936_ffd5_4aca_9f05_6699353ed3ce".Enabled -eq $true ) {
        ASM_SecurityPolicy "Account Lockout Duration"
        {
            RuleId = "{5cde9936-ffd5-4aca-9f05-6699353ed3ce}"
            AzId = "AZ-WIN-73312"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Account Lockout Duration"
            Severity = "Warning"
            Category = "System Access"
            Key = "LockoutDuration"
            Type = "UINTEGER"
            ExpectedValue = $ConfigurationData.NonNodeData."5cde9936_ffd5_4aca_9f05_6699353ed3ce".ExpectedValue
            RemediateValue = "15"
            Remediate = $true
            AnalyzeOperation = "GREATEROREQUAL"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."276603c5_bd48_407a_949f_6dbbb5b3f61d".Enabled -eq $true ) {
        ASM_Registry "MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing)"
        {
            RuleId = "{276603c5-bd48-407a-949f-6dbbb5b3f61d}"
            AzId = "AZ-WIN-202244"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing)"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "System\CurrentControlSet\Services\Tcpip\Parameters"
            Value = "DisableIPSourceRouting"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."276603c5_bd48_407a_949f_6dbbb5b3f61d".ExpectedValue
            RemediateValue = "2"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."202b60aa_5854_458d_a315_f394c7660df8".Enabled -eq $true ) {
        ASM_OsConfig "Enable virtualization based security"
        {
            RuleId = "{202b60aa-5854-458d-a315-f394c7660df8}"
            AzId = "AZ-WIN-202245"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable virtualization based security"
            Severity = "Critical"
            SettingName = "VirtualizationBasedSecurityStatus"
            ExpectedValue = $ConfigurationData.NonNodeData."202b60aa_5854_458d_a315_f394c7660df8".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersionEx= [WSASHCI22H2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."3783b34c_f774_4034_99f0_3e53874d559e".Enabled -eq $true ) {
        ASM_OsConfig "Enable hypervisor enforced code integrity"
        {
            RuleId = "{3783b34c-f774-4034-99f0-3e53874d559e}"
            AzId = "AZ-WIN-202246"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable hypervisor enforced code integrity"
            Severity = "Critical"
            SettingName = "HypervisorEnforcedCodeIntegrityStatus"
            ExpectedValue = $ConfigurationData.NonNodeData."3783b34c_f774_4034_99f0_3e53874d559e".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersionEx= [WSASHCI22H2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."61156130_85d1_4609_9cd5_01351a0ca7c3".Enabled -eq $true ) {
        ASM_OsConfig "Enable system guard"
        {
            RuleId = "{61156130-85d1-4609-9cd5-01351a0ca7c3}"
            AzId = "AZ-WIN-202247"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable system guard"
            Severity = "Critical"
            SettingName = "SystemGuardStatus"
            ExpectedValue = $ConfigurationData.NonNodeData."61156130_85d1_4609_9cd5_01351a0ca7c3".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersionEx= [WSASHCI22H2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."16281d26_36b2_49a7_8592_974bfce3f975".Enabled -eq $true ) {
        ASM_OsConfig "Enable secure boot"
        {
            RuleId = "{16281d26-36b2-49a7-8592-974bfce3f975}"
            AzId = "AZ-WIN-202248"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable secure boot"
            Severity = "Critical"
            SettingName = "SecureBootState"
            ExpectedValue = $ConfigurationData.NonNodeData."16281d26_36b2_49a7_8592_974bfce3f975".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersionEx= [WSASHCI22H2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."e0780d07_8f0c_4b4a_a4a1_1237f7d2e6d0".Enabled -eq $true ) {
        ASM_OsConfig "Set TPM version"
        {
            RuleId = "{e0780d07-8f0c-4b4a-a4a1-1237f7d2e6d0}"
            AzId = "AZ-WIN-202249"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Set TPM version"
            Severity = "Critical"
            SettingName = "TPMVersion"
            ExpectedValue = $ConfigurationData.NonNodeData."e0780d07_8f0c_4b4a_a4a1_1237f7d2e6d0".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "CONTAINS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersionEx= [WSASHCI22H2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."1b954f4b_ac61_478a_8ad9_75f953a6e76a".Enabled -eq $true ) {
        ASM_OsConfig "Enable boot DMA protection"
        {
            RuleId = "{1b954f4b-ac61-478a-8ad9-75f953a6e76a}"
            AzId = "AZ-WIN-202250"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Enable boot DMA protection"
            Severity = "Critical"
            SettingName = "BootDMAProtection"
            ExpectedValue = $ConfigurationData.NonNodeData."1b954f4b_ac61_478a_8ad9_75f953a6e76a".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersionEx= [WSASHCI22H2]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."d11ed6f2_03ae_4deb_94d9_096b7e6789cb".Enabled -eq $true ) {
        ASM_Registry "Prevent device metadata retrieval from the Internet"
        {
            RuleId = "{d11ed6f2-03ae-4deb-94d9-096b7e6789cb}"
            AzId = "AZ-WIN-202251"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Prevent device metadata retrieval from the Internet"
            Severity = "Informational"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Policies\Microsoft\Windows\Device Metadata"
            Value = "PreventDeviceMetadataFromNetwork"
            Type = "REG_DWORD"
            ExpectedValue = $ConfigurationData.NonNodeData."d11ed6f2_03ae_4deb_94d9_096b7e6789cb".ExpectedValue
            RemediateValue = "1"
            Remediate = $true
            AnalyzeOperation = "EQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."36f1578b_8702_488a_b213_6e30963e8958".Enabled -eq $true ) {
        ASM_Registry "Interactive logon: Message text for users attempting to log on"
        {
            RuleId = "{36f1578b-8702-488a-b213-6e30963e8958}"
            AzId = "AZ-WIN-202253"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Interactive logon: Message text for users attempting to log on"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "LegalNoticeText"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."36f1578b_8702_488a_b213_6e30963e8958".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "NOTEQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."80cb1237_8de9_4124_b6bc_b077e67f2557".Enabled -eq $true ) {
        ASM_Registry "Interactive logon: Message title for users attempting to log on"
        {
            RuleId = "{80cb1237-8de9-4124-b6bc-b077e67f2557}"
            AzId = "AZ-WIN-202254"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Interactive logon: Message title for users attempting to log on"
            Severity = "Warning"
            Hive = "HKEY_LOCAL_MACHINE"
            Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "LegalNoticeCaption"
            Type = "REG_SZ"
            ExpectedValue = $ConfigurationData.NonNodeData."80cb1237_8de9_4124_b6bc_b077e67f2557".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "NOTEQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member]"
            OSFilter = "OSVersion = [WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
    if( $ConfigurationData.NonNodeData."a1272685_6a0d_4008_9d40_fc5c83a8fd8f".Enabled -eq $true ) {
        ASM_SecurityPolicy "Accounts: Rename guest account"
        {
            RuleId = "{a1272685-6a0d-4008-9d40-fc5c83a8fd8f}"
            AzId = "AZ-WIN-202255"
            BaselineId = "{982a79a8-1c46-4fdf-8cfd-60afedf7ad96}"
            OriginalBaselineId = "{9c2bc3d1-8668-48e5-ac5f-281718d52174}"
            Name = "Accounts: Rename guest account"
            Severity = "Warning"
            Category = "System Access"
            Key = "NewGuestName"
            Type = "STRING"
            ExpectedValue = $ConfigurationData.NonNodeData."a1272685_6a0d_4008_9d40_fc5c83a8fd8f".ExpectedValue
            Remediate = $false
            AnalyzeOperation = "NOTEQUALS"
            ServerTypeFilter = "ServerType = [Domain Controller, Domain Member, Workgroup Member]"
            OSFilter = "OSVersion = [WS2008, WS2008R2, WS2012, WS2012R2, WS2016, WS2019, WS2022]"
            Enabled = $true
        }
    }
}
