@{
   AllNodes = @(

        
    )
    NonNodeData =
    @{        "F6C7CDD1_B504_4E9E_A272_1AA2F441DAA3" = @{
                    RuleId = ""
                    Name = "Audit MPSSVC Rule-Level Policy Change"
                    FullDescription = "This subcategory reports changes in policy rules used by the Microsoft Protection Service (MPSSVC.exe). This service is used by Windows Firewall and by Microsoft OneCare. Events for this subcategory include:
  4944: The following policy was active when the Windows Firewall started. 
  4945: A rule was listed when the Windows Firewall started. 
  4946: A change has been made to Windows Firewall exception list. A rule was added. 
  4947: A change has been made to Windows Firewall exception list. A rule was modified. 
  4948: A change has been made to Windows Firewall exception list. A rule was deleted. 
  4949: Windows Firewall settings were restored to the default values. 
  4950: A Windows Firewall setting has changed. 
  4951: A rule has been ignored because its major version number was not recognized by Windows Firewall. 
  4952: Parts of a rule have been ignored because its minor version number was not recognized by Windows Firewall. The other parts of the rule will be enforced. 
  4953: A rule has been ignored by Windows Firewall because it could not parse the rule. 
  4954: Windows Firewall Group Policy settings have changed. The new settings have been applied. 
  4956: Windows Firewall has changed the active profile. 
  4957: Windows Firewall did not apply the following rule:  
  4958: Windows Firewall did not apply the following rule because the rule referred to items not configured on this computer:  
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "ACD96120_83A4_44A9_9E62_127012287E49" = @{
                    RuleId = ""
                    Name = "Audit Other Object Access Events"
                    FullDescription = "This subcategory reports other object access-related events such as Task Scheduler jobs and COM+ objects. Events for this subcategory include:
  4671: An application attempted to access a blocked ordinal through the TBS. 
  4691: Indirect access to an object was requested. 
  4698: A scheduled task was created. 
  4699: A scheduled task was deleted. 
  4700: A scheduled task was enabled. 
  4701: A scheduled task was disabled. 
  4702: A scheduled task was updated.
  5888: An object in the COM+ Catalog was modified. 
  5889: An object was deleted from the COM+ Catalog. 
  5890: An object was added to the COM+ Catalog. 
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "103DE8E8_643E_4B0E_B4A4_A85830239A53" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Account Lockout' is set to 'Success and Failure'"
                    FullDescription = "This subcategory reports when a user's account is locked out as a result of too many failed logon attempts. Events for this subcategory include:
  4625: An account failed to log on. 
Refer to the Microsoft Knowledgebase article 'Description of security events in Windows Vista and in Windows Server 2008' for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a denial of service (DoS). If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Failure"
                    }
        "42DB0BEC_E47F_49F6_A0AF_59798F0FEEFE" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Authentication Policy Change' is set to 'Success'"
                    FullDescription = "This subcategory reports changes in authentication policy. Events for this subcategory include:
  4706: A new trust was created to a domain. 
  4707: A trust to a domain was removed.
  4713: Kerberos policy was changed. 
  4716: Trusted domain information was modified. 
  4717: System security access was granted to an account. 
  4718: System security access was removed from an account. 
  4739: Domain Policy was changed.
  4864: A namespace collision was detected. 
  4865: A trusted forest information entry was added. 
  4866: A trusted forest information entry was removed. 
  4867: A trusted forest information entry was modified. 
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "4f8fd732_facf_4184_a29c_61fdd40db89d" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Credential Validation' is set to 'Success and Failure'"
                    FullDescription = "<p><span>This subcategory reports the results of validation tests on credentials submitted for a user account logon request. These events occur on the computer that is authoritative for the credentials. For domain accounts, the domain controller is authoritative, whereas for local accounts, the local computer is authoritative. In domain environments, most of the Account Logon events occur in the Security log of the domain controllers that are authoritative for the domain accounts. However, these events can occur on other computers in the organization when local accounts are used to log on. Events for this subcategory include: - 4774: An account was mapped for logon. - 4775: An account could not be mapped for logon. - 4776: The domain controller attempted to validate the credentials for an account. - 4777: The domain controller failed to validate the credentials for an account. The recommended state for this setting is: 'Success and Failure'.</span></p>"
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "BABDA20B_1BC0_4204_9745_0CD584DCBB2B" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Group Membership' is set to 'Success'"
                    FullDescription = "Audit Group Membership enables you to audit group memberships when they are enumerated on the client computer.
This policy allows you to audit the group membership information in the user's logon token. Events in this subcategory are generated on the computer on which a logon session is created.

For an interactive logon, the security audit event is generated on the computer that the user logged on to. For a network logon, such as accessing a shared folder on the network, the security audit event is generated on the computer hosting the resource.

You must also enable the Audit Logon subcategory.

Multiple events are generated if the group membership information cannot fit in a single security audit event.

The events that are audited include the following:

  - 4627(S): Group membership information."
                    PotentialImpact = "Depending on configuration, certain user actions may be tracked or logged."
                    Vulnerability = "A malicious agent could make changes to group membership and go unaudited."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "e1174067_f117_4d7f_9584_fd93eedd566f" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Logoff' is set to 'Success'"
                    FullDescription = "<p><span>This subcategory reports when a user logs off from the system. These events occur on the accessed computer. For interactive logons, the generation of these events occurs on the computer that is logged on to. If a network logon takes place to access a share, these events generate on the computer that hosts the accessed resource. If you configure this setting to No auditing, it is difficult or impossible to determine which user has accessed or attempted to access organization computers. Events for this subcategory include: - 4634: An account was logged off. - 4647: User initiated logoff. The recommended state for this setting is: 'Success'.</span></p>"
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "5b5ac074_b108_4acf_aeca_5baabc276538" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Logon' is set to 'Success and Failure'"
                    FullDescription = "<p><span>This subcategory reports when a user attempts to log on to the system. These events occur on the accessed computer. For interactive logons, the generation of these events occurs on the computer that is logged on to. If a network logon takes place to access a share, these events generate on the computer that hosts the accessed resource. If you configure this setting to No auditing, it is difficult or impossible to determine which user has accessed or attempted to access organization computers. Events for this subcategory include: - 4624: An account was successfully logged on. - 4625: An account failed to log on. - 4648: A logon was attempted using explicit credentials. - 4675: SIDs were filtered. The recommended state for this setting is: 'Success and Failure'.</span></p>"
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "ACC56724_35E6_4EAD_A87F_E12B98B396D5" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Other Account Management Events' is set to 'Success'"
                    FullDescription = "This subcategory reports other account management events. Events for this subcategory include:
  4782: The password hash an account was accessed.
  4793: The Password Policy Checking API was called.
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a denial of service (DoS). If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "FA518C7B_96BC_45E6_8FEE_2C99186A010D" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Other Logon/Logoff Events' is set to 'Success and Failure'"
                    FullDescription = "This subcategory reports other logon/logoff-related events, such as Terminal Services session disconnects and reconnects, using RunAs to run processes under a different account, and locking and unlocking a workstation. Events for this subcategory include:
  4649: A replay attack was detected.
  4778: A session was reconnected to a Window Station.
  4779: A session was disconnected from a Window Station.
  4800: The workstation was locked.
  4801: The workstation was unlocked.
  4802: The screen saver was invoked.
  4803: The screen saver was dismissed.
  5378: The requested credentials delegation was disallowed by policy.
  5632: A request was made to authenticate to a wireless network.
  5633: A request was made to authenticate to a wired network.
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a denial of service (DoS). If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "5046d960_670d_4fef_973a_cf242a97147e" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit PNP Activity' is set to 'Success'"
                    FullDescription = "This policy setting allows you to audit when plug and play detects an external device. The recommended state for this setting is: Success. **Note:** A Windows 10, Server 2016 or higher OS is required to access and set this value in Group Policy."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Enabling this setting will allow a user to audit events when a device is plugged into a system. This can help alert IT staff if unapproved devices are plugged in."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "D5DB6E13_EEF5_45AC_A8F3_18A0B1FCD8F9" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Policy Change' is set to 'Success'"
                    FullDescription = "This subcategory reports changes in audit policy including SACL changes. Events for this subcategory include:
  4715: The audit policy (SACL) on an object was changed. 
  4719: System audit policy was changed. 
  4902: The Per-user audit policy table was created. 
  4904: An attempt was made to register a security event source. 
  4905: An attempt was made to unregister a security event source. 
  4906: The CrashOnAuditFail value has changed. 
  4907: Auditing settings on object were changed. 
  4908: Special Groups Logon table modified. 
  4912: Per User Audit Policy was changed. 
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "6b3dc518_61f4_4a47_920c_0411674596a0" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Process Creation' is set to 'Success'"
                    FullDescription = "This subcategory reports the creation of a process and the name of the program or user that created it. Events for this subcategory include: - 4688: A new process has been created. - 4696: A primary token was assigned to process. Refer to Microsoft Knowledge Base article 947226: [Description of security events in Windows Vista and in Windows Server 2008](https://support.microsoft.com/en-us/kb/947226) for the most recent information about this setting. The recommended state for this setting is: Success."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "b88b1d85_5f3c_4235_91ab_6d8b5e767311" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Removable Storage' is set to 'Success and Failure'"
                    FullDescription = "This policy setting allows you to audit user attempts to access file system objects on a removable storage device. A security audit event is generated only for all objects for all types of access requested. If you configure this policy setting, an audit event is generated each time an account accesses a file system object on a removable storage. Success audits record successful attempts and Failure audits record unsuccessful attempts. If you do not configure this policy setting, no audit event is generated when an account accesses a file system object on a removable storage. The recommended state for this setting is: Success and Failure. **Note:** A Windows 8, Server 2012 (non-R2) or higher OS is required to access and set this value in Group Policy."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing removable storage may be useful when investigating an incident. For example, if an individual is suspected of copying sensitive information onto a USB drive."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "515db7da_c244_445b_b093_cf3c09ad8970" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Security Group Management' is set to 'Success and Failure'"
                    FullDescription = "This subcategory reports each event of security group management, such as when a security group is created, changed, or deleted or when a member is added to or removed from a security group. If you enable this Audit policy setting, administrators can track events to detect malicious, accidental, and authorized creation of security group accounts. Events for this subcategory include: - 4727: A security-enabled global group was created. - 4728: A member was added to a security-enabled global group. - 4729: A member was removed from a security-enabled global group. - 4730: A security-enabled global group was deleted. - 4731: A security-enabled local group was created. - 4732: A member was added to a security-enabled local group. - 4733: A member was removed from a security-enabled local group. - 4734: A security-enabled local group was deleted. - 4735: A security-enabled local group was changed. - 4737: A security-enabled global group was changed. - 4754: A security-enabled universal group was created. - 4755: A security-enabled universal group was changed. - 4756: A member was added to a security-enabled universal group. - 4757: A member was removed from a security-enabled universal group. - 4758: A security-enabled universal group was deleted. - 4764: A group's type was changed. The recommended state for this setting is: Success and Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "761F9127_3D19_44AF_87A2_09B10B21ECF2" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Security State Change' is set to 'Success'"
                    FullDescription = "This subcategory reports changes in security state of the system, such as when the security subsystem starts and stops. Events for this subcategory include:
  4608: Windows is starting up. 
  4609: Windows is shutting down. 
  4616: The system time was changed. 
  4621: Administrator recovered system from CrashOnAuditFail. Users who are not administrators will now be allowed to log on. Some auditable activity might not have been recorded. 
Refer to the Microsoft Knowledgebase article 'Description of security events in Windows Vista and in Windows Server 2008' for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "8042F614_F21E_4DCA_BA3F_C8B25523B6B2" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Security System Extension' is set to 'Success'"
                    FullDescription = "This subcategory reports the loading of extension code such as authentication packages by the security subsystem. Events for this subcategory include:
  4610: An authentication package has been loaded by the Local Security Authority. 
  4611: A trusted logon process has been registered with the Local Security Authority. 
  4614: A notification package has been loaded by the Security Account Manager. 
  4622: A security package has been loaded by the Local Security Authority. 
  4697: A service was installed in the system. 
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "AA426F30_E6FF_4C6A_9D59_2EF82A504157" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit Sensitive Privilege Use' is set to 'Success and Failure'"
                    FullDescription = "This subcategory reports when a user account or service uses a sensitive privilege. A sensitive privilege includes the following user rights:  Act as part of the operating system, Backup files and directories, Create a token object, Debug programs, Enable computer and user accounts to be trusted for delegation, Generate security audits, Impersonate a client after authentication, Load and unload device drivers, Manage auditing and security log, Modify firmware environment values, Replace a process-level token, Restore files and directories, and Take ownership of files or other objects. Auditing this subcategory will create a high volume of events. Events for this subcategory include:
  4672: Special privileges assigned to new logon.
  4673: A privileged service was called.
  4674: An operation was attempted on a privileged object.
Refer to the Microsoft Knowledgebase article 'Description of security events in Windows Vista and in Windows Server 2008' for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "8ee0776b_3b84_47bf_9594_e14e29fcc8ff" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit Special Logon' is set to 'Success'"
                    FullDescription = "This subcategory reports when a special logon is used. A special logon is a logon that has administrator-equivalent privileges and can be used to elevate a process to a higher level. Events for this subcategory include: - 4964 : Special groups have been assigned to a new logon. The recommended state for this setting is: Success."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "D5056B06_4651_4698_B5D2_83E6B092E471" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit System Integrity' is set to 'Success'"
                    FullDescription = "This subcategory reports on violations of integrity of the security subsystem. Events for this subcategory include:
  4612: Internal resources allocated for the queuing of audit messages have been exhausted, leading to the loss of some audits. 
  4615: Invalid use of LPC port. 
  4618: A monitored security event pattern has occurred. 
  4816 : RPC detected an integrity violation while decrypting an incoming message. 
  5038: Code integrity determined that the image hash of a file is not valid. The file could be corrupt due to unauthorized modification or the invalid hash could indicate a potential disk device error. 
  5056: A cryptographic self-test was performed. 
  5057: A cryptographic primitive operation failed. 
  5060: Verification operation failed. 
  5061: Cryptographic operation. 
  5062: A kernel-mode cryptographic self-test was performed. 
Refer to the Microsoft Knowledgebase article 'Description of security events in Windows Vista and in Windows Server 2008' for the most recent information about this setting: https://support.microsoft.com/topic/ms16-014-description-of-the-security-update-for-windows-vista-windows-server-2008-windows-7-windows-server-2008-r2-windows-server-2012-windows-8-1-and-windows-server-2012-r2-february-9-2016-1ff344d3-cd1c-cdbd-15b4-9344c7a7e6bd."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "If audit settings are not configured, it can be difficult or impossible to determine what occurred during a security incident. However, if audit settings are configured so that events are generated for all activities the Security log will be filled with data and hard to use. Also, you can use a large amount of data storage as well as adversely affect overall computer performance if you configure audit settings for a large number of objects.
If failure auditing is used and the Audit: Shut down system immediately if unable to log security audits setting in the Security Options section of Group Policy is enabled, an attacker could generate millions of failure events such as logon failures in order to fill the Security log and force the computer to shut down, creating a Denial of Service. If security logs are allowed to be overwritten, an attacker can overwrite part or all of their activity by generating large numbers of events so that the evidence of their intrusion is overwritten."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "7e4d9fe1_eb3f_49ac_bb5b_d417df7e6d6c" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit User Account Management' is set to 'Success and Failure'"
                    FullDescription = "This subcategory reports each event of user account management, such as when a user account is created, changed, or deleted; a user account is renamed, disabled, or enabled; or a password is set or changed. If you enable this Audit policy setting, administrators can track events to detect malicious, accidental, and authorized creation of user accounts. Events for this subcategory include: - 4720: A user account was created. - 4722: A user account was enabled. - 4723: An attempt was made to change an account's password. - 4724: An attempt was made to reset an account's password. - 4725: A user account was disabled. - 4726: A user account was deleted. - 4738: A user account was changed. - 4740: A user account was locked out. - 4765: SID History was added to an account. - 4766: An attempt to add SID History to an account failed. - 4767: A user account was unlocked. - 4780: The ACL was set on accounts which are members of administrators groups. - 4781: The name of an account was changed: - 4794: An attempt was made to set the Directory Services Restore Mode. - 5376: Credential Manager credentials were backed up. - 5377: Credential Manager credentials were restored from a backup. The recommended state for this setting is: Success and Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "116B0718_B9FB_4B6F_855D_05C6CA97369E" = @{
                    RuleId = ""
                    Name = "Configure 'Network access: Remotely accessible registry paths'"
                    FullDescription = "This policy setting determines which registry paths will be accessible after referencing the WinReg key to determine access permissions to the paths.
Note: This setting does not exist in Windows XP. There was a setting with that name in Windows XP, but it is called Network access: Remotely accessible registry paths and subpaths in Windows Server 2003, Windows Vista, and Windows Server 2008.
Note: When you configure this setting, you specify a list of one or more objects. The delimiter used when entering the list is a line feed or carriage return, that is, type the first object on the list, press the Enter button, type the next object, press Enter again, etc. The setting value is stored as a comma-delimited list in group policy security templates. It is also rendered as a comma-delimited list in Group Policy Editor's display pane and the Resultant Set of Policy console. It is recorded in the registry as a line-feed delimited list in a REG_MULTI_SZ value."
                    PotentialImpact = "Remote management tools such as the Microsoft Baseline Security Analyzer and Microsoft Systems Management Server require remote access to the registry to properly monitor and manage those computers. If you remove the default registry paths from the list of accessible ones, such remote management tools could fail.
Note: If you want to allow remote access, you must also enable the Remote Registry service."
                    Vulnerability = "The registry is a database that contains computer configuration information, and much of the information is sensitive. An attacker could use this information to facilitate unauthorized activities. To reduce the risk of such an attack, suitable ACLs are assigned throughout the registry to help protect it from access by unauthorized users."
                    Enabled = $true
                    ExpectedValue = "System\CurrentControlSet\Control\ProductOptions|#|System\CurrentControlSet\Control\Server Applications|#|Software\Microsoft\Windows NT\CurrentVersion"
                    }
        "E261CE65_922A_4573_B2F4_EAF7633CD97C" = @{
                    RuleId = ""
                    Name = "Configure 'Network access: Remotely accessible registry paths and sub-paths'"
                    FullDescription = "This policy setting determines which registry paths and sub-paths will be accessible when an application or process references the WinReg key to determine access permissions.
Note: In Windows XP this setting is called Network access: Remotely accessible registry paths, the setting with that same name in Windows Vista, Windows Server 2008, and Windows Server 2003 does not exist in Windows XP.
Note: When you configure this setting, you specify a list of one or more objects. The delimiter used when entering the list is a line feed or carriage return, that is, type the first object on the list, press the Enter button, type the next object, press Enter again, etc. The setting value is stored as a comma-delimited list in group policy security templates. It is also rendered as a comma-delimited list in Group Policy Editor's display pane and the Resultant Set of Policy console. It is recorded in the registry as a line-feed delimited list in a REG_MULTI_SZ value."
                    PotentialImpact = "Remote management tools such as the Microsoft Baseline Security Analyzer and Microsoft Systems Management Server require remote access to the registry to properly monitor and manage those computers. If you remove the default registry paths from the list of accessible ones, such remote management tools could fail.
Note: If you want to allow remote access, you must also enable the Remote Registry service."
                    Vulnerability = "The registry contains sensitive computer configuration information that could be used by an attacker to facilitate unauthorized activities. The fact that the default ACLs assigned throughout the registry are fairly restrictive and help to protect the registry from access by unauthorized users reduces the risk of such an attack."
                    Enabled = $true
                    ExpectedValue = "System\CurrentControlSet\Control\Print\Printers|#|System\CurrentControlSet\Services\Eventlog|#|Software\Microsoft\OLAP Server|#|Software\Microsoft\Windows NT\CurrentVersion\Print|#|Software\Microsoft\Windows NT\CurrentVersion\Windows|#|System\CurrentControlSet\Control\ContentIndex|#|System\CurrentControlSet\Control\Terminal Server|#|System\CurrentControlSet\Control\Terminal Server\UserConfig|#|System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration|#|Software\Microsoft\Windows NT\CurrentVersion\Perflib|#|System\CurrentControlSet\Services\SysmonLog"
                    }
        "EA1BBC42_7C24_4CED_8EA7_7B16FF4763B5" = @{
                    RuleId = ""
                    Name = "Detect change from default RDP port"
                    FullDescription = "This setting determines whether the network port that listens for Remote Desktop Connections has been changed from the default 3389"
                    PotentialImpact = ""
                    Vulnerability = "If the port has been changed without any other actions taken to mitigate man-in-the-middle and other common attacks, the service can still be discovered and compromised."
                    Enabled = $true
                    ExpectedValue = "3389"
                    }
        "f3117bf3_e54a_496a_9976_74b1caca3105" = @{
                    RuleId = ""
                    Name = "Disable 'Configure local setting override for reporting to Microsoft MAPS'"
                    FullDescription = "This policy setting configures a local override for the configuration to join Microsoft MAPS. This setting can only be set by Group Policy.    If you enable this setting the local preference setting will take priority over Group Policy.    If you disable or do not configure this setting Group Policy will take priority over the local preference setting."
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "a002b800_92a4_45cb_bbee_76c91739ddff" = @{
                    RuleId = ""
                    Name = "Disable SMB v1 server"
                    FullDescription = "Disabling this setting disables server-side processing of the SMBv1 protocol. (Recommended.)

Enabling this setting enables server-side processing of the SMBv1 protocol. (Default.)

Changes to this setting require a reboot to take effect.

For more information, see https://support.microsoft.com/kb/2696547"
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "843079e3_4803_4b52_8b36_c554c4623204" = @{
                    RuleId = ""
                    Name = "Disable Windows Search Service"
                    FullDescription = "This registry setting disables the Windows Search Service"
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "4"
                    }
        "4054c4db_7927_4344_87b4_156c1d681598" = @{
                    RuleId = ""
                    Name = "Enable 'Scan removable drives' by setting DisableRemovableDriveScanning  to 0"
                    FullDescription = "This policy setting allows you to manage whether or not to scan for malicious software and unwanted software in the contents of removable drives such as USB flash drives when running a full scan. If you enable this setting removable drives will be scanned during any type of scan.    If you disable or do not configure this setting removable drives will not be scanned during a full scan. Removable drives may still be scanned during quick scan and custom scan."
                    PotentialImpact = "Removable drives will be scanned during any type of scan by Windows Defender Antivirus"
                    Vulnerability = "It is important to ensure that any present removable drives are always included in any type of scan, as removable drives are more likely to contain malicious software brought in to the enterprise managed environment from an external, unmanaged computer"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "31F2F70A_685F_4E0A_96BA_CB0C0E83768B" = @{
                    RuleId = ""
                    Name = "Enable 'Send file samples when further analysis is required' for 'Send Safe Samples'"
                    FullDescription = "This policy setting configures behavior of samples submission when opt-in for MAPS telemetry is set.

        Possible options are:
        (0x0) Always prompt
        (0x1) Send safe samples automatically
        (0x2) Never send
        (0x3) Send all samples automatically"
                    PotentialImpact = "Depending on configuration, MAPS telemetry data is either sent or not sent."
                    Vulnerability = "Enabling or not configuring this setting may automatically send potentially confidential data to Microsoft, which may be contrary to your organization's security requirements."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "a917e66c_e3e4_4a7b_8f72_e8163994aabc" = @{
                    RuleId = ""
                    Name = "Enable 'Turn on behavior monitoring'"
                    FullDescription = "This policy setting allows you to configure behavior monitoring.    If you enable or do not configure this setting behavior monitoring will be enabled.    If you disable this setting behavior monitoring will be disabled."
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "3715ec67_6cd4_49c0_8c82_27001a0e332b" = @{
                    RuleId = ""
                    Name = " Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether local accounts that are not password protected can be used to log on from locations other than the physical computer console. If you enable this policy setting, local accounts that have blank passwords will not be able to log on to the network from remote client computers. Such accounts will only be able to log on at the keyboard of the computer. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Blank passwords are a serious threat to computer security and should be forbidden through both organizational policy and suitable technical measures. In fact, the default settings for Active Directory domains require complex passwords of at least seven characters. However, if users with the ability to create new accounts bypass your domain-based password policies, they could create accounts with blank passwords. For example, a user could build a stand-alone computer, create one or more accounts with blank passwords, and then join the computer to the domain. The local accounts with blank passwords would still function. Anyone who knows the name of one of these unprotected accounts could then use it to log on."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "abb1bcab_f4da_4a9c_be63_7564a0bca7b8" = @{
                    RuleId = ""
                    Name = " Ensure 'Allow Basic authentication' is set to 'Disabled'"
                    FullDescription = "This policy setting allows you to manage whether the Windows Remote Management (WinRM) service accepts Basic authentication from a remote client. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Basic authentication is less robust than other authentication methods available in WinRM because credentials including passwords are transmitted in plain text. An attacker who is able to capture packets on the network where WinRM is running may be able to determine the credentials used for accessing remote hosts via WinRM."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "484c747f_1418_4c27_a944_c3b1e1690b33" = @{
                    RuleId = ""
                    Name = " Ensure 'Allow indexing of encrypted files' is set to 'Disabled'"
                    FullDescription = "This policy setting controls whether encrypted items are allowed to be indexed. When this setting is changed, the index is rebuilt completely. Full volume encryption (such as BitLocker Drive Encryption or a non-Microsoft solution) must be used for the location of the index to maintain security for encrypted files. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Indexing and allowing users to search encrypted files could potentially reveal confidential data stored within the encrypted files."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "11ca2201_2673_4f04_bad3_3265e1a53a5b" = @{
                    RuleId = ""
                    Name = " Ensure 'Allow Input Personalization' is set to 'Disabled'"
                    FullDescription = "This policy enables the automatic learning component of input personalization that includes speech, inking, and typing. Automatic learning enables the collection of speech and handwriting patterns, typing history, contacts, and recent calendar information. It is required for the use of Cortana. Some of this collected information may be stored on the user's OneDrive, in the case of inking and typing; some of the information will be uploaded to Microsoft to personalize speech. The recommended state for this setting is: Disabled."
                    PotentialImpact = "Automatic learning of speech, inking, and typing stops and users cannot change its value via PC Settings."
                    Vulnerability = "If this setting is Enabled sensitive information could be stored in the cloud or sent to Microsoft."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "DE7AF76F_E469_4A4E_94FD_99F0CCCD54B6" = @{
                    RuleId = ""
                    Name = "Ensure 'Allow Microsoft accounts to be optional' is set to 'Enabled'"
                    FullDescription = "This policy setting lets you control whether Microsoft accounts are optional for Windows Store apps that require an account to sign in. This policy only affects Windows Store apps that support it.

If you enable this policy setting, Windows Store apps that typically require a Microsoft account to sign in will allow users to sign in with an enterprise account instead.

If you disable or do not configure this policy setting, users will need to sign in with a Microsoft account."
                    PotentialImpact = "If you enable this policy setting, Windows Store apps that typically require a Microsoft account to sign in will allow users to sign in with an enterprise account instead.

If you disable or do not configure this policy setting, users will need to sign in with a Microsoft account."
                    Vulnerability = "Microsoft accounts cannot be centrally managed and as such enterprise credential security policies cannot be applied to them, which could put any information accessed by using Microsoft accounts at risk."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "14afe28a_6199_49ff_9789_dabb89ed714e" = @{
                    RuleId = ""
                    Name = "Allow Diagnostic Data"
                    FullDescription = "This policy setting determines the amount of diagnostic and usage data reported to Microsoft. A value of 0 will send minimal data to Microsoft. This data includes Malicious Software Removal Tool (MSRT) & Windows Defender data, if enabled, and telemetry client settings. Setting a value of 0 applies to enterprise, EDU, IoT and server devices only. Setting a value of 0 for other devices is equivalent to choosing a value of 1. A value of 1 sends only a basic amount of diagnostic and usage data. Note that setting values of 0 or 1 will degrade certain experiences on the device. A value of 2 sends enhanced diagnostic and usage data. A value of 3 sends the same data as a value of 2, plus additional diagnostics data, including the files and content that may have caused the problem. Windows 10 telemetry settings apply to the Windows operating system and some first party apps. This setting does not apply to third party apps running on Windows 10. The recommended state for this setting is: Enabled: 0 - Security [Enterprise Only]. **Note:** If the Allow Telemetry setting is configured to 0 - Security [Enterprise Only], then the options in Windows Update to defer upgrades and updates will have no effect."
                    PotentialImpact = "Note that setting values of 0 or 1 will degrade certain experiences on the device."
                    Vulnerability = "Sending any data to a 3rd party vendor is a security concern and should only be done on an as needed basis."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "2785f384_9901_4c9d_8dca_8ff2b5068fde" = @{
                    RuleId = ""
                    Name = " Ensure 'Allow unencrypted traffic' is set to 'Disabled'"
                    FullDescription = "This policy setting allows you to manage whether the Windows Remote Management (WinRM) service sends and receives unencrypted messages over the network. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Encrypting WinRM network traffic reduces the risk of an attacker viewing or modifying WinRM messages as they transit the network."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "5d42c180_4350_49ec_9bb6_e51e1258022c" = @{
                    RuleId = ""
                    Name = " Ensure 'Allow user control over installs' is set to 'Disabled'"
                    FullDescription = "Permits users to change installation options that typically are available only to system administrators. The security features of Windows Installer prevent users from changing installation options typically reserved for system administrators, such as specifying the directory to which files are installed. If Windows Installer detects that an installation package has permitted the user to change a protected option, it stops the installation and displays a message. These security features operate only when the installation program is running in a privileged security context in which it has access to directories denied to the user. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "In an Enterprise environment, only IT staff with administrative rights should be installing or changing software on a system. Allowing users the ability can risk unapproved software from being installed our removed from a system which could cause the system to become vulnerable."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "2eda113a_0fb7_446c_856a_83e010d36671" = @{
                    RuleId = ""
                    Name = " Ensure 'Always install with elevated privileges' is set to 'Disabled'"
                    FullDescription = "This setting controls whether or not Windows Installer should use system permissions when it installs any program on the system. **Note:** This setting appears both in the Computer Configuration and User Configuration folders. To make this setting effective, you must enable the setting in both folders. **Caution:** If enabled, skilled users can take advantage of the permissions this setting grants to change their privileges and gain permanent access to restricted files and folders. Note that the User Configuration version of this setting is not guaranteed to be secure. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users with limited privileges can exploit this feature by creating a Windows Installer installation package that creates a new local account that belongs to the local built-in Administrators group, adds their current account to the local built-in Administrators group, installs malicious software, or performs other unauthorized activities."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "D9794F70_E03C_40E5_A812_D2878C0EB6D5" = @{
                    RuleId = ""
                    Name = "Ensure 'Always prompt for password upon connection' is set to 'Enabled'"
                    FullDescription = "This policy setting specifies whether Terminal Services always prompts the client computer for a password upon connection. You can use this policy setting to enforce a password prompt for users who log on to Terminal Services, even if they already provided the password in the Remote Desktop Connection client. By default, Terminal Services allows users to automatically log on if they enter a password in the Remote Desktop Connection client.
Note   If you do not configure this policy setting, the local computer administrator can use the Terminal Services Configuration tool to either allow or prevent passwords from being automatically sent."
                    PotentialImpact = "Users will always have to enter their password when they establish new Terminal Server sessions."
                    Vulnerability = "Users have the option to store both their username and password when they create a new Remote Desktop connection shortcut. If the server that runs Terminal Services allows users who have used this feature to log on to the server but not enter their password, then it is possible that an attacker who has gained physical access to the user's computer could connect to a Terminal Server through the Remote Desktop connection shortcut, even though they may not know the user's password."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "DEC8589F_4E06_4A11_9C6C_2B1464F07075" = @{
                    RuleId = ""
                    Name = "Ensure 'Application: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
                    FullDescription = "This policy setting controls Event Log behavior when the log file reaches its maximum size.

If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events.

Note: Old events may or may not be retained according to the Backup log automatically when full policy setting."
                    PotentialImpact = "If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events."
                    Vulnerability = "If new events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "E7E377D1_D6E0_4ACC_A073_75B3243A646E" = @{
                    RuleId = ""
                    Name = "Ensure 'Application: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'"
                    FullDescription = "This policy setting specifies the maximum size of the log file in kilobytes.

If you enable this policy setting, you can configure the maximum log file size to be between 1 megabyte (1024 kilobytes) and 2 terabytes (2147483647 kilobytes) in kilobyte increments.

If you disable or do not configure this policy setting, the maximum size of the log file will be set to the locally configured value. This value can be changed by the local administrator using the Log Properties dialog and it defaults to 20 megabytes."
                    PotentialImpact = "When event logs fill to capacity, they will stop recording information unless the retention method for each is set so that the computer will overwrite the oldest entries with the most recent ones. To mitigate the risk of loss of recent data, you can configure the retention method so that older events are overwritten as needed.
The consequence of this configuration is that older events will be removed from the logs. Attackers can take advantage of such a configuration, because they can generate a large number of extraneous events to overwrite any evidence of their attack. These risks can be somewhat reduced if you automate the archival and backup of event log data. 
Ideally, all specifically monitored events should be sent to a server that uses Microsoft Operations Manager (MOM) or some other automated monitoring tool. Such a configuration is particularly important because an attacker who successfully compromises a server could clear the Security log. If all events are sent to a monitoring server, then you will be able to gather forensic information about the attacker's activities."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "32768"
                    }
        "0179CC92_EF40_40B9_9AAA_41AAF3F9F355" = @{
                    RuleId = ""
                    Name = "Ensure 'Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' is set to 'Enabled'"
                    FullDescription = "This policy setting allows administrators to enable the more precise auditing capabilities present in Windows Vista. 
The Audit Policy settings available in Windows Server 2003 Active Directory do not yet contain settings for managing the new auditing subcategories. To properly apply the auditing policies prescribed in this baseline, the Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings setting needs to be configured to Enabled."
                    PotentialImpact = "The individual audit policy subcategories that are available in Windows Vista are not exposed in the interface of Group Policy tools. Administrators can deploy a custom audit policy that applies detailed security auditing settings to Windows Vista-based client computers in a Windows Server 2003 domain or in a Windows 2000 domain. If after enabling this setting, you attempt to modify an auditing setting by using Group Policy, the Group Policy auditing setting will be ignored in favor of the custom policy setting. To modify auditing settings by using Group Policy, you must first disable this key.
 Important 
Be very cautious about audit settings that can generate a large volume of traffic. For example, if you enable either success or failure auditing for all of the Privilege Use subcategories, the high volume of audit events generated can make it difficult to find other types of entries in the Security log. Such a configuration could also have a significant impact on system performance."
                    Vulnerability = "Prior to the introduction of auditing subcategories in Windows Vista, it was difficult to track events at a per-system or per-user level. The larger event categories created too many events and the key information that needed to be audited was difficult to find."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "6907b165_e70a_4b88_b624_3e32a15c93b1" = @{
                    RuleId = ""
                    Name = " Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether the system shuts down if it is unable to log Security events. It is a requirement for Trusted Computer System Evaluation Criteria (TCSEC)-C2 and Common Criteria certification to prevent auditable events from occurring if the audit system is unable to log them. Microsoft has chosen to meet this requirement by halting the system and displaying a stop message if the auditing system experiences a failure. When this policy setting is enabled, the system will be shut down if a security audit cannot be logged for any reason. If the Audit: Shut down system immediately if unable to log security audits setting is enabled, unplanned system failures can occur. The administrative burden can be significant, especially if you also configure the Retention method for the Security log to Do not overwrite events (clear log manually). This configuration causes a repudiation threat (a backup operator could deny that they backed up or restored data) to become a denial of service (DoS) vulnerability, because a server could be forced to shut down if it is overwhelmed with logon events and other security events that are written to the Security log. Also, because the shutdown is not graceful, it is possible that irreparable damage to the operating system, applications, or data could result. Although the NTFS file system guarantees its integrity when an ungraceful computer shutdown occurs, it cannot guarantee that every data file for every application will still be in a usable form when the computer restarts. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "If the computer is unable to record events to the Security log, critical evidence or important troubleshooting information may not be available for review after a security incident. Also, an attacker could potentially generate a large volume of Security log events to purposely force a computer shutdown."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "CAC31D47_C8EA_440F_AF85_7697F483B21E" = @{
                    RuleId = ""
                    Name = "Ensure 'Block user from showing account details on sign-in' is set to 'Enabled'"
                    FullDescription = "This policy prevents the user from showing account details (email address or user name) on the sign-in screen.

If you enable this policy setting, the user cannot choose to show account details on the sign-in screen.

If you disable or do not configure this policy setting, the user may choose to show account details on the sign-in screen."
                    PotentialImpact = "If enabled, users will be unable to see their account information on the sign-in screen."
                    Vulnerability = "Unauthorized users could potentially see a user's sign-in information."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "3C336CEE_A852_4673_82E9_C7E130AF7BC7" = @{
                    RuleId = ""
                    Name = "Ensure 'Boot-Start Driver Initialization Policy' is set to 'Enabled: Good, unknown and bad but critical'"
                    FullDescription = "This policy setting allows you to specify which boot-start drivers are initialized based on a classification determined by an Early Launch Antimalware boot-start driver. The Early Launch Antimalware boot-start driver can return the following classifications for each boot-start driver:
-  Good: The driver has been signed and has not been tampered with.
-  Bad: The driver has been identified as malware. It is recommended that you do not allow known bad drivers to be initialized.
-  Bad, but required for boot: The driver has been identified as malware, but the computer cannot successfully boot without loading this driver.
-  Unknown: This driver has not been attested to by your malware detection application and has not been classified by the Early Launch Antimalware boot-start driver.

If you enable this policy setting you will be able to choose which boot-start drivers to initialize the next time the computer is started.

If you disable or do not configure this policy setting, the boot start drivers determined to be Good, Unknown or Bad but Boot Critical are initialized and the initialization of drivers determined to be Bad is skipped.

If your malware detection application does not include an Early Launch Antimalware boot-start driver or if your Early Launch Antimalware boot-start driver has been disabled, this setting has no effect and all boot-start drivers are initialized."
                    PotentialImpact = "If you enable this policy setting you will be able to choose which boot-start drivers to initialize the next time the computer is started.

If you disable or do not configure this policy setting, the boot start drivers determined to be Good, Unknown or Bad but Boot Critical are initialized and the initialization of drivers determined to be Bad is skipped.

If your malware detection application does not include an Early Launch Antimalware boot-start driver or if your Early Launch Antimalware boot-start driver has been disabled, this setting has no effect and all boot-start drivers are initialized."
                    Vulnerability = "This policy setting helps reduce the impact of malware that has already infected your system."
                    Enabled = $true
                    ExpectedValue = "3"
                    }
        "7450d70c_391d_4932_be4a_3f3bfecc0eb5" = @{
                    RuleId = ""
                    Name = " Ensure 'Configure Offer Remote Assistance' is set to 'Disabled'"
                    FullDescription = "This policy setting allows you to turn on or turn off Offer (Unsolicited) Remote Assistance on this computer. Help desk and support personnel will not be able to proactively offer assistance, although they can still respond to user assistance requests. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "A user might be tricked and accept an unsolicited Remote Assistance offer from a malicious user."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "b17eabc0_5d73_4861_acc8_d5b97bc53f12" = @{
                    RuleId = ""
                    Name = " Ensure 'Configure Solicited Remote Assistance' is set to 'Disabled'"
                    FullDescription = "This policy setting allows you to turn on or turn off Solicited (Ask for) Remote Assistance on this computer. The recommended state for this setting is: Disabled."
                    PotentialImpact = "Users on this computer cannot use e-mail or file transfer to ask someone for help. Also, users cannot use instant messaging programs to allow connections to this computer."
                    Vulnerability = "There is slight risk that a rogue administrator will gain access to another user's desktop session, however, they cannot connect to a user's computer unannounced or control it without permission from the user. When an expert tries to connect, the user can still choose to deny the connection or give the expert view-only privileges. The user must explicitly click the Yes button to allow the expert to remotely control the workstation."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "1E3AE441_8BD6_4736_94AA_AC56A430131C" = @{
                    RuleId = ""
                    Name = "Ensure 'Configure Windows SmartScreen' is set to 'Enabled'"
                    FullDescription = "This policy setting allows you to manage the behavior of Windows SmartScreen. Windows SmartScreen helps keep PCs safer by warning users before running unrecognized programs downloaded from the Internet. Some information is sent to Microsoft about files and programs run on PCs with this feature enabled.

If you enable this policy setting, Windows SmartScreen behavior may be controlled by setting one of the following options:

  Give user a warning before running downloaded unknown software
  Turn off SmartScreen

If you disable or do not configure this policy setting, Windows SmartScreen behavior is managed by administrators on the PC by using Windows SmartScreen Settings in Security and Maintenance.

Options:
  Give user a warning before running downloaded unknown software
  Turn off SmartScreen"
                    PotentialImpact = "If you enable this policy setting, administrators on the PC are unable to configure Windows SmartScreen behavior.

If you disable or do not configure this policy setting, Windows SmartScreen behavior is managed by administrators on the PC by using Windows SmartScreen Settings in Action Center."
                    Vulnerability = "Windows SmartScreen helps keep PCs safer by warning users before running unrecognized programs downloaded from the Internet. However, due to the fact that some information is sent to Microsoft about files and programs run on PCs some organizations may prefer to disable it."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "e588914e_fbb8_4926_9ccf_8ea781b07610" = @{
                    RuleId = ""
                    Name = " Ensure 'Continue experiences on this device' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether the Windows device is allowed to participate in cross-device experiences (continue experiences). The recommended state for this setting is: Disabled."
                    PotentialImpact = "The Windows device will not be discoverable by other devices, and cannot participate in cross-device experiences."
                    Vulnerability = "A cross-device experience is when a system can access app and send messages to other devices. In an enterprise environment only trusted systems should be communicating within the network. Access to any other system should be prohibited."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "01F87552_0D92_477A_91F6_1BEB5B0C8B0E" = @{
                    RuleId = ""
                    Name = "Ensure 'Devices: Allowed to format and eject removable media' is set to 'Administrators'"
                    FullDescription = "This policy setting determines who is allowed to format and eject removable media. You can use this policy setting to prevent unauthorized users from removing data on one computer to access it on another computer on which they have local administrator privileges."
                    PotentialImpact = "Only Administrators will be able to format and eject removable media. If users are in the habit of using removable media for file transfers and storage, they will need to be informed of the change in policy."
                    Vulnerability = "Users may be able to move data on removable disks to a different computer where they have administrative privileges. The user could then take ownership of any file, grant themselves full control, and view or modify any file. The fact that most removable storage devices will eject media by pressing a mechanical button diminishes the advantage of this policy setting."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "5502808d_7049_4378_b9f7_038b70777483" = @{
                    RuleId = ""
                    Name = " Ensure 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'"
                    FullDescription = "For a computer to print to a shared printer, the driver for that shared printer must be installed on the local computer. This security setting determines who is allowed to install a printer driver as part of connecting to a shared printer. The recommended state for this setting is: Enabled. **Note:** This setting does not affect the ability to add a local printer. This setting does not affect Administrators."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "It may be appropriate in some organizations to allow users to install printer drivers on their own workstations. However, you should allow only Administrators, not users, to do so on servers, because printer driver installation on a server may unintentionally cause the computer to become less stable. A malicious user could install inappropriate printer drivers in a deliberate attempt to damage the computer, or a user might accidentally install malicious software that masquerades as a printer driver. It is feasible for an attacker to disguise a Trojan horse program as a printer driver. The program may appear to users as if they must use it to print, but such a program could unleash malicious code on your computer network."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "420CF8AF_038E_4D06_89A4_AA8BFAEC0191" = @{
                    RuleId = ""
                    Name = "Ensure 'Disallow Autoplay for non-volume devices' is set to 'Enabled'"
                    FullDescription = "This policy setting disallows AutoPlay for MTP devices like cameras or phones.

          If you enable this policy setting, AutoPlay is not allowed for MTP devices like cameras or phones.

          If you disable or do not configure this policy setting, AutoPlay is enabled for non-volume devices."
                    PotentialImpact = "AutoPlay is not allowed for MTP devices like cameras or phones."
                    Vulnerability = "Disabling or not configuring this setting allows AutoPlay to start and access MTP devices without user approval and may expose confidential data."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "34edb7eb_697c_4be9_8830_5aa5b031372e" = @{
                    RuleId = ""
                    Name = " Ensure 'Disallow Digest authentication' is set to 'Enabled'"
                    FullDescription = "This policy setting allows you to manage whether the Windows Remote Management (WinRM) client will not use Digest authentication. The recommended state for this setting is: Enabled."
                    PotentialImpact = "The WinRM client will not use Digest authentication."
                    Vulnerability = "Digest authentication is less robust than other authentication methods available in WinRM, an attacker who is able to capture packets on the network where WinRM is running may be able to determine the credentials used for accessing remote hosts via WinRM."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "5FC2DC21_A630_45EE_A62D_5E3D87A45A84" = @{
                    RuleId = ""
                    Name = "Ensure 'Disallow WinRM from storing RunAs credentials' is set to 'Enabled'"
                    FullDescription = "This policy setting allows you to manage whether the Windows Remote Management (WinRM) service will not allow RunAs credentials to be stored for any plug-ins.

If you enable this policy setting, the WinRM service will not allow the RunAsUser or RunAsPassword configuration values to be set for any plug-ins.  If a plug-in has already set the RunAsUser and RunAsPassword configuration values, the RunAsPassword configuration value will be erased from the credential store on this computer.

If you disable or do not configure this policy setting, the WinRM service will allow the RunAsUser and RunAsPassword configuration values to be set for plug-ins and the RunAsPassword value will be stored securely.

If you enable and then disable this policy setting, any values that were previously configured for RunAsPassword will need to be reset."
                    PotentialImpact = "If you enable this policy setting, the WinRM service will not allow the RunAsUser or RunAsPassword configuration values to be set for any plug-ins.  If a plug-in has already set the RunAsUser and RunAsPassword configuration values, the RunAsPassword configuration value will be erased from the credential store on this computer.

If you disable or do not configure this policy setting, the WinRM service will allow the RunAsUser and RunAsPassword configuration values to be set for plug-ins and the RunAsPassword value will be stored securely.

If you enable and then disable this policy setting, any values that were previously configured for RunAsPassword will need to be reset."
                    Vulnerability = "Although the ability to store RunAs credentials is a convenient feature it increases the risk of account compromise slightly. For example, if you forget to lock your desktop before leaving it unattended for a few minutes another person could access not only the desktop of your computer but also any hosts you manage via WinRM with cached RunAs credentials."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "0979B47F_FBBF_46AD_8DEF_768256FA012A" = @{
                    RuleId = ""
                    Name = "Ensure 'Do not allow passwords to be saved' is set to 'Enabled'"
                    FullDescription = "This policy setting helps prevent Terminal Services clients from saving passwords on a computer. Note   If this policy setting was previously configured as Disabled or Not configured, any previously saved passwords will be deleted the first time a Terminal Services client disconnects from any server."
                    PotentialImpact = "If you enable this policy setting, the password saving checkbox is disabled for Terminal Services clients and users will not be able to save passwords."
                    Vulnerability = "An attacker with physical access to the computer may be able to break the protection guarding saved passwords. An attacker who compromises a user's account and connects to their computer could use saved passwords to gain access to additional hosts."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "28B43132_0B7F_4839_9116_8C33AC9EE424" = @{
                    RuleId = ""
                    Name = "Ensure 'Do not delete temp folders upon exit' is set to 'Disabled'"
                    FullDescription = "This policy setting specifies whether Remote Desktop Services retains a user's per-session temporary folders at logoff. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Sensitive information could be contained inside the temporary folders and shared with other administrators that log into the system."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "1CE9D867_2A1F_4E0D_8EE9_BC3606F9302C" = @{
                    RuleId = ""
                    Name = "Ensure 'Do not display network selection UI' is set to 'Enabled'"
                    FullDescription = "This policy setting allows you to control whether anyone can interact with available networks UI on the logon screen.

If you enable this policy setting, the PC's network connectivity state cannot be changed without signing into Windows.

If you disable or don't configure this policy setting, any user can disconnect the PC from the network or can connect the PC to other available networks without signing into Windows."
                    PotentialImpact = "Users will need to log on to Windows with their device each time they want to disconnect from the current network or connect to another one."
                    Vulnerability = "Disabling or not configuring this setting can compromise security as it may allow a malicious agent to disconnect the device from the current network or connect the device to other networks without needing to log on to Windows."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "BE3A95AF_EDC4_4252_A1C0_6C74F3B5B8A7" = @{
                    RuleId = ""
                    Name = "Ensure 'Do not display the password reveal button' is set to 'Enabled'"
                    FullDescription = "This policy setting allows you to configure the display of the password reveal button in password entry user experiences. The recommended state for this setting is: Enabled."
                    PotentialImpact = "The password reveal button will not be displayed after a user types a password in the password entry text box."
                    Vulnerability = "This is a useful feature when entering a long and complex password, especially when using a touchscreen. The potential risk is that someone else may see your password while surreptitiously observing your screen."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "596D3922_71A7_49CE_B34B_1F5E63FF03DA" = @{
                    RuleId = ""
                    Name = "Ensure 'Do not show feedback notifications' is set to 'Enabled'"
                    FullDescription = "This policy setting allows an organization to prevent its devices from showing feedback questions from Microsoft.

If you enable this policy setting, users will no longer see feedback notifications through the Windows Feedback app.

If you disable or do not configure this policy setting, users may see notifications through the Windows Feedback app asking users for feedback.

Note: If you disable or do not configure this policy setting, users can control how often they receive feedback questions."
                    PotentialImpact = "Users cannot see  notifications through the Windows Feedback app asking users for feedback."
                    Vulnerability = "Users may disclose confidential information through feedback."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "832730A2_CC1F_4F77_BB8C_6315D210666F" = @{
                    RuleId = ""
                    Name = "Ensure 'Do not use temporary folders per session' is set to 'Disabled'"
                    FullDescription = "By default, Remote Desktop Services creates a separate temporary folder on the RD Session Host server for each active session that a user maintains on the RD Session Host server. The temporary folder is created on the RD Session Host server in a Temp folder under the user's profile folder and is named with the sessionid. This temporary folder is used to store individual temporary files. To reclaim disk space, the temporary folder is deleted when the user logs off from a session. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "By Disabling this setting you are keeping the cached data independent for each session, both reducing the chance of problems from shared cached data between sessions, and keeping possibly sensitive data separate to each user session."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "09ed81b2_8dba_4009_84f9_dcfd6009ed0d" = @{
                    RuleId = ""
                    Name = " Ensure 'Enable insecure guest logons' is set to 'Disabled'"
                    FullDescription = "This policy setting determines if the SMB client will allow insecure guest logons to an SMB server. The recommended state for this setting is: Disabled."
                    PotentialImpact = "The SMB client will reject insecure guest logons."
                    Vulnerability = "Insecure guest logons are used by file servers to allow unauthenticated access to shared folders."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "7983C8B6_CECA_4475_B58C_5B1D7745CDE3" = @{
                    RuleId = ""
                    Name = "Ensure 'Enable RPC Endpoint Mapper Client Authentication' is set to 'Enabled' (MS only)"
                    FullDescription = "This policy setting controls whether RPC clients authenticate with the Endpoint Mapper Service when the call they are making contains authentication information.   The Endpoint Mapper Service on computers running Windows NT4 (all service packs) cannot process authentication information supplied in this manner. 

If you disable this policy setting, RPC clients will not authenticate to the Endpoint Mapper Service, but they will be able to communicate with the Endpoint Mapper Service on Windows NT4 Server.

If you enable this policy setting, RPC clients will authenticate to the Endpoint Mapper Service for calls that contain authentication information.  Clients making such calls will not be able to communicate with the Windows NT4 Server Endpoint Mapper Service.

If you do not configure this policy setting, it remains disabled.  RPC clients will not authenticate to the Endpoint Mapper Service, but they will be able to communicate with the Windows NT4 Server Endpoint Mapper Service.

Note: This policy will not be applied until the system is rebooted."
                    PotentialImpact = "RPC clients will be forced to authenticate before they can begin communicating with the desired RPC service, this means that anonymous access will not be available and RPC clients that do not support authentication will fail."
                    Vulnerability = "Anonymous access to RPC services could result in accidental disclosure of information to unauthenticated users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "3270E2D2_C01D_49FE_BAF7_950FB5BBE642" = @{
                    RuleId = ""
                    Name = "Ensure 'Enable Windows NTP Client' is set to 'Enabled'"
                    FullDescription = "This policy setting specifies whether the Windows NTP Client is enabled. Enabling the Windows NTP Client allows your computer to synchronize its computer clock with other NTP servers. You might want to disable this service if you decide to use a third-party time provider. The recommended state for this setting is: Enabled."
                    PotentialImpact = "You can set the local computer clock to synchronize time with NTP servers."
                    Vulnerability = "A reliable and accurate account of time is important for a number of services and security requirements, including but not limited to distributed applications, authentication services, multi-user databases and logging services. The use of an NTP client (with secure operation) establishes functional accuracy and is a focal point when reviewing security relevant events"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "e6eab28a_1dc8_4fb5_b88b_4e10f239e67c" = @{
                    RuleId = ""
                    Name = " Ensure 'Enumerate administrator accounts on elevation' is set to 'Disabled'"
                    FullDescription = "This policy setting controls whether administrator accounts are displayed when a user attempts to elevate a running application. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users could see the list of administrator accounts, making it slightly easier for a malicious user who has logged onto a console session to try to crack the passwords of those accounts."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "1648F727_644B_4454_A472_B1A803342E8A" = @{
                    RuleId = ""
                    Name = "Ensure 'Include command line in process creation events' is set to 'Disabled'"
                    FullDescription = "This policy setting determines what information is logged in security audit events when a new process has been created.

This setting only applies when the Audit Process Creation policy is enabled. If you enable this policy setting the command line information for every process will be logged in plain text in the security event log as part of the Audit Process Creation event 4688, a new process has been created, on the workstations and servers on which this policy setting is applied.

If you disable or do not configure this policy setting, the process's command line information will not be included in Audit Process Creation events.

Default: Not configured

Note: When this policy setting is enabled, any user with access to read the security events will be able to read the command line arguments for any successfully created process. Command line arguments can contain sensitive or private information such as passwords or user data."
                    PotentialImpact = "Any user with access to read the security events will be able to read the command line arguments for any successfully created process."
                    Vulnerability = "Disabling or not configuring the setting prevents collection of security forensic information used in diagnosis and analysis."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "9e11215f_9b0b_4ca6_ad5b_d1a0c989af36" = @{
                    RuleId = ""
                    Name = " Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether the account name of the last user to log on to the client computers in your organization will be displayed in each computer's respective Windows logon screen. Enable this policy setting to prevent intruders from collecting account names visually from the screens of desktop or laptop computers in your organization. The recommended state for this setting is: Enabled."
                    PotentialImpact = "The name of the last user to successfully log on is not be displayed in the Windows logon screen."
                    Vulnerability = "An attacker with access to the console (for example, someone with physical access or someone who is able to connect to the server through Terminal Services) could view the name of the last user who logged on to the server. The attacker could then try to guess the password, use a dictionary, or use a brute-force attack to try and log on."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "c2e85522_5e4f_4295_8111_5b2ab815af32" = @{
                    RuleId = ""
                    Name = " Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether users must press CTRL+ALT+DEL before they log on. The recommended state for this setting is: Disabled."
                    PotentialImpact = "Users must press CTRL+ALT+DEL before they log on to Windows unless they use a smart card for Windows logon. A smart card is a tamper-proof device that stores security information."
                    Vulnerability = "Microsoft developed this feature to make it easier for users with certain types of physical impairments to log on to computers that run Windows. If users are not required to press CTRL+ALT+DEL, they are susceptible to attacks that attempt to intercept their passwords. If CTRL+ALT+DEL is required before logon, user passwords are communicated by means of a trusted path. An attacker could install a Trojan horse program that looks like the standard Windows logon dialog box and capture the user's password. The attacker would then be able to log on to the compromised account with whatever level of privilege that user has."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "41a8be7d_69bd_48f4_ae77_9568cf7b15d1" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'"
                    FullDescription = "<p><span>This policy setting determines whether packet signing is required by the SMB client component. **Note:** When Windows Vista-based computers have this policy setting enabled and they connect to file or print shares on remote servers, it is important that the setting is synchronized with its companion setting, **Microsoft network server: Digitally sign communications (always)**, on those servers. For more information about these settings, see the &quot;Microsoft network client and server: Digitally sign communications (four related settings)&quot; section in Chapter 5 of the Threats and Countermeasures guide. The recommended state for this setting is: 'Enabled'.</span></p>"
                    PotentialImpact = "The Microsoft network client will not communicate with a Microsoft network server unless that server agrees to perform SMB packet signing. The Windows 2000 Server, Windows 2000 Professional, Windows Server 2003, Windows XP Professional and Windows Vista implementations of the SMB file and print sharing protocol support mutual authentication, which prevents session hijacking attacks and supports message authentication to prevent man-in-the-middle attacks. SMB signing provides this authentication by placing a digital signature into each SMB, which is then verified by both the client and the server. Implementation of SMB signing may negatively affect performance, because each packet needs to be signed and verified. If these settings are enabled on a server that is performing multiple roles, such as a small business server that is serving as a domain controller, file server, print server, and application server performance may be substantially slowed. Additionally, if you configure computers to ignore all unsigned SMB communications, older applications and operating systems will not be able to connect. However, if you completely disable all SMB signing, computers will be vulnerable to session hijacking attacks. When SMB signing policies are enabled on domain controllers running Windows Server 2003 and member computers running Windows Vista SP1 or Windows Server 2008 group policy processing will fail. A hotfix is available from Microsoft that resolves this issue; see Microsoft Knowledge Base article 950876 for more details: [Group Policy settings are not applied on member computers that are running Windows Server 2008 or Windows Vista SP1 when certain SMB signing policies are enabled](https://support.microsoft.com/en-us/kb/950876)."
                    Vulnerability = "Session hijacking uses tools that allow attackers who have access to the same network as the client or server to interrupt, end, or steal a session in progress. Attackers can potentially intercept and modify unsigned SMB packets and then modify the traffic and forward it so that the server might perform undesirable actions. Alternatively, the attacker could pose as the server or client after legitimate authentication and gain unauthorized access to data. SMB is the resource sharing protocol that is supported by many Windows operating systems. It is the basis of NetBIOS and many other protocols. SMB signatures authenticate both users and the servers that host the data. If either side fails the authentication process, data transmission will not take place."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "342046f5_c7d3_46b7_96db_7e4be82542d3" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether the SMB client will attempt to negotiate SMB packet signing. **Note:** Enabling this policy setting on SMB clients on your network makes them fully effective for packet signing with all clients and servers in your environment. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior. The Windows 2000 Server, Windows 2000 Professional, Windows Server 2003, Windows XP Professional and Windows Vista implementations of the SMB file and print sharing protocol support mutual authentication, which prevents session hijacking attacks and supports message authentication to prevent man-in-the-middle attacks. SMB signing provides this authentication by placing a digital signature into each SMB, which is then verified by both the client and the server. Implementation of SMB signing may negatively affect performance, because each packet needs to be signed and verified. If these settings are enabled on a server that is performing multiple roles, such as a small business server that is serving as a domain controller, file server, print server, and application server performance may be substantially slowed. Additionally, if you configure computers to ignore all unsigned SMB communications, older applications and operating systems will not be able to connect. However, if you completely disable all SMB signing, computers will be vulnerable to session hijacking attacks. When SMB signing policies are enabled on domain controllers running Windows Server 2003 and member computers running Windows Vista SP1 or Windows Server 2008 group policy processing will fail. A hotfix is available from Microsoft that resolves this issue; see Microsoft Knowledge Base article 950876 for more details: [Group Policy settings are not applied on member computers that are running Windows Server 2008 or Windows Vista SP1 when certain SMB signing policies are enabled](https://support.microsoft.com/en-us/kb/950876)."
                    Vulnerability = "Session hijacking uses tools that allow attackers who have access to the same network as the client or server to interrupt, end, or steal a session in progress. Attackers can potentially intercept and modify unsigned SMB packets and then modify the traffic and forward it so that the server might perform undesirable actions. Alternatively, the attacker could pose as the server or client after legitimate authentication and gain unauthorized access to data. SMB is the resource sharing protocol that is supported by many Windows operating systems. It is the basis of NetBIOS and many other protocols. SMB signatures authenticate both users and the servers that host the data. If either side fails the authentication process, data transmission will not take place."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "a14a2808_588b_4233_b342_9dc1cecf2b0a" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'"
                    FullDescription = "<p><span>This policy setting determines whether the SMB redirector will send plaintext passwords during authentication to third-party SMB servers that do not support password encryption. It is recommended that you disable this policy setting unless there is a strong business case to enable it. If this policy setting is enabled, unencrypted passwords will be allowed across the network. The recommended state for this setting is: 'Disabled'.</span></p>"
                    PotentialImpact = "None - this is the default configuration. Some very old applications and operating systems such as MS-DOS, Windows for Workgroups 3.11, and Windows 95a may not be able to communicate with the servers in your organization by means of the SMB protocol."
                    Vulnerability = "If you enable this policy setting, the server can transmit passwords in plaintext across the network to other computers that offer SMB services, which is a significant security risk. These other computers may not use any of the SMB security mechanisms that are included with Windows Server 2003."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "4383c5e5_ea15_4e94_a170_fd61b3fda9f1" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute, but not 0'"
                    FullDescription = "This policy setting allows you to specify the amount of continuous idle time that must pass in an SMB session before the session is suspended because of inactivity. Administrators can use this policy setting to control when a computer suspends an inactive SMB session. If client activity resumes, the session is automatically reestablished. A value of 0 appears to allow sessions to persist indefinitely. The maximum value is 99999, which is over 69 days; in effect, this value disables the setting. The recommended state for this setting is: 15 or fewer minute(s), but not 0."
                    PotentialImpact = "There will be little impact because SMB sessions will be re-established automatically if the client resumes activity."
                    Vulnerability = "Each SMB session consumes server resources, and numerous null sessions will slow the server or possibly cause it to fail. An attacker could repeatedly establish SMB sessions until the server's SMB services become slow or unresponsive."
                    Enabled = $true
                    ExpectedValue = "1,15"
                    }
        "032b5976_1c4b_4c68_bc5d_0c65e35306b2" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network server: Digitally sign communications ' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether packet signing is required by the SMB server component. Enable this policy setting in a mixed environment to prevent downstream clients from using the workstation as a network server. The recommended state for this setting is: Enabled."
                    PotentialImpact = "The Microsoft network server will not communicate with a Microsoft network client unless that client agrees to perform SMB packet signing. The Windows 2000 Server, Windows 2000 Professional, Windows Server 2003, Windows XP Professional and Windows Vista implementations of the SMB file and print sharing protocol support mutual authentication, which prevents session hijacking attacks and supports message authentication to prevent man-in-the-middle attacks. SMB signing provides this authentication by placing a digital signature into each SMB, which is then verified by both the client and the server. Implementation of SMB signing may negatively affect performance, because each packet needs to be signed and verified. If these settings are enabled on a server that is performing multiple roles, such as a small business server that is serving as a domain controller, file server, print server, and application server performance may be substantially slowed. Additionally, if you configure computers to ignore all unsigned SMB communications, older applications and operating systems will not be able to connect. However, if you completely disable all SMB signing, computers will be vulnerable to session hijacking attacks. When SMB signing policies are enabled on domain controllers running Windows Server 2003 and member computers running Windows Vista SP1 or Windows Server 2008 group policy processing will fail. A hotfix is available from Microsoft that resolves this issue; see Microsoft Knowledge Base article 950876 for more details: [Group Policy settings are not applied on member computers that are running Windows Server 2008 or Windows Vista SP1 when certain SMB signing policies are enabled](https://support.microsoft.com/en-us/kb/950876)."
                    Vulnerability = "Session hijacking uses tools that allow attackers who have access to the same network as the client or server to interrupt, end, or steal a session in progress. Attackers can potentially intercept and modify unsigned SMB packets and then modify the traffic and forward it so that the server might perform undesirable actions. Alternatively, the attacker could pose as the server or client after legitimate authentication and gain unauthorized access to data. SMB is the resource sharing protocol that is supported by many Windows operating systems. It is the basis of NetBIOS and many other protocols. SMB signatures authenticate both users and the servers that host the data. If either side fails the authentication process, data transmission will not take place."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "b625a003_d015_436e_89fb_fb2dfe71ae0f" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network server: Digitally sign communications ' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether the SMB server will negotiate SMB packet signing with clients that request it. If no signing request comes from the client, a connection will be allowed without a signature if the **Microsoft network server: Digitally sign communications (always)** setting is not enabled. **Note:** Enable this policy setting on SMB clients on your network to make them fully effective for packet signing with all clients and servers in your environment. The recommended state for this setting is: Enabled."
                    PotentialImpact = "The Microsoft network server will negotiate SMB packet signing as requested by the client. That is, if packet signing has been enabled on the client, packet signing will be negotiated. The Windows 2000 Server, Windows 2000 Professional, Windows Server 2003, Windows XP Professional and Windows Vista implementations of the SMB file and print sharing protocol support mutual authentication, which prevents session hijacking attacks and supports message authentication to prevent man-in-the-middle attacks. SMB signing provides this authentication by placing a digital signature into each SMB, which is then verified by both the client and the server. Implementation of SMB signing may negatively affect performance, because each packet needs to be signed and verified. If these settings are enabled on a server that is performing multiple roles, such as a small business server that is serving as a domain controller, file server, print server, and application server performance may be substantially slowed. Additionally, if you configure computers to ignore all unsigned SMB communications, older applications and operating systems will not be able to connect. However, if you completely disable all SMB signing, computers will be vulnerable to session hijacking attacks. When SMB signing policies are enabled on domain controllers running Windows Server 2003 and member computers running Windows Vista SP1 or Windows Server 2008 group policy processing will fail. A hotfix is available from Microsoft that resolves this issue; see Microsoft Knowledge Base article 950876 for more details: [Group Policy settings are not applied on member computers that are running Windows Server 2008 or Windows Vista SP1 when certain SMB signing policies are enabled](https://support.microsoft.com/en-us/kb/950876)."
                    Vulnerability = "Session hijacking uses tools that allow attackers who have access to the same network as the client or server to interrupt, end, or steal a session in progress. Attackers can potentially intercept and modify unsigned SMB packets and then modify the traffic and forward it so that the server might perform undesirable actions. Alternatively, the attacker could pose as the server or client after legitimate authentication and gain unauthorized access to data. SMB is the resource sharing protocol that is supported by many Windows operating systems. It is the basis of NetBIOS and many other protocols. SMB signatures authenticate both users and the servers that host the data. If either side fails the authentication process, data transmission will not take place."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "32899900_6b73_4cdd_906d_702e00bae698" = @{
                    RuleId = ""
                    Name = " Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'"
                    FullDescription = "This security setting determines whether to disconnect users who are connected to the local computer outside their user account's valid logon hours. This setting affects the Server Message Block (SMB) component. If you enable this policy setting you should also enable **Network security: Force logoff when logon hours expire** (Rule 2.3.11.6). If your organization configures logon hours for users, this policy setting is necessary to ensure they are effective. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration. If logon hours are not used in your organization, this policy setting will have no impact. If logon hours are used, existing user sessions will be forcibly terminated when their logon hours expire."
                    Vulnerability = "If your organization configures logon hours for users, then it makes sense to enable this policy setting. Otherwise, users who should not have access to network resources outside of their logon hours may actually be able to continue to use those resources with sessions that were established during allowed hours."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "8191B0F8_0855_491F_9DED_7260DC79AF3E" = @{
                    RuleId = ""
                    Name = "Ensure 'Minimize the number of simultaneous connections to the Internet or a Windows Domain' is set to 'Enabled'"
                    FullDescription = "This policy setting prevents computers from connecting to both a domain based network and a non-domain based network at the same time. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Blocking simultaneous connections can help prevent a user unknowingly allowing network traffic to flow between the Internet and the corporate network."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "87822480_3af9_4cf1_b0d2_93ceb957b129" = @{
                    RuleId = ""
                    Name = " Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' is set to 'Enabled' "
                    FullDescription = "This policy setting controls the ability of anonymous users to enumerate SAM accounts as well as shares. If you enable this policy setting, anonymous users will not be able to enumerate domain account user names and network share names on the systems in your environment. The recommended state for this setting is: Enabled. **Note:** This policy has no effect on domain controllers."
                    PotentialImpact = "It will be impossible to establish trusts with Windows NT 4.0-based domains. Also, client computers that run older versions of the Windows operating system such as Windows NT 3.51 and Windows 95 will experience problems when they try to use resources on the server. Users who access file and print servers anonymously will be unable to list the shared network resources on those servers; the users will have to authenticate before they can view the lists of shared folders and printers. However, even with this policy setting enabled, anonymous users will have access to resources with permissions that explicitly include the built-in group, ANONYMOUS LOGON."
                    Vulnerability = "An unauthorized user could anonymously list account names and shared resources and use the information to attempt to guess passwords or perform social engineering attacks. (Social engineering attacks try to deceive users in some way to obtain passwords or some form of security information.)"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "9503a7be_372f_4591_9dcd_f7de48b7f7e8" = @{
                    RuleId = ""
                    Name = " Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled' "
                    FullDescription = "This policy setting controls the ability of anonymous users to enumerate the accounts in the Security Accounts Manager (SAM). If you enable this policy setting, users with anonymous connections will not be able to enumerate domain account user names on the systems in your environment. This policy setting also allows additional restrictions on anonymous connections. The recommended state for this setting is: Enabled. **Note:** This policy has no effect on domain controllers."
                    PotentialImpact = "None - this is the default configuration. It will be impossible to establish trusts with Windows NT 4.0-based domains. Also, client computers that run older versions of the Windows operating system such as Windows NT 3.51 and Windows 95 will experience problems when they try to use resources on the server."
                    Vulnerability = "An unauthorized user could anonymously list account names and use the information to attempt to guess passwords or perform social engineering attacks. (Social engineering attacks try to deceive users in some way to obtain passwords or some form of security information.)"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "f97fe90f_c009_4139_8562_9893e9c49b44" = @{
                    RuleId = ""
                    Name = " Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'"
                    FullDescription = "This policy setting determines what additional permissions are assigned for anonymous connections to the computer. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "An unauthorized user could anonymously list account names and shared resources and use the information to attempt to guess passwords, perform social engineering attacks, or launch DoS attacks."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "f55109a7_2248_4c55_a7b0_bebdcb9530d5" = @{
                    RuleId = ""
                    Name = " Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'"
                    FullDescription = "When enabled, this policy setting restricts anonymous access to only those shares and pipes that are named in the Network access: Named pipes that can be accessed anonymously and Network access: Shares that can be accessed anonymously settings. This policy setting controls null session access to shares on your computers by adding RestrictNullSessAccess with the value 1 in the HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters registry key. This registry value toggles null session shares on or off to control whether the server service restricts unauthenticated clients' access to named resources. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration. If you choose to enable this setting and are supporting Windows NT 4.0 domains, you should check if any of the named pipes are required to maintain trust relationships between the domains, and then add the pipe to the **Network access: Named pipes that can be accessed anonymously** list: \- COMNAP: SNA session access \- COMNODE: SNA session access \- SQL\\QUERY: SQL instance access \- SPOOLSS: Spooler service \- LLSRPC: License Logging service \- NETLOGON: Net Logon service \- LSARPC: LSA access \- SAMR: Remote access to SAM objects \- BROWSER: Computer Browser service Previous to the release of Windows Server 2003 with Service Pack 1 (SP1) these named pipes were allowed anonymous access by default, but with the increased hardening in Windows Server 2003 with SP1 these pipes must be explicitly added if needed."
                    Vulnerability = "Null sessions are a weakness that can be exploited through shares (including the default shares) on computers in your environment."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "E4C0C45F_6A72_4E66_B792_32A4EBF36F1C" = @{
                    RuleId = ""
                    Name = "Ensure 'Network access: Restrict clients allowed to make remote calls to SAM' is set to 'Administrators: Remote Access: Allow' (MS only)"
                    FullDescription = "This policy setting allows you to restrict remote RPC connections to SAM.

If not selected, the default security descriptor will be used.

This policy is supported on at least Windows Server 2016."
                    PotentialImpact = "Depending on configuration, users may be unable to run certain apps requiring remote access to the SAM."
                    Vulnerability = "A malicious agent could remotely access the SAM and discover confidential information."
                    Enabled = $true
                    ExpectedValue = "O:BAG:BAD:(A;;RC;;;BA)"
                    }
        "EE6B9D20_8C62_4F14_8719_A425E09244ED" = @{
                    RuleId = ""
                    Name = "Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'"
                    FullDescription = "This policy setting determines which network shares can be accessed by anonymous users. The default configuration for this policy setting has little effect because all users have to be authenticated before they can access shared resources on the server.
Note: It can be very dangerous to add other shares to this Group Policy setting. Any network user can access any shares that are listed, which could exposure or corrupt sensitive data.
Note: When you configure this setting, you specify a list of one or more objects. The delimiter used when entering the list is a line feed or carriage return, that is, type the first object on the list, press the Enter button, type the next object, press Enter again, etc. The setting value is stored as a comma-delimited list in group policy security templates. It is also rendered as a comma-delimited list in Group Policy Editor's display pane and the Resultant Set of Policy console. It is recorded in the registry as a line-feed delimited list in a REG_MULTI_SZ value."
                    PotentialImpact = "There should be little impact because this is the default configuration. Only authenticated users will have access to shared resources on the server."
                    Vulnerability = "It is very dangerous to enable this setting. Any shares that are listed can be accessed by any network user, which could lead to the exposure or corruption of sensitive data."
                    Enabled = $true
                    ExpectedValue = ""
                    }
        "3e42b5fc_08b2_4a9a_ad80_dafe9033cbc3" = @{
                    RuleId = ""
                    Name = " Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'"
                    FullDescription = "This policy setting determines how network logons that use local accounts are authenticated. The Classic option allows precise control over access to resources, including the ability to assign different types of access to different users for the same resource. The Guest only option allows you to treat all users equally. In this context, all users authenticate as Guest only to receive the same access level to a given resource. The recommended state for this setting is: Classic - local users authenticate as themselves. **Note:** This setting does not affect interactive logons that are performed remotely by using such services as Telnet or Remote Desktop Services (formerly called Terminal Services)."
                    PotentialImpact = "None - this is the default configuration for domain-joined computers."
                    Vulnerability = "With the Guest only model, any user who can authenticate to your computer over the network does so with guest privileges, which probably means that they will not have write access to shared resources on that computer. Although this restriction does increase security, it makes it more difficult for authorized users to access shared resources on those computers because ACLs on those resources must include access control entries (ACEs) for the Guest account. With the Classic model, local accounts should be password protected. Otherwise, if Guest access is enabled, anyone can use those user accounts to access shared system resources."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "E7D5034F_5652_4180_90C8_C49130ACB3C6" = @{
                    RuleId = ""
                    Name = "Ensure 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled'"
                    FullDescription = "When enabled, this policy setting causes Local System services that use Negotiate to use the computer identity when NTLM authentication is selected by the negotiation.
This policy is supported on at least Windows 7 or Windows Server 2008 R2."
                    PotentialImpact = "If you enable this policy setting, services running as Local System that use Negotiate will use the computer identity. This might cause some authentication requests between Windows operating systems to fail and log an error.
If you disable this policy setting, services running as Local System that use Negotiate when reverting to NTLM authentication will authenticate anonymously. This was the behavior in previous versions of Windows."
                    Vulnerability = "When connecting to computers running versions of Windows earlier than Windows Vista or Windows Server 2008, services running as Local System and using SPNEGO (Negotiate) that revert to NTLM use the computer identity. In Windows 7, if you are connecting to a computer running Windows Server 2008 or Windows Vista, then a system service uses either the computer identity or a NULL session. When connecting with a NULL session, a system-generated session key is created, which provides no protection but allows applications to sign and encrypt data without errors. When connecting with the computer identity, both signing and encryption is supported in order to provide data protection."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "0b2803c7_33ac_4407_80f0_f09940bbe940" = @{
                    RuleId = ""
                    Name = " Ensure 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether NTLM is allowed to fall back to a NULL session when used with LocalSystem. The recommended state for this setting is: Disabled."
                    PotentialImpact = "Any applications that require NULL sessions for LocalSystem will not work as designed."
                    Vulnerability = "NULL sessions are less secure because by definition they are unauthenticated."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "8ad78d25_6140_4899_9565_e053ce7d9a66" = @{
                    RuleId = ""
                    Name = " Ensure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'"
                    FullDescription = "This setting determines if online identities are able to authenticate to this computer. The Public Key Cryptography Based User-to-User (PKU2U) protocol introduced in Windows 7 and Windows Server 2008 R2 is implemented as a security support provider (SSP). The SSP enables peer-to-peer authentication, particularly through the Windows 7 media and file sharing feature called Homegroup, which permits sharing between computers that are not members of a domain. With PKU2U, a new extension was introduced to the Negotiate authentication package, Spnego.dll. In previous versions of Windows, Negotiate decided whether to use Kerberos or NTLM for authentication. The extension SSP for Negotiate, Negoexts.dll, which is treated as an authentication protocol by Windows, supports Microsoft SSPs including PKU2U. When computers are configured to accept authentication requests by using online IDs, Negoexts.dll calls the PKU2U SSP on the computer that is used to log on. The PKU2U SSP obtains a local certificate and exchanges the policy between the peer computers. When validated on the peer computer, the certificate within the metadata is sent to the logon peer for validation and associates the user's certificate to a security token and the logon process completes. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration for domain-joined computers."
                    Vulnerability = "The PKU2U protocol is a peer-to-peer authentication protocol - authentication should be managed centrally in most managed networks."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "979AE5A3_DBA6_47B1_9644_7E74ED6D7EAE" = @{
                    RuleId = ""
                    Name = "Ensure 'Network Security: Configure encryption types allowed for Kerberos' is set to 'RC4_HMAC_MD5, AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'"
                    FullDescription = "This policy setting allows you to set the encryption types that Kerberos is allowed to use.
This policy is supported on at least Windows 7 or Windows Server 2008 R2."
                    PotentialImpact = "If not selected, the encryption type will not be allowed. This setting may affect compatibility with client computers or services and applications. Multiple selections are permitted."
                    Vulnerability = "The strength of each encryption algorithm varies from one to the next, choosing stronger algorithms will reduce the risk of compromise however doing so may cause issues when the computer attempts to authenticate with systems that do not support them."
                    Enabled = $true
                    ExpectedValue = "2147483640"
                    }
        "9170cd13_5ab9_4c68_8904_a88756b36c6e" = @{
                    RuleId = ""
                    Name = " Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether the LAN Manager (LM) hash value for the new password is stored when the password is changed. The LM hash is relatively weak and prone to attack compared to the cryptographically stronger Microsoft Windows NT hash. Since LM hashes are stored on the local computer in the security database, passwords can then be easily compromised if the database is attacked. **Note:** Older operating systems and some third-party applications may fail when this policy setting is enabled. Also, note that the password will need to be changed on all accounts after you enable this setting to gain the proper benefit. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration. Earlier operating systems such as Windows 95, Windows 98, and Windows ME as well as some third-party applications will fail."
                    Vulnerability = "The SAM file can be targeted by attackers who seek access to username and password hashes. Such attacks use special tools to crack passwords, which can then be used to impersonate users and gain access to resources on your network. These types of attacks will not be prevented if you enable this policy setting, but it will be much more difficult for these types of attacks to succeed."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "315CC7E3_7252_47CE_AF2F_9ABF243FAC16" = @{
                    RuleId = ""
                    Name = "Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'"
                    FullDescription = "LAN Manager (LM) is a family of early Microsoft client/server software that allows users to link personal computers together on a single network. Network capabilities include transparent file and print sharing, user security features, and network administration tools. In Active Directory domains, the Kerberos protocol is the default authentication protocol. However, if the Kerberos protocol is not negotiated for some reason, Active Directory will use LM, NTLM, or NTLMv2.
LAN Manager authentication includes the LM, NTLM, and NTLM version 2 (NTLMv2) variants, and is the protocol that is used to authenticate all Windows clients when they perform the following operations:
- Join a domain
- Authenticate between Active Directory forests
- Authenticate to down-level domains
- Authenticate to computers that do not run Windows 2000, Windows Server 2003, or Windows XP)
- Authenticate to computers that are not in the domain
The possible values for the Network security: LAN Manager authentication level settings are:
- Send LM & NTLM responses
- Send LM & NTLM   use NTLMv2 session security if negotiated
- Send NTLM responses only
- Send NTLMv2 responses only
- Send NTLMv2 responses only\refuse LM
- Send NTLMv2 responses only\refuse LM & NTLM
- Not Defined
The Network security: LAN Manager authentication level setting determines which challenge/response authentication protocol is used for network logons. This choice affects the authentication protocol level that clients use, the session security level that the computers negotiate, and the authentication level that servers accept as follows:
- Send LM & NTLM responses. Clients use LM and NTLM authentication and never use NTLMv2 session security. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Send LM & NTLM   use NTLMv2 session security if negotiated. Clients use LM and NTLM authentication and use NTLMv2 session security if the server supports it. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Send NTLM response only. Clients use NTLM authentication only and use NTLMv2 session security if the server supports it. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Send NTLMv2 response only. Clients use NTLMv2 authentication only and use NTLMv2 session security if the server supports it. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Send NTLMv2 response only\refuse LM. Clients use NTLMv2 authentication only and use NTLMv2 session security if the server supports it. Domain controllers refuse LM (accept only NTLM and NTLMv2 authentication).
- Send NTLMv2 response only\refuse LM & NTLM. Clients use NTLMv2 authentication only and use NTLMv2 session security if the server supports it. Domain controllers refuse LM and NTLM (accept only NTLMv2 authentication).
These settings correspond to the levels discussed in other Microsoft documents as follows:
- Level 0   Send LM and NTLM response; never use NTLMv2 session security. Clients use LM and NTLM authentication, and never use NTLMv2 session security. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Level 1   Use NTLMv2 session security if negotiated. Clients use LM and NTLM authentication, and use NTLMv2 session security if the server supports it. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Level 2   Send NTLM response only. Clients use only NTLM authentication, and use NTLMv2 session security if the server supports it. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Level 3   Send NTLMv2 response only. Clients use NTLMv2 authentication, and use NTLMv2 session security if the server supports it. Domain controllers accept LM, NTLM, and NTLMv2 authentication.
- Level 4   Domain controllers refuse LM responses. Clients use NTLM authentication, and use NTLMv2 session security if the server supports it. Domain controllers refuse LM authentication, that is, they accept NTLM and NTLMv2.
- Level 5   Domain controllers refuse LM and NTLM responses (accept only NTLMv2). Clients use NTLMv2 authentication, use and NTLMv2 session security if the server supports it. Domain controllers refuse NTLM and LM authentication (they accept only NTLMv2)."
                    PotentialImpact = "Clients that do not support NTLMv2 authentication will not be able to authenticate in the domain and access domain resources by using LM and NTLM."
                    Vulnerability = "In Windows Vista, this setting is undefined. However, in Windows 2000, Windows Server 2003, and Windows XP clients are configured by default to send LM and NTLM authentication responses (Windows 95-based and Windows 98-based clients only send LM). The default setting on servers allows all clients to authenticate with servers and use their resources. However, this means that LM responses the weakest form of authentication response are sent over the network, and it is potentially possible for attackers to sniff that traffic to more easily reproduce the user's password.
The Windows 95, Windows 98, and Windows NT operating systems cannot use the Kerberos version 5 protocol for authentication. For this reason, in a Windows Server 2003 domain, these computers authenticate by default with both the LM and NTLM protocols for network authentication. You can enforce a more secure authentication protocol for Windows 95, Windows 98, and Windows NT by using NTLMv2. For the logon process, NTLMv2 uses a secure channel to protect the authentication process. Even if you use NTLMv2 for earlier clients and servers, Windows-based clients and servers that are members of the domain will use the Kerberos authentication protocol to authenticate with Windows Server 2003 domain controllers."
                    Enabled = $true
                    ExpectedValue = "5"
                    }
        "4ff2ed85_48d7_4e38_bdb8_6c7df3286882" = @{
                    RuleId = ""
                    Name = " Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher"
                    FullDescription = "This policy setting determines the level of data signing that is requested on behalf of clients that issue LDAP BIND requests. **Note:** This policy setting does not have any impact on LDAP simple bind (ldap_simple_bind) or LDAP simple bind through SSL (ldap_simple_bind_s). No Microsoft LDAP clients that are included with Windows XP Professional use ldap_simple_bind or ldap_simple_bind_s to communicate with a domain controller. The recommended state for this setting is: Negotiate signing. Configuring this setting to Require signing also conforms with the benchmark."
                    PotentialImpact = "None - this is the default configuration. However, if you choose instead to configure the server to _require_ LDAP signatures then you must also configure the client. If you do not configure the client it will not be able to communicate with the server, which could cause many features to fail, including user authentication, Group Policy, and logon scripts, because the caller will be told that the LDAP BIND command request failed."
                    Vulnerability = "Unsigned network traffic is susceptible to man-in-the-middle attacks in which an intruder captures the packets between the client and server, modifies them, and then forwards them to the server. For an LDAP server, this susceptibility means that an attacker could cause a server to make decisions that are based on false or altered data from the LDAP queries. To lower this risk in your network, you can implement strong physical security measures to protect the network infrastructure. Also, you can make all types of man-in-the-middle attacks extremely difficult if you require digital signatures on all network packets by means of IPsec authentication headers."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "2a074d39_eee4_4bfe_b1e7_4132c033a762" = @{
                    RuleId = ""
                    Name = " Ensure 'Network security: Minimum session security for NTLM SSP based  clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption'"
                    FullDescription = "This policy setting determines which behaviors are allowed by clients for applications using the NTLM Security Support Provider (SSP). The SSP Interface (SSPI) is used by applications that need authentication services. The setting does not modify how the authentication sequence works but instead require certain behaviors in applications that use the SSPI. The recommended state for this setting is: Require NTLMv2 session security, Require 128-bit encryption. **Note:** These values are dependent on the _Network security: LAN Manager Authentication Level_ security setting value."
                    PotentialImpact = "NTLM connections will fail if NTLMv2 protocol and strong encryption (128-bit) are not **both** negotiated. Client applications that are enforcing these settings will be unable to communicate with older servers that do not support them. This setting could impact Windows Clustering when applied to servers running Windows Server 2003, see Microsoft Knowledge Base articles 891597: [How to apply more restrictive security settings on a Windows Server 2003-based cluster server](https://support.microsoft.com/en-us/kb/891597) and 890761: [You receive an Error 0x8007042b error message when you add or join a node to a cluster if you use NTLM version 2 in Windows Server 2003](https://support.microsoft.com/en-us/kb/890761) for more information on possible issues and how to resolve them."
                    Vulnerability = "You can enable both options for this policy setting to help protect network traffic that uses the NTLM Security Support Provider (NTLM SSP) from being exposed or tampered with by an attacker who has gained access to the same network. In other words, these options help protect against man-in-the-middle attacks."
                    Enabled = $true
                    ExpectedValue = "537395200"
                    }
        "6ed9ad58_c9de_4a8b_9512_8fe5421ac8a7" = @{
                    RuleId = ""
                    Name = " Ensure 'Network security: Minimum session security for NTLM SSP based  servers' is set to 'Require NTLMv2 session security, Require 128-bit encryption'"
                    FullDescription = "This policy setting determines which behaviors are allowed by servers for applications using the NTLM Security Support Provider (SSP). The SSP Interface (SSPI) is used by applications that need authentication services. The setting does not modify how the authentication sequence works but instead require certain behaviors in applications that use the SSPI. The recommended state for this setting is: Require NTLMv2 session security, Require 128-bit encryption. **Note:** These values are dependent on the _Network security: LAN Manager Authentication Level_ security setting value."
                    PotentialImpact = "NTLM connections will fail if NTLMv2 protocol and strong encryption (128-bit) are not **both** negotiated. Server applications that are enforcing these settings will be unable to communicate with older servers that do not support them. This setting could impact Windows Clustering when applied to servers running Windows Server 2003, see Microsoft Knowledge Base articles 891597: [How to apply more restrictive security settings on a Windows Server 2003-based cluster server](https://support.microsoft.com/en-us/kb/891597) and 890761: [You receive an Error 0x8007042b error message when you add or join a node to a cluster if you use NTLM version 2 in Windows Server 2003](https://support.microsoft.com/en-us/kb/890761) for more information on possible issues and how to resolve them."
                    Vulnerability = "You can enable all of the options for this policy setting to help protect network traffic that uses the NTLM Security Support Provider (NTLM SSP) from being exposed or tampered with by an attacker who has gained access to the same network. That is, these options help protect against man-in-the-middle attacks."
                    Enabled = $true
                    ExpectedValue = "537395200"
                    }
        "21C5BCB7_432E_4EAA_A01A_0CDA8DB73E62" = @{
                    RuleId = ""
                    Name = "Ensure 'Prevent downloading of enclosures' is set to 'Enabled'"
                    FullDescription = "This policy setting prevents the user from having enclosures (file attachments) downloaded from a feed to the user's computer. The recommended state for this setting is: Enabled."
                    PotentialImpact = "Users cannot set the Feed Sync Engine to download an enclosure through the Feed property page. Developers cannot change the download setting through feed APIs."
                    Vulnerability = "Allowing attachments to be downloaded through the RSS feed can introduce files that could have malicious intent."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "357272d2_2018_455e_935c_8777473661dd" = @{
                    RuleId = ""
                    Name = " Ensure 'Prohibit installation and configuration of Network Bridge on your DNS domain network' is set to 'Enabled'"
                    FullDescription = "You can use this procedure to control user's ability to install and configure a network bridge. The recommended state for this setting is: Enabled."
                    PotentialImpact = "Users cannot create or configure a network bridge."
                    Vulnerability = "The Network Bridge setting, if enabled, allows users to create a Layer 2 Media Access Control (MAC) bridge, enabling them to connect two or more physical network segments together. A network bridge thus allows a computer that has connections to two different networks to share data between those networks. In an enterprise environment, where there is a need to control network traffic to only authorized paths, allowing users to create a network bridge increases the risk and attack surface from the bridged network."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "4b2ea54f_7c16_4490_8687_cc52c3135b7e" = @{
                    RuleId = ""
                    Name = " Ensure 'Prohibit use of Internet Connection Sharing on your DNS domain network' is set to 'Enabled'"
                    FullDescription = "Although this legacy setting traditionally applied to the use of Internet Connection Sharing (ICS) in Windows 2000, Windows XP & Server 2003, this setting now freshly applies to the Mobile Hotspot feature in Windows 10 & Server 2016. The recommended state for this setting is: Enabled."
                    PotentialImpact = "Mobile Hotspot cannot be enabled or configured by Administrators and non-Administrators alike."
                    Vulnerability = "Non-administrators should not be able to turn on the Mobile Hotspot feature and open their Internet connectivity up to nearby mobile devices."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "01D9A108_3379_4C5A_8236_1A724BCCCFF1" = @{
                    RuleId = ""
                    Name = "Ensure 'Require secure RPC communication' is set to 'Enabled'"
                    FullDescription = "Specifies whether a Remote Desktop Session Host server requires secure RPC communication with all clients or allows unsecured communication.

You can use this setting to strengthen the security of RPC communication with clients by allowing only authenticated and encrypted requests.

If the status is set to Enabled, Remote Desktop Services accepts requests from RPC clients that support secure requests, and does not allow unsecured communication with untrusted clients.

If the status is set to Disabled, Remote Desktop Services always requests security for all RPC traffic. However, unsecured communication is allowed for RPC clients that do not respond to the request.

If the status is set to Not Configured, unsecured communication is allowed.

Note: The RPC interface is used for administering and configuring Remote Desktop Services."
                    PotentialImpact = "Remote Desktop Services  does not allow unsecured communication."
                    Vulnerability = "Disabling this setting can compromise security as unsecured communication is allowed for RPC clients that do not respond to security requests."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "1B1DCDBF_D949_44DA_B942_0FC2EB225985" = @{
                    RuleId = ""
                    Name = "Ensure 'Security: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
                    FullDescription = "This policy setting controls Event Log behavior when the log file reaches its maximum size.

If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events.

Note: Old events may or may not be retained according to the Backup log automatically when full policy setting."
                    PotentialImpact = "If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events."
                    Vulnerability = "If new events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "C139DB2E_8DEA_418E_BF7C_372EC0278E31" = @{
                    RuleId = ""
                    Name = "Ensure 'Security: Specify the maximum log file size (KB)' is set to 'Enabled: 196,608 or greater'"
                    FullDescription = "This policy setting specifies the maximum size of the log file in kilobytes.

If you enable this policy setting, you can configure the maximum log file size to be between 1 megabyte (1024 kilobytes) and 2 terabytes (2,147,483,647 kilobytes) in kilobyte increments.

If you disable or do not configure this policy setting, the maximum size of the log file will be set to the locally configured value. This value can be changed by the local administrator using the Log Properties dialog and it defaults to 20 megabytes."
                    PotentialImpact = "When event logs fill to capacity, they will stop recording information unless the retention method for each is set so that the computer will overwrite the oldest entries with the most recent ones. To mitigate the risk of loss of recent data, you can configure the retention method so that older events are overwritten as needed.
The consequence of this configuration is that older events will be removed from the logs. Attackers can take advantage of such a configuration, because they can generate a large number of extraneous events to overwrite any evidence of their attack. These risks can be somewhat reduced if you automate the archival and backup of event log data. 
Ideally, all specifically monitored events should be sent to a server that uses Microsoft Operations Manager (MOM) or some other automated monitoring tool. Such a configuration is particularly important because an attacker who successfully compromises a server could clear the Security log. If all events are sent to a monitoring server, then you will be able to gather forensic information about the attacker's activities."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "196608"
                    }
        "93C677E7_E7C8_49C4_BB46_D40DAD88F17B" = @{
                    RuleId = ""
                    Name = "Ensure 'Set client connection encryption level' is set to 'Enabled: High Level'"
                    FullDescription = "This policy setting specifies whether the computer that is about to host the remote connection will enforce an encryption level for all data sent between it and the client computer for the remote session."
                    PotentialImpact = "Clients that do not support 128-bit encryption will be unable to establish Terminal Server sessions."
                    Vulnerability = "If Terminal Server client connections are allowed that use low level encryption, it is more likely that an attacker will be able to decrypt any captured Terminal Services network traffic."
                    Enabled = $true
                    ExpectedValue = "3"
                    }
        "7869DDEF_04AB_4CC5_90F2_5E6FD1540CBA" = @{
                    RuleId = ""
                    Name = "Ensure 'Set the default behavior for AutoRun' is set to 'Enabled: Do not execute any autorun commands'"
                    FullDescription = "This policy setting sets the default behavior for Autorun commands.

          Autorun commands are generally stored in autorun.inf files. They often launch the installation program or other routines.

          Prior to Windows Vista, when media containing an autorun command is inserted, the system will automatically execute the program without user intervention.

          This creates a major security concern as code may be executed without user's knowledge. The default behavior starting with Windows Vista is to prompt the user whether autorun command is to be run. The autorun command is represented as a handler in the Autoplay dialog.

          If you enable this policy setting, an Administrator can change the default Windows Vista or later behavior for autorun to:

          a) Completely disable autorun commands, or
          b) Revert back to pre-Windows Vista behavior of automatically executing the autorun command.

          If you disable or not configure this policy setting, Windows Vista or later will prompt the user whether autorun command is to be run."
                    PotentialImpact = "Autorun commands will not start automatically."
                    Vulnerability = "Disabling or not configuring this setting may compromise security as malware may be executed without the user's approval."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "31F0541C_879F_473D_BF6B_E0AEF89F0B45" = @{
                    RuleId = ""
                    Name = "Ensure 'Setup: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
                    FullDescription = "This policy setting controls Event Log behavior when the log file reaches its maximum size.

If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events.

Note: Old events may or may not be retained according to the Backup log automatically when full policy setting."
                    PotentialImpact = "If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events."
                    Vulnerability = "If new events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "5BFB71C2_897F_4CCB_B7D5_7181B1F2527A" = @{
                    RuleId = ""
                    Name = "Ensure 'Setup: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'"
                    FullDescription = "This policy setting specifies the maximum size of the log file in kilobytes.

If you enable this policy setting, you can configure the maximum log file size to be between 1 megabyte (1024 kilobytes) and 2 terabytes (2,147,483,647 kilobytes) in kilobyte increments.

If you disable or do not configure this policy setting, the maximum size of the log file will be set to the locally configured value. This value can be changed by the local administrator using the Log Properties dialog and it defaults to 20 megabytes."
                    PotentialImpact = "Enable this policy setting and select 32768."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "32768"
                    }
        "fa4d7c0b_987e_47f6_bf8b_f38f49e7c00b" = @{
                    RuleId = ""
                    Name = " Ensure 'Shutdown: Allow system to be shut down without having to log on' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether a computer can be shut down when a user is not logged on. If this policy setting is enabled, the shutdown command is available on the Windows logon screen. It is recommended to disable this policy setting to restrict the ability to shut down the computer to users with credentials on the system. The recommended state for this setting is: Disabled. **Note:** In Server 2008 R2 and older versions, this setting had no impact on Remote Desktop (RDP) / Terminal Services sessions - it only affected the local console. However, Microsoft changed the behavior in Windows Server 2012 (non-R2) and above, where if set to Enabled, RDP sessions are also allowed to shut down or restart the server."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users who can access the console locally could shut down the computer. Attackers could also walk to the local console and restart the server, which would cause a temporary DoS condition. Attackers could also shut down the server and leave all of its applications and services unavailable. As noted in the Description above, the Denial of Service (DoS) risk of enabling this setting dramatically increases in Windows Server 2012 (non-R2) and above, as even remote users can shut down or restart the server."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "b784a87e_4aa2_4f61_8b3f_38abff6dac22" = @{
                    RuleId = ""
                    Name = " Ensure 'Sign-in last interactive user automatically after a system-initiated restart' is set to 'Disabled'"
                    FullDescription = "This policy setting controls whether a device will automatically sign-in the last interactive user after Windows Update restarts the system. The recommended state for this setting is: Disabled."
                    PotentialImpact = "The device does not store the user's credentials for automatic sign-in after a Windows Update restart. The users' lock screen apps are not restarted after the system restarts. The user is required to present the logon credentials in order to proceed after restart."
                    Vulnerability = "Disabling this feature will prevent the caching of user's credentials and unauthorized use of the device, and also ensure the user is aware of the restart."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "0be33574_5e6c_4cfe_8b84_18819338eb6e" = @{
                    RuleId = ""
                    Name = " Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether case insensitivity is enforced for all subsystems. The Microsoft Win32 subsystem is case insensitive. However, the kernel supports case sensitivity for other subsystems, such as the Portable Operating System Interface for UNIX (POSIX). Because Windows is case insensitive (but the POSIX subsystem will support case sensitivity), failure to enforce this policy setting makes it possible for a user of the POSIX subsystem to create a file with the same name as another file by using mixed case to label it. Such a situation can block access to these files by another user who uses typical Win32 tools, because only one of the files will be available. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Because Windows is case-insensitive but the POSIX subsystem will support case sensitivity, failure to enable this policy setting would make it possible for a user of that subsystem to create a file with the same name as another file but with a different mix of upper and lower case letters. Such a situation could potentially confuse users when they try to access such files from normal Win32 tools because only one of the files will be available."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "8db231ff_6c9a_46f8_84de_ebea4507ffe9" = @{
                    RuleId = ""
                    Name = " Ensure 'System objects: Strengthen default permissions of internal system objects ' is set to 'Enabled'"
                    FullDescription = "This policy setting determines the strength of the default discretionary access control list (DACL) for objects. Active Directory maintains a global list of shared system resources, such as DOS device names, mutexes, and semaphores. In this way, objects can be located and shared among processes. Each type of object is created with a default DACL that specifies who can access the objects and what permissions are granted. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "This setting determines the strength of the default DACL for objects. Windows maintains a global list of shared computer resources so that objects can be located and shared among processes. Each type of object is created with a default DACL that specifies who can access the objects and with what permissions."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "8656ED1C_72E2_4D49_811B_AAEC42521AE0" = @{
                    RuleId = ""
                    Name = "Ensure 'System: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
                    FullDescription = "This policy setting controls Event Log behavior when the log file reaches its maximum size.

If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events.

Note: Old events may or may not be retained according to the Backup log automatically when full policy setting."
                    PotentialImpact = "If you enable this policy setting and a log file reaches its maximum size, new events are not written to the log and are lost.

If you disable or do not configure this policy setting and a log file reaches its maximum size, new events overwrite old events."
                    Vulnerability = "If new events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "3E20B64C_0356_4E95_BA4E_2EBD51E10BB9" = @{
                    RuleId = ""
                    Name = "Ensure 'System: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'"
                    FullDescription = "This policy setting specifies the maximum size of the log file in kilobytes.

If you enable this policy setting, you can configure the maximum log file size to be between 1 megabyte (1024 kilobytes) and 2 terabytes (2,147,483,647 kilobytes) in kilobyte increments.

If you disable or do not configure this policy setting, the maximum size of the log file will be set to the locally configured value. This value can be changed by the local administrator using the Log Properties dialog and it defaults to 20 megabytes."
                    PotentialImpact = "When event logs fill to capacity, they will stop recording information unless the retention method for each is set so that the computer will overwrite the oldest entries with the most recent ones. To mitigate the risk of loss of recent data, you can configure the retention method so that older events are overwritten as needed.
The consequence of this configuration is that older events will be removed from the logs. Attackers can take advantage of such a configuration, because they can generate a large number of extraneous events to overwrite any evidence of their attack. These risks can be somewhat reduced if you automate the archival and backup of event log data. 
Ideally, all specifically monitored events should be sent to a server that uses Microsoft Operations Manager (MOM) or some other automated monitoring tool. Such a configuration is particularly important because an attacker who successfully compromises a server could clear the Security log. If all events are sent to a monitoring server, then you will be able to gather forensic information about the attacker's activities."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users"
                    Enabled = $true
                    ExpectedValue = "32768"
                    }
        "BEA7AFF2_DB2D_4DB7_BF47_0E475DB398A3" = @{
                    RuleId = ""
                    Name = "Ensure 'Turn off app notifications on the lock screen' is set to 'Enabled'"
                    FullDescription = "This policy setting allows you to prevent app notifications from appearing on the lock screen. The recommended state for this setting is: Enabled."
                    PotentialImpact = "No app notifications are displayed on the lock screen."
                    Vulnerability = "App notifications might display sensitive business or personal data."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "D0F025AF_B24B_49AB_9B75_60F485ED5407" = @{
                    RuleId = ""
                    Name = "Ensure 'Turn off Autoplay' is set to 'Enabled: All drives'"
                    FullDescription = "Autoplay starts to read from a drive as soon as you insert media in the drive, which causes the setup file for programs or audio media to start immediately. An attacker could use this feature to launch a program to damage the computer or data on the computer. You can enable the Turn off Autoplay setting to disable the Autoplay feature. Autoplay is disabled by default on some removable drive types, such as floppy disk and network drives, but not on CD-ROM drives.

Note   You cannot use this policy setting to enable Autoplay on computer drives in which it is disabled by default, such as floppy disk and network drives."
                    PotentialImpact = "Users will have to manually launch setup or installation programs that are provided on removable media."
                    Vulnerability = "An attacker could use this feature to launch a program to damage a client computer or data on the computer."
                    Enabled = $true
                    ExpectedValue = "255"
                    }
        "b2538b69_4020_4d50_9f63_581b673a014c" = @{
                    RuleId = ""
                    Name = " Ensure 'Turn off Data Execution Prevention for Explorer' is set to 'Disabled'"
                    FullDescription = "Disabling data execution prevention can allow certain legacy plug-in applications to function without terminating Explorer. The recommended state for this setting is: Disabled. **Note:** Some legacy plug-in applications and other software may not function with Data Execution Prevention and will require an exception to be defined for that specific plug-in/software."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Data Execution Prevention is an important security feature supported by Explorer that helps to limit the impact of certain types of malware."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "7B2C4A66_7E3A_421E_9E2B_CCB11762B20E" = @{
                    RuleId = ""
                    Name = "Ensure 'Turn off downloading of print drivers over HTTP' is set to 'Enabled'"
                    FullDescription = "This policy setting controls whether the computer can download print driver packages over HTTP. To set up HTTP printing, printer drivers that are not available in the standard operating system installation might need to be downloaded over HTTP. The recommended state for this setting is: Enabled."
                    PotentialImpact = "Print drivers cannot be downloaded over HTTP. **Note:** This policy setting does not prevent the client computer from printing to printers on the intranet or the Internet over HTTP. It only prohibits downloading drivers that are not already installed locally."
                    Vulnerability = "Users might download drivers that include malicious code."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "a76d6552_cd22_4a2c_adc1_50f8705cad17" = @{
                    RuleId = ""
                    Name = " Ensure 'Turn off heap termination on corruption' is set to 'Disabled'"
                    FullDescription = "Without heap termination on corruption, legacy plug-in applications may continue to function when a File Explorer session has become corrupt. Ensuring that heap termination on corruption is active will prevent this. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Allowing an application to function after its session has become corrupt increases the risk posture to the system."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "0571E435_5C84_48BB_B1C9_6E7EAE13715A" = @{
                    RuleId = ""
                    Name = "Ensure 'Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com' is set to 'Enabled'"
                    FullDescription = "This policy setting specifies whether the Internet Connection Wizard can connect to Microsoft to download a list of Internet Service Providers (ISPs). The recommended state for this setting is: Enabled."
                    PotentialImpact = "The Choose a list of Internet Service Providers path in the Internet Connection Wizard causes the wizard to exit. This prevents users from retrieving the list of ISPs, which resides on Microsoft servers."
                    Vulnerability = "In an Enterprise environment we want to lower the risk of a user unknowingly exposing sensitive data."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "4E4D02FA_8F06_4DD3_A443_CCE86DD8FB19" = @{
                    RuleId = ""
                    Name = "Ensure 'Turn off Microsoft consumer experiences' is set to 'Enabled'"
                    FullDescription = "This policy setting turns off experiences that help consumers make the most of their devices and Microsoft account.

If you enable this policy setting, users will no longer see personalized recommendations from Microsoft and notifications about their Microsoft account.

If you disable or do not configure this policy setting, users may see suggestions from Microsoft and notifications about their Microsoft account.

Note: This setting only applies to Enterprise and Education SKUs."
                    PotentialImpact = "Users will no longer see personalized recommendations from Microsoft and notifications about their Microsoft account."
                    Vulnerability = "Disabling or not configuring this setting allows users to see suggestions from Microsoft and notifications about their Microsoft account, which may not meet the security requirements of your organization."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "94276972_D64D_43BC_AE92_8B609F2D114B" = @{
                    RuleId = ""
                    Name = "Ensure 'Turn off multicast name resolution' is set to 'Enabled' (MS Only)"
                    FullDescription = "LLMNR is a secondary name resolution protocol. With LLMNR, queries are sent using multicast over a local network link on a single subnet from a client computer to another client computer on the same subnet that also has LLMNR enabled. LLMNR does not require a DNS server or DNS client configuration, and provides name resolution in scenarios in which conventional DNS name resolution is not possible. The recommended state for this setting is: Enabled."
                    PotentialImpact = "In the event DNS is unavailable a system will be unable to request it from other systems on the same subnet."
                    Vulnerability = "An attacker can listen on a network for these LLMNR (UDP-5355) or NBT-NS (UDP-137) broadcasts and respond to them. It can trick the host into thinking that it knows the location of the requested system. **Note:** To completely mitigate local name resolution poisoning, in addition to this setting, the properties of each installed NIC should also be set to Disable NetBIOS over TCP-IP (on the WINS tab in the NIC properties). Unfortunately, there is no global setting to achieve this that automatically applies to all NICs - it is a per NIC setting that varies with different NIC hardware installations."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "94cc076f_0e88_4398_ac29_d0dc7170303f" = @{
                    RuleId = ""
                    Name = " Ensure 'Turn off shell protocol protected mode' is set to 'Disabled'"
                    FullDescription = "This policy setting allows you to configure the amount of functionality that the shell protocol can have. When using the full functionality of this protocol applications can open folders and launch files. The protected mode reduces the functionality of this protocol allowing applications to only open a limited set of folders. Applications are not able to open files with this protocol when it is in the protected mode. It is recommended to leave this protocol in the protected mode to increase the security of Windows. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Limiting the opening of files and folders to a limited set reduces the attack surface of the system."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "37e5e1d9_b9d2_454b_bf3f_124682309155" = @{
                    RuleId = ""
                    Name = " Ensure 'Turn on convenience PIN sign-in' is set to 'Disabled'"
                    FullDescription = "This policy setting allows you to control whether a domain user can sign in using a convenience PIN. In Windows 10, convenience PIN was replaced with Passport, which has stronger security properties. To configure Passport for domain users, use the policies under Computer configuration\\Administrative Templates\\Windows Components\\Microsoft Passport for Work. **Note:** The user's domain password will be cached in the system vault when using this feature. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "A PIN is created from a much smaller selection of characters than a password, so in most cases a PIN will be much less robust than a password."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "967531f7_69cd_4a38_a517_3ebf4e5284cd" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is set to 'Enabled'"
                    FullDescription = "This policy setting controls the behavior of Admin Approval Mode for the built-in Administrator account. The recommended state for this setting is: Enabled."
                    PotentialImpact = "The built-in Administrator account uses Admin Approval Mode. Users that log on using the local Administrator account will be prompted for consent whenever a program requests an elevation in privilege, just like any other user would."
                    Vulnerability = "One of the risks that the User Account Control feature introduced with Windows Vista is trying to mitigate is that of malicious software running under elevated credentials without the user or administrator being aware of its activity. An attack vector for these programs was to discover the password of the account named Administrator because that user account was created for all installations of Windows. To address this risk, in Windows Vista and newer, the built-in Administrator account is now disabled by default. In a default installation of a new computer, accounts with administrative control over the computer are initially set up in one of two ways: - If the computer is not joined to a domain, the first user account you create has the equivalent permissions as a local administrator. - If the computer is joined to a domain, no local administrator accounts are created. The Enterprise or Domain Administrator must log on to the computer and create one if a local administrator account is warranted. Once Windows is installed, the built-in Administrator account may be manually enabled, but we strongly recommend that this account remain disabled."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "467c29d0_b1be_4113_937c_65583cedf2f0" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop' is set to 'Disabled'"
                    FullDescription = "This policy setting controls whether User Interface Accessibility (UIAccess or UIA) programs can automatically disable the secure desktop for elevation prompts used by a standard user. The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "One of the risks that the UAC feature introduced with Windows Vista is trying to mitigate is that of malicious software running under elevated credentials without the user or administrator being aware of its activity. This setting allows the administrator to perform operations that require elevated privileges while connected via Remote Assistance. This increases security in that organizations can use UAC even when end user support is provided remotely. However, it also reduces security by adding the risk that an administrator might allow an unprivileged user to share elevated privileges for an application that the administrator needs to use during the Remote Desktop session."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "fc8a4401_ff7a_4a6d_add4_758acce6b76c" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop'"
                    FullDescription = "This policy setting controls the behavior of the elevation prompt for administrators. The recommended state for this setting is: Prompt for consent on the secure desktop."
                    PotentialImpact = "When an operation (including execution of a Windows binary) requires elevation of privilege, the user is prompted on the secure desktop to select either Permit or Deny. If the user selects Permit, the operation continues with the user's highest available privilege."
                    Vulnerability = "One of the risks that the UAC feature introduced with Windows Vista is trying to mitigate is that of malicious software running under elevated credentials without the user or administrator being aware of its activity. This setting raises awareness to the administrator of elevated privilege operations and permits the administrator to prevent a malicious program from elevating its privilege when the program attempts to do so."
                    Enabled = $true
                    ExpectedValue = "2"
                    }
        "ea132d56_9c29_4d2a_bc92_fc81f616e540" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'"
                    FullDescription = "This policy setting controls the behavior of the elevation prompt for standard users. The recommended state for this setting is: Automatically deny elevation requests."
                    PotentialImpact = "When an operation requires elevation of privilege, a configurable access denied error message is displayed. An enterprise that is running desktops as standard user may choose this setting to reduce help desk calls. **Note:** With this setting configured as recommended, the default error message displayed when a user attempts to perform an operation or run a program requiring privilege elevation (without Administrator rights) is _This program will not run. This program is blocked by group policy. For more information, contact your system administrator._ Some users who are not used to seeing this message may believe that the operation or program they attempted is specifically blocked by group policy, as that is what the message seems to imply. This message may therefore result in user questions as to why that specific operation/program is blocked, when in fact, the problem is that they need to perform the operation or run the program with an Administrative account (or Run as Administrator if it _is_ already an Administrator account), and they are not doing that."
                    Vulnerability = "One of the risks that the User Account Control feature introduced with Windows Vista is trying to mitigate is that of malicious programs running under elevated credentials without the user or administrator being aware of their activity. This setting raises awareness to the user that a program requires the use of elevated privilege operations and requires that the user be able to supply administrative credentials in order for the program to run."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "19a185ff_1009_4079_937a_dace5e3c2f50" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'"
                    FullDescription = "This policy setting controls the behavior of application installation detection for the computer. The recommended state for this setting is: Enabled."
                    PotentialImpact = "When an application installation package is detected that requires elevation of privilege, the user is prompted to enter an administrative user name and password. If the user enters valid credentials, the operation continues with the applicable privilege."
                    Vulnerability = "Some malicious software will attempt to install itself after being given permission to run. For example, malicious software with a trusted application shell. The user may have given permission for the program to run because the program is trusted, but if they are then prompted for installation of an unknown component this provides another way of trapping the software before it can do damage"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "600ea254_773b_43b5_be89_ca8221e96279" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'"
                    FullDescription = "This policy setting controls whether applications that request to run with a User Interface Accessibility (UIAccess) integrity level must reside in a secure location in the file system. Secure locations are limited to the following: - \Program Files\, including subfolders - \Windows\system32\ - \Program Files (x86)\, including subfolders for 64-bit versions of Windows **Note:** Windows enforces a public key infrastructure (PKI) signature check on any interactive application that requests to run with a UIAccess integrity level regardless of the state of this security setting. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "UIAccess Integrity allows an application to bypass User Interface Privilege Isolation (UIPI) restrictions when an application is elevated in privilege from a standard user to an administrator. This is required to support accessibility features such as screen readers that are transmitting user interfaces to alternative forms. A process that is started with UIAccess rights has the following abilities: - To set the foreground window. - To drive any application window using SendInput function. - To use read input for all integrity levels using low-level hooks, raw input, GetKeyState, GetAsyncKeyState, and GetKeyboardInput. - To set journal hooks. - To uses AttachThreadInput to attach a thread to a higher integrity input queue."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "1d099cbe_a327_42cd_9562_9896389c4263" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'"
                    FullDescription = "This policy setting controls the behavior of all User Account Control (UAC) policy settings for the computer. If you change this policy setting, you must restart your computer. The recommended state for this setting is: Enabled. **Note:** If this policy setting is disabled, the Security Center notifies you that the overall security of the operating system has been reduced."
                    PotentialImpact = "None - this is the default configuration. Users and administrators will need to learn to work with UAC prompts and adjust their work habits to use least privilege operations."
                    Vulnerability = "This is the setting that turns on or off UAC. If this setting is disabled, UAC will not be used and any security benefits and risk mitigations that are dependent on UAC will not be present on the system."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "21a9a771_ef63_419c_bee4_8619f19a77ff" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'"
                    FullDescription = "This policy setting controls whether the elevation request prompt is displayed on the interactive user's desktop or the secure desktop. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Standard elevation prompt dialog boxes can be spoofed, which may cause users to disclose their passwords to malicious software. The secure desktop presents a very distinct appearance when prompting for elevation, where the user desktop dims, and the elevation prompt UI is more prominent. This increases the likelihood that users who become accustomed to the secure desktop will recognize a spoofed elevation prompt dialog box and not fall for the trick."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "61f7469c_c76a_4265_b84f_d838adb06436" = @{
                    RuleId = ""
                    Name = " Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'"
                    FullDescription = "This policy setting controls whether application write failures are redirected to defined registry and file system locations. This policy setting mitigates applications that run as administrator and write run-time application data to: - %ProgramFiles%, - %Windir%, - %Windir%\system32, or - HKEY_LOCAL_MACHINE\Software. The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "This setting reduces vulnerabilities by ensuring that legacy applications only write data to permitted locations."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "4A459B04_79C8_4FB3_9EA0_CF4B77EE58D7" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)'"
                    FullDescription = "Select On (recommended) to have Windows Firewall with Advanced Security use the settings for this profile to filter network traffic. If you select Off, Windows Firewall with Advanced Security will not use any of the firewall rules or connection security rules for this profile."
                    PotentialImpact = "None, this is the default configuration."
                    Vulnerability = "If the firewall is turned off all traffic will be able to access the system and an attacker may be more easily able to remotely exploit a weakness in a network service."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "68757CAC_7589_4ED9_A162_27E5926F2DEB" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Domain: Outbound connections' is set to 'Allow (default)'"
                    FullDescription = "This setting determines the behavior for outbound connections that do not match an outbound firewall rule. In Windows Vista, the default behavior is to allow connections unless there are firewall rules that block the connection."
                    PotentialImpact = "None, this is the default configuration."
                    Vulnerability = "Some people believe that it is prudent to block all outbound connections except those specifically approved by the user or administrator. Microsoft disagrees with this opinion, blocking outbound connections by default will force users to deal with a large number of dialog boxes prompting them to authorize or block applications such as their web browser or instant messaging software. Additionally, blocking outbound traffic has little value because if an attacker has compromised the system they can reconfigure the firewall anyway."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "88338D83_A4E2_421B_B3F3_DB6BD2C694A0" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Domain: Settings: Apply local connection security rules' is set to 'Yes (default)'"
                    FullDescription = "<p><span>This setting controls whether local administrators are allowed to create localconnectionrules that apply together with firewall rules configured by Group Policy.The recommended state for this setting isYes, this will set the registry value to 1.</span></p>"
                    PotentialImpact = "If you configure this setting to Yes, security rules created by the local Administrators will be applied. This setting is available only when configuring the policy through Group Policy."
                    Vulnerability = "Users with local administrative privileges will not be able to apply security rules and Work Group Member doesnt receive Group Policy Updates."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "5F2D95D3_8744_4029_85C9_0BA7EA191531" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Domain: Settings: Apply local firewall rules' is set to 'Yes (default)'"
                    FullDescription = "<p><span>This setting controls whether local administrators are allowed to create local firewall rules that apply together with firewall rules configured by Group Policy.</span></p><p><span>The recommended state for this setting is Yes, this will set the registry value to 1. </span></p>"
                    PotentialImpact = "If you configure this setting to Yes, Firewall rules created by the local Administrators will be applied. This setting is available only when configuring the policy through Group Policy."
                    Vulnerability = "Users with local administrative privileges will not be able to apply firewall rules and Work Group Member doesnt receive Group Policy Updates."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "D4CB5E92_F237_4F83_95FB_1DDE6BE6DB1B" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Domain: Settings: Display a notification' is set to 'No'"
                    FullDescription = "<p><span>By selecting thisoption, nonotification is displayedto the userwhenaprogram is blocked from receiving inbound connections.In a server environment, the popups are not usefulasthe usersisnot loggedin, popupsare not necessary and can add confusion for the administrator.</span></p><p><span>Configure this policy setting toNo,this will set the registry value to1.Windows Firewallwill not display a notification when a program is blocked from receiving inbound connections.</span></p>"
                    PotentialImpact = "Configure this policy setting to No, Windows Firewall will not display these notifications to end user. "
                    Vulnerability = "Some organizations may prefer to avoid alarming users when firewall rules block certain types of network activity. However, notifications can be helpful when troubleshooting network issues involving the firewall. "
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "C8E1851A_FB32_4197_A1C0_D9DA262D37F1" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Private: Firewall state' is set to 'On (recommended)'"
                    FullDescription = "Select On (recommended) to have Windows Firewall with Advanced Security use the settings for this profile to filter network traffic. If you select Off, Windows Firewall with Advanced Security will not use any of the firewall rules or connection security rules for this profile."
                    PotentialImpact = "None, this is the default configuration."
                    Vulnerability = "If the firewall is turned off all traffic will be able to access the system and an attacker may be more easily able to remotely exploit a weakness in a network service."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "C98CFB4E_113F_4A25_A080_AB1F7D0F8F38" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Private: Outbound connections' is set to 'Allow (default)'"
                    FullDescription = "This setting determines the behavior for outbound connections that do not match an outbound firewall rule. The default behavior is to allow connections unless there are firewall rules that block the connection. 
Important   If you set Outbound connections to Block and then deploy the firewall policy by using a GPO, computers that receive the GPO settings cannot receive subsequent Group Policy updates unless you create and deploy an outbound rule that enables Group Policy to work. Predefined rules for Core Networking include outbound rules that enable Group Policy to work. Ensure that these outbound rules are active, and thoroughly test firewall profiles before deploying."
                    PotentialImpact = "None, this is the default configuration."
                    Vulnerability = "Some people believe that it is prudent to block all outbound connections except those specifically approved by the user or administrator. Microsoft disagrees with this opinion, blocking outbound connections by default will force users to deal with a large number of dialog boxes prompting them to authorize or block applications such as their web browser or instant messaging software. Additionally, blocking outbound traffic has little value because if an attacker has compromised the system they can reconfigure the firewall anyway."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "28B5CFB6_7548_44F9_9F43_A542644FA1FD" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Private: Settings: Apply local connection security rules' is set to 'Yes (default)'"
                    FullDescription = "<p><span>This setting controls whether local administrators are allowed to create localconnectionrules that apply together with firewall rules configured by Group Policy.The recommended state for this setting isYes, this will set the registry value to 1.</span></p>"
                    PotentialImpact = "If you configure this setting to Yes, security rules created by the local Administrators will be applied. This setting is available only when configuring the policy through Group Policy."
                    Vulnerability = "Users with local administrative privileges will not be able to apply security rules and Work Group Member doesnt receive Group Policy Updates."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "A636E099_8E2B_4653_A2BB_3689C151F9CC" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Private: Settings: Apply local firewall rules' is set to 'Yes (default)'"
                    FullDescription = "<p><span>This setting controls whether local administrators are allowed to create local firewall rules that apply together with firewall rules configured by Group Policy.</span></p><p><span>The recommended state for this setting is Yes, this will set the registry value to 1. </span></p>"
                    PotentialImpact = "If you configure this setting to Yes, Firewall rules created by the local Administrators will be applied. This setting is available only when configuring the policy through Group Policy."
                    Vulnerability = "Users with local administrative privileges will not be able to apply firewall rules and Work Group Member doesnt receive Group Policy Updates."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "D177F27B_8D9B_4BB1_A45C_5F3A11384D1F" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Private: Settings: Display a notification' is set to 'No'"
                    FullDescription = "<p><span>By selecting thisoption, nonotification is displayedto the userwhenaprogram is blocked from receiving inbound connections.In a server environment, the popups are not usefulasthe usersisnot loggedin, popupsare not necessary and can add confusion for the administrator.</span></p><p><span>Configure this policy setting toNo,this will set the registry value to1.Windows Firewallwill not display a notification when a program is blocked from receiving inbound connections.</span></p>"
                    PotentialImpact = "Configure this policy setting to No, Windows Firewall will not display these notifications to end user. "
                    Vulnerability = "Some organizations may prefer to avoid alarming users when firewall rules block certain types of network activity. However, notifications can be helpful when troubleshooting network issues involving the firewall. "
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "5E33A15A_7DB0_4A1D_B771_DB3764F3A625" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Public: Firewall state' is set to 'On (recommended)'"
                    FullDescription = "Select On (recommended) to have Windows Firewall with Advanced Security use the settings for this profile to filter network traffic. If you select Off, Windows Firewall with Advanced Security will not use any of the firewall rules or connection security rules for this profile."
                    PotentialImpact = ""
                    Vulnerability = "If the firewall is turned off all traffic will be able to access the system and an attacker may be more easily able to remotely exploit a weakness in a network service."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "753E721C_BE46_47F4_9571_8509CA5C1E61" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Public: Outbound connections' is set to 'Allow (default)'"
                    FullDescription = "This setting determines the behavior for outbound connections that do not match an outbound firewall rule. The default behavior is to allow connections unless there are firewall rules that block the connection. 
Important   If you set Outbound connections to Block and then deploy the firewall policy by using a GPO, computers that receive the GPO settings cannot receive subsequent Group Policy updates unless you create and deploy an outbound rule that enables Group Policy to work. Predefined rules for Core Networking include outbound rules that enable Group Policy to work. Ensure that these outbound rules are active, and thoroughly test firewall profiles before deploying."
                    PotentialImpact = "None, this is the default configuration."
                    Vulnerability = "Some people believe that it is prudent to block all outbound connections except those specifically approved by the user or administrator. Microsoft disagrees with this opinion, blocking outbound connections by default will force users to deal with a large number of dialog boxes prompting them to authorize or block applications such as their web browser or instant messaging software. Additionally, blocking outbound traffic has little value because if an attacker has compromised the system they can reconfigure the firewall anyway."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "10A43735_527C_46F0_A95C_954A8F9594DC" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Public: Settings: Apply local connection security rules' is set to 'No'"
                    FullDescription = "<p><span>This setting controls whether local administrators are allowed to create localconnectionrules that apply together with firewall rules configured by Group Policy.The recommended state for this setting isYes, this will set the registry value to 1.</span></p>"
                    PotentialImpact = "If you configure this setting to Yes, security rules created by the local Administrators will be applied. This setting is available only when configuring the policy through Group Policy."
                    Vulnerability = "Users with local administrative privileges will not be able to apply security rules and Work Group Member doesnt receive Group Policy Updates."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "E82B54B4_EF4D_474C_B06E_036DD076CBEC" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Public: Settings: Apply local firewall rules' is set to 'No'"
                    FullDescription = "<p><span>This setting controls whether local administrators are allowed to create local firewall rules that apply together with firewall rules configured by Group Policy.</span></p><p><span>The recommended state for this setting is Yes, this will set the registry value to 1. </span></p>"
                    PotentialImpact = "If you configure this setting to Yes, Firewall rules created by the local Administrators will be applied. This setting is available only when configuring the policy through Group Policy."
                    Vulnerability = "Users with local administrative privileges will not be able to apply firewall rules and Work Group Member doesnt receive Group Policy Updates."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "F34E3441_5977_432B_899B_119FC66E1B08" = @{
                    RuleId = ""
                    Name = "Ensure 'Windows Firewall: Public: Settings: Display a notification' is set to 'Yes'"
                    FullDescription = "<p><span>By selecting thisoption, nonotification is displayedto the userwhenaprogram is blocked from receiving inbound connections.In a server environment, the popups are not usefulasthe usersisnot loggedin, popupsare not necessary and can add confusion for the administrator.</span></p><p><span>Configure this policy setting toNo,this will set the registry value to1.Windows Firewallwill not display a notification when a program is blocked from receiving inbound connections.</span></p>"
                    PotentialImpact = "Configure this policy setting to No, Windows Firewall will not display these notifications to end user."
                    Vulnerability = "Some organizations may prefer to avoid alarming users when firewall rules block certain types of network activity. However, notifications can be helpful when troubleshooting network issues involving the firewall."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "A5A0D2D3_909D_4954_A083_4FB40FCDC181" = @{
                    RuleId = ""
                    Name = "Require user authentication for remote connections by using Network Level Authentication"
                    FullDescription = "Require user authentication for remote connections by using Network Level Authentication"
                    PotentialImpact = ""
                    Vulnerability = ""
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "7470f80e_a3d3_4ca9_84e8_7a97a317b2e1" = @{
                    RuleId = ""
                    Name = "Shutdown: Clear virtual memory pagefile"
                    FullDescription = "This policy setting determines whether the virtual memory pagefile is cleared when the system is shut down. When this policy setting is enabled, the system pagefile is cleared each time that the system shuts down properly. If you enable this security setting, the hibernation file (Hiberfil.sys) is zeroed out when hibernation is disabled on a portable computer system. It will take longer to shut down and restart the computer, and will be especially noticeable on computers with large paging files."
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "3007D6C4_A091_4449_9D05_409319E65883" = @{
                    RuleId = ""
                    Name = "Specify the interval to check for definition updates"
                    FullDescription = "This policy setting allows you to specify an interval at which to check for definition updates. The time value is represented as the number of hours between update checks. Valid values range from 1 (every hour) to 24 (once per day).

    If you enable this setting, checking for definition updates will occur at the interval specified.

    If you disable or do not configure this setting, checking for definition updates will occur at the default interval."
                    PotentialImpact = "Definition updates can impact performance."
                    Vulnerability = "Disabling or not configuring this setting causes definition updates will occur at the default interval, which may be contrary to your organization's security requirements."
                    Enabled = $true
                    ExpectedValue = "8"
                    }
        "2B36F636_E882_4B90_92C1_1F55F325053B" = @{
                    RuleId = ""
                    Name = "System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies"
                    FullDescription = "This policy setting determines whether digital certificates are processed when software restriction policies are enabled and a user or process attempts to run software with an .exe file name extension. It enables or disables certificate rules (a type of software restriction policies rule). With software restriction policies, you can create a certificate rule that will allow or disallow the execution of Authenticode -signed software, based on the digital certificate that is associated with the software. For certificate rules to take effect in software restriction policies, you must enable this policy setting."
                    PotentialImpact = "If you enable certificate rules, software restriction policies check a certificate revocation list (CRL) to ensure that the software's certificate and signature are valid. This checking process may negatively affect performance when signed programs start. To disable this feature you can edit the software restriction policies in the desired GPO. On the Trusted Publishers Properties dialog box, clear the Publisher and Timestamp check boxes."
                    Vulnerability = "Software restriction policies help to protect users and computers because they can prevent the execution of unauthorized code, such as viruses and Trojans horses."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "B75811FE_AC22_4171_9511_27FEC5177351" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Domain: Allow unicast response"
                    FullDescription = "<p><span>This option is useful if you need to control whether this computer receives unicast responses to its outgoing multicast or broadcast messages.</span></p><p><span>We recommend this setting to Yesfor Private and Domainprofiles, thiswill set the registry value to 0.</span></p>"
                    PotentialImpact = "If you enable this setting and this computer sends multicast or broadcast messages to other computers, Windows Firewall with Advanced Security waits as long as three seconds for unicast responses from the other computers and then blocks all later responses."
                    Vulnerability = "This prevents the computer receiving unicast response to an outgoing multicast or broadcast messages. "
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "3DCF28A5_E199_4B78_8933_7828DFDE4B9D" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Private: Allow unicast response"
                    FullDescription = "<p><span>This option is useful if you need to control whether this computer receives unicast responses to its outgoing multicast or broadcast messages.</span></p><p><span>We recommend this setting to Yesfor Private and Domainprofiles, thiswill set the registry value to 0.</span></p>"
                    PotentialImpact = "If you enable this setting and this computer sends multicast or broadcast messages to other computers, Windows Firewall with Advanced Security waits as long as three seconds for unicast responses from the other computers and then blocks all later responses."
                    Vulnerability = "This prevents the computer receiving unicast response to an outgoing multicast or broadcast messages. "
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "B72CC850_F180_4479_ABCE_2B72815AFEAD" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Public: Allow unicast response"
                    FullDescription = "<p><span>This option is useful if you need to control whether this computer receives unicast responses to its outgoing multicast or broadcast messages.This can be done by changing thestate for this settingto No,this will set the registry value to 1.</span></p>"
                    PotentialImpact = "By configuring this setting to No and this computer sends a multicast or broadcast message to other computers, Windows Firewall with Advanced Security blocks the unicast responses sent by those other computers."
                    Vulnerability = "An attacker could respond to broadcast or multicast message with malicious payloads."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "a30f6d7d_f3dc_442c_8a1f_921123c6250c" = @{
                    RuleId = ""
                    Name = "Bypass traverse checking"
                    FullDescription = "This policy setting allows users who do not have the Traverse Folder access permission to pass through folders when they browse an object path in the NTFS file system or the registry. This user right does not allow users to list the contents of a folder.

When configuring a user right in the SCM enter a comma delimited list of accounts. Accounts can be either local or located in Active Directory, they can be groups, users, or computers."
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "Administrators, Authenticated Users, Backup Operators, Local Service, Network Service"
                    }
        "3f2d92c2_5850_4f2d_b245_f5089aa975dd" = @{
                    RuleId = ""
                    Name = " Configure 'Access this computer from the network'"
                    FullDescription = "<p><span>This policy setting allows other users on the network to connect to the computer and is required by various network protocols that include Server Message Block (SMB) based protocols, NetBIOS, Common Internet File System (CIFS), and Component Object Model Plus (COM+). - *Level 1 - Domain Controller.* The recommended state for this setting is: 'Administrators, Authenticated Users, ENTERPRISE DOMAIN CONTROLLERS'. - *Level 1 - Member Server.* The recommended state for this setting is: 'Administrators, Authenticated Users'.</span></p>"
                    PotentialImpact = "If you remove the Access this computer from the network user right on domain controllers for all users, no one will be able to log on to the domain or use network resources. If you remove this user right on member servers, users will not be able to connect to those servers through the network. Successful negotiation of IPsec connections requires that the initiating machine has this right, therefore it is recommended that it is assigned to the Users group. If you have installed optional components such as ASP.NET or Internet Information Services (IIS), you may need to assign this user right to additional accounts that are required by those components. It is important to verify that authorized users are assigned this user right for the computers they need to access the network."
                    Vulnerability = "Users who can connect from their computer to the network can access resources on target computers for which they have permission. For example, the Access this computer from the network user right is required for users to connect to shared printers and folders. If this user right is assigned to the Everyone group, then anyone in the group will be able to read the files in those shared folders. However, this situation is unlikely for new installations of Windows Server 2003 with Service Pack 1 (SP1), because the default share and NTFS permissions in Windows Server 2003 do not include the Everyone group. This vulnerability may have a higher level of risk for computers that you upgrade from Windows NT 4.0 or Windows 2000, because the default permissions for these operating systems are not as restrictive as the default permissions in Windows Server 2003."
                    Enabled = $true
                    ExpectedValue = "Administrators, Authenticated Users"
                    }
        "051545A4_179E_4C04_9E9B_8F33821EF36F" = @{
                    RuleId = ""
                    Name = "Configure 'Allow log on locally'"
                    FullDescription = "This policy setting determines which users can interactively log on to computers in your environment. Logons that are initiated by pressing the CTRL+ALT+DEL key sequence on the client computer keyboard require this user right. Users who attempt to log on through Terminal Services or IIS also require this user right.
The Guest account is assigned this user right by default. Although this account is disabled by default, Microsoft recommends that you enable this setting through Group Policy. However, this user right should generally be restricted to the Administrators and Users groups. Assign this user right to the Backup Operators group if your organization requires that they have this capability.

When configuring a user right in the SCM enter a comma delimited list of accounts. Accounts can be either local or located in Active Directory, they can be groups, users, or computers."
                    PotentialImpact = "If you remove these default groups, you could limit the abilities of users who are assigned to specific administrative roles in your environment. If you have installed optional components such as ASP.NET or Internet Information Services, you may need to assign Allow log on locally user right to additional accounts that are required by those components. For example, IIS 6 requires that this user right be assigned to the IUSR_<ComputerName> account for certain features; see Default permissions and user rights for IIS 6.0 for more information: https://support.microsoft.com/?id=812614. You should confirm that delegated activities will not be adversely affected by any changes that you make to the Allow log on locally user rights assignments."
                    Vulnerability = "Any account with the Allow log on locally user right can log on at the console of the computer. If you do not restrict this user right to legitimate users who need to be able to log on to the console of the computer, unauthorized users could download and run malicious software to elevate their privileges."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "574f0e8d_83ca_4a46_a6cd_8dd062ab32dd" = @{
                    RuleId = ""
                    Name = " Configure 'Allow log on through Remote Desktop Services'"
                    FullDescription = "<p><span>This policy setting determines which users or groups have the right to log on as a Terminal Services client. Remote desktop users require this user right. If your organization uses Remote Assistance as part of its help desk strategy, create a group and assign it this user right through Group Policy. If the help desk in your organization does not use Remote Assistance, assign this user right only to the Administrators group or use the restricted groups feature to ensure that no user accounts are part of the Remote Desktop Users group. Restrict this user right to the Administrators group, and possibly the Remote Desktop Users group, to prevent unwanted users from gaining access to computers on your network by means of the Remote Assistance feature. - **Level 1 - Domain Controller.** The recommended state for this setting is: 'Administrators'. - **Level 1 - Member Server.** The recommended state for this setting is: 'Administrators, Remote Desktop Users'. **Note:** A Member Server that holds the _Remote Desktop Services_ Role with _Remote Desktop Connection Broker_ Role Service will require a special exception to this recommendation, to allow the 'Authenticated Users' group to be granted this user right. **Note 2:** The above lists are to be treated as allowlists, which implies that the above principals need not be present for assessment of this recommendation to pass.</span></p>"
                    PotentialImpact = "Removal of the Allow log on through Terminal Services user right from other groups or membership changes in these default groups could limit the abilities of users who perform specific administrative roles in your environment. You should confirm that delegated activities will not be adversely affected."
                    Vulnerability = "Any account with the Allow log on through Terminal Services user right can log on to the remote console of the computer. If you do not restrict this user right to legitimate users who need to log on to the console of the computer, unauthorized users could download and run malicious software to elevate their privileges."
                    Enabled = $true
                    ExpectedValue = "Administrators, Remote Desktop Users"
                    }
        "e97bdde4_ccec_42e6_a17f_7993cb03a0d6" = @{
                    RuleId = ""
                    Name = " Configure 'Create symbolic links'"
                    FullDescription = "<p><span>This policy setting determines which users can create symbolic links. In Windows Vista, existing NTFS file system objects, such as files and folders, can be accessed by referring to a new kind of file system object called a symbolic link. A symbolic link is a pointer (much like a shortcut or .lnk file) to another file system object, which can be a file, folder, shortcut or another symbolic link. The difference between a shortcut and a symbolic link is that a shortcut only works from within the Windows shell. To other programs and applications, shortcuts are just another file, whereas with symbolic links, the concept of a shortcut is implemented as a feature of the NTFS file system. Symbolic links can potentially expose security vulnerabilities in applications that are not designed to use them. For this reason, the privilege for creating symbolic links should only be assigned to trusted users. By default, only Administrators can create symbolic links. - **Level 1 - Domain Controller.** The recommended state for this setting is: 'Administrators'. - **Level 1 - Member Server.** The recommended state for this setting is: 'Administrators' and (when the _Hyper-V_ Role is installed) 'NT VIRTUAL MACHINE\Virtual Machines'.</span></p>"
                    PotentialImpact = "In most cases there will be no impact because this is the default configuration, however, on Windows Servers with the Hyper-V server role installed this user right should also be granted to the special group Virtual Machines otherwise you will not be able to create new virtual machines."
                    Vulnerability = "Users who have the Create Symbolic Links user right could inadvertently or maliciously expose your system to symbolic link attacks. Symbolic link attacks can be used to change the permissions on a file, to corrupt data, to destroy data, or as a Denial of Service attack."
                    Enabled = $true
                    ExpectedValue = "Administrators, NT VIRTUAL MACHINE\Virtual Machines"
                    }
        "fbe348fd_0402_4e31_8482_66ae9ae82ea2" = @{
                    RuleId = ""
                    Name = " Configure 'Deny access to this computer from the network'"
                    FullDescription = "<p><span>This policy setting prohibits users from connecting to a computer from across the network, which would allow users to access and potentially modify data remotely. In high security environments, there should be no need for remote users to access data on a computer. Instead, file sharing should be accomplished through the use of network servers. - **Level 1 - Domain Controller.** The recommended state for this setting is to include: 'Guests, Local account'. - **Level 1 - Member Server.** The recommended state for this setting is to include: 'Guests, Local account and member of Administrators group'. **Caution:** Configuring a standalone (non-domain-joined) server as described above may result in an inability to remotely administer the server. **Note:** Configuring a member server or standalone server as described above may adversely affect applications that create a local service account and place it in the Administrators group - in which case you must either convert the application to use a domain-hosted service account, or remove Local account and member of Administrators group from this User Right Assignment. Using a domain-hosted service account is strongly preferred over making an exception to this rule, where possible.</span></p>"
                    PotentialImpact = "If you configure the Deny access to this computer from the network user right for other groups, you could limit the abilities of users who are assigned to specific administrative roles in your environment. You should verify that delegated tasks will not be negatively affected."
                    Vulnerability = "Users who can log on to the computer over the network can enumerate lists of account names, group names, and shared resources. Users with permission to access shared folders and files can connect over the network and possibly view or modify data."
                    Enabled = $true
                    ExpectedValue = "Guests"
                    }
        "045634b9_61c9_414f_ad91_74dcfee9c076" = @{
                    RuleId = ""
                    Name = " Configure 'Enable computer and user accounts to be trusted for delegation'"
                    FullDescription = "<p><span>This policy setting allows users to change the Trusted for Delegation setting on a computer object in Active Directory. Abuse of this privilege could allow unauthorized users to impersonate other users on the network. - **Level 1 - Domain Controller.** The recommended state for this setting is: 'Administrators' - **Level 1 - Member Server.** The recommended state for this setting is: 'No One'.</span></p>"
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Misuse of the Enable computer and user accounts to be trusted for delegation user right could allow unauthorized users to impersonate other users on the network. An attacker could exploit this privilege to gain access to network resources and make it difficult to determine what has happened after a security incident."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "5d72b92f_e6b0_4898_b24a_49241c3a70a4" = @{
                    RuleId = ""
                    Name = " Configure 'Manage auditing and security log'"
                    FullDescription = "<p><span>This policy setting determines which users can change the auditing options for files and directories and clear the Security log. For environments running Microsoft Exchange Server, the 'Exchange Servers' group must possess this privilege on Domain Controllers to properly function. Given this, DCs granting the 'Exchange Servers' group this privilege do conform with this benchmark. If the environment does not use Microsoft Exchange Server, then this privilege should be limited to only 'Administrators' on DCs. - **Level 1 - Domain Controller.** The recommended state for this setting is: 'Administrators and (when Exchange is running in the environment) 'Exchange Servers'. - **Level 1 - Member Server.** The recommended state for this setting is: 'Administrators'</span></p>"
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "The ability to manage the Security event log is a powerful user right and it should be closely guarded. Anyone with this user right can clear the Security log to erase important evidence of unauthorized activity."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "131ecdaf_4a45_44ef_8d8e_eb7f4acf2fa6" = @{
                    RuleId = ""
                    Name = " Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'"
                    FullDescription = "This security setting is used by Credential Manager during Backup and Restore. No accounts should have this user right, as it is only assigned to Winlogon. Users' saved credentials might be compromised if this user right is assigned to other entities. The recommended state for this setting is: No One."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "If an account is given this right the user of the account may create an application that calls into Credential Manager and is returned the credentials for another user."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "d3d9ac7b_8bcc_42e8_8752_29902eda04dd" = @{
                    RuleId = ""
                    Name = " Ensure 'Accounts: Guest account status' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether the Guest account is enabled or disabled. The Guest account allows unauthenticated network users to gain access to the system. The recommended state for this setting is: Disabled. **Note:** This setting will have no impact when applied to the domain controller organizational unit via group policy because domain controllers have no local account database. It can be configured at the domain level via group policy, similar to account lockout and password policy settings."
                    PotentialImpact = "All network users will need to authenticate before they can access shared resources. If you disable the Guest account and the Network Access: Sharing and Security Model option is set to Guest Only, network logons, such as those performed by the Microsoft Network Server (SMB Service), will fail. This policy setting should have little impact on most organizations because it is the default setting in Microsoft Windows 2000, Windows XP, and Windows Server 2003."
                    Vulnerability = "The default Guest account allows unauthenticated network users to log on as Guest with no password. These unauthorized users could access any resources that are accessible to the Guest account over the network. This capability means that any network shares with permissions that allow access to the Guest account, the Guests group, or the Everyone group will be accessible over the network, which could lead to the exposure or corruption of data."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "c7f8ee96_6b8e_47e8_80b1_2e0985edeafd" = @{
                    RuleId = ""
                    Name = " Ensure 'Act as part of the operating system' is set to 'No One'"
                    FullDescription = "This policy setting allows a process to assume the identity of any user and thus gain access to the resources that the user is authorized to access. The recommended state for this setting is: No One."
                    PotentialImpact = "There should be little or no impact because the Act as part of the operating system user right is rarely needed by any accounts other than the Local System account."
                    Vulnerability = "The Act as part of the operating system user right is extremely powerful. Anyone with this user right can take complete control of the computer and erase evidence of their activities."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "877cfb8a_1504_4641_9caf_405768ff91f4" = @{
                    RuleId = ""
                    Name = " Ensure 'Backup files and directories' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to circumvent file and directory permissions to backup the system. This user right is enabled only when an application (such as NTBACKUP) attempts to access a file or directory through the NTFS file system backup application programming interface (API). Otherwise, the assigned file and directory permissions apply. The recommended state for this setting is: Administrators."
                    PotentialImpact = "Changes in the membership of the groups that have the Backup files and directories user right could limit the abilities of users who are assigned to specific administrative roles in your environment. You should confirm that authorized backup administrators are still able to perform backup operations."
                    Vulnerability = "Users who are able to backup data from a computer could take the backup media to a non-domain computer on which they have administrative privileges and restore the data. They could take ownership of the files and view any unencrypted data that is contained within the backup set."
                    Enabled = $true
                    ExpectedValue = "Administrators, Backup Operators, Server Operators"
                    }
        "8b6f479f_13a9_40d1_a2d6_bd9c27d2b7dc" = @{
                    RuleId = ""
                    Name = " Ensure 'Change the system time' is set to 'Administrators, Local Service'"
                    FullDescription = "This policy setting determines which users and groups can change the time and date on the internal clock of the computers in your environment. Users who are assigned this user right can affect the appearance of event logs. When a computer's time setting is changed, logged events reflect the new time, not the actual time that the events occurred. When configuring a user right in the SCM enter a comma delimited list of accounts. Accounts can be either local or located in Active Directory, they can be groups, users, or computers. **Note:** Discrepancies between the time on the local computer and on the domain controllers in your environment may cause problems for the Kerberos authentication protocol, which could make it impossible for users to log on to the domain or obtain authorization to access domain resources after they are logged on. Also, problems will occur when Group Policy is applied to client computers if the system time is not synchronized with the domain controllers. The recommended state for this setting is: Administrators, LOCAL SERVICE."
                    PotentialImpact = "There should be no impact, because time synchronization for most organizations should be fully automated for all computers that belong to the domain. Computers that do not belong to the domain should be configured to synchronize with an external source."
                    Vulnerability = "Users who can change the time on a computer could cause several problems. For example, time stamps on event log entries could be made inaccurate, time stamps on files and folders that are created or modified could be incorrect, and computers that belong to a domain may not be able to authenticate themselves or users who try to log on to the domain from them. Also, because the Kerberos authentication protocol requires that the requestor and authenticator have their clocks synchronized within an administrator-defined skew period, an attacker who changes a computer's time may cause that computer to be unable to obtain or grant Kerberos tickets. The risk from these types of events is mitigated on most domain controllers, member servers, and end-user computers because the Windows Time service automatically synchronizes time with domain controllers in the following ways: - All client desktop computers and member servers use the authenticating domain controller as their inbound time partner. - All domain controllers in a domain nominate the primary domain controller (PDC) emulator operations master as their inbound time partner. - All PDC emulator operations masters follow the hierarchy of domains in the selection of their inbound time partner. - The PDC emulator operations master at the root of the domain is authoritative for the organization. Therefore it is recommended that you configure this computer to synchronize with a reliable external time server. This vulnerability becomes much more serious if an attacker is able to change the system time and then stop the Windows Time service or reconfigure it to synchronize with a time server that is not accurate."
                    Enabled = $true
                    ExpectedValue = "Administrators, Server Operators, LOCAL SERVICE"
                    }
        "8ed0c2c5_af57_4434_9ae8_fe93bc39bfd0" = @{
                    RuleId = ""
                    Name = " Ensure 'Change the time zone' is set to 'Administrators, Local Service'"
                    FullDescription = "This setting determines which users can change the time zone of the computer. This ability holds no great danger for the computer and may be useful for mobile workers. The recommended state for this setting is: Administrators, LOCAL SERVICE."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Changing the time zone represents little vulnerability because the system time is not affected. This setting merely enables users to display their preferred time zone while being synchronized with domain controllers in different time zones."
                    Enabled = $true
                    ExpectedValue = "Administrators, LOCAL SERVICE"
                    }
        "04251e82_4442_4923_ac77_992891a5042b" = @{
                    RuleId = ""
                    Name = " Ensure 'Create a pagefile' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to change the size of the pagefile. By making the pagefile extremely large or extremely small, an attacker could easily affect the performance of a compromised computer. The recommended state for this setting is: Administrators."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users who can change the page file size could make it extremely small or move the file to a highly fragmented storage volume, which could cause reduced computer performance."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "d3f866fb_8adf_4ec6_adc7_93bb9ebcccdd" = @{
                    RuleId = ""
                    Name = " Ensure 'Create a token object' is set to 'No One'"
                    FullDescription = "This policy setting allows a process to create an access token, which may provide elevated rights to access sensitive data. The recommended state for this setting is: No One."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "A user account that is given this user right has complete control over the system and can lead to the system being compromised. It is highly recommended that you do not assign any user accounts this right. The operating system examines a user's access token to determine the level of the user's privileges. Access tokens are built when users log on to the local computer or connect to a remote computer over a network. When you revoke a privilege, the change is immediately recorded, but the change is not reflected in the user's access token until the next time the user logs on or connects. Users with the ability to create or modify tokens can change the level of access for any currently logged on account. They could escalate their own privileges or create a DoS condition."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "c0a4a0ed_1585_4857_8e2b_30b1bb48c6ea" = @{
                    RuleId = ""
                    Name = " Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'"
                    FullDescription = "This policy setting determines whether users can create global objects that are available to all sessions. Users can still create objects that are specific to their own session if they do not have this user right. Users who can create global objects could affect processes that run under other users' sessions. This capability could lead to a variety of problems, such as application failure or data corruption. The recommended state for this setting is: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE. **Note:** A Member Server with Microsoft SQL Server _and_ its optional Integration Services component installed will require a special exception to this recommendation for additional SQL-generated entries to be granted this user right."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users who can create global objects could affect Windows services and processes that run under other user or system accounts. This capability could lead to a variety of problems, such as application failure, data corruption and elevation of privilege."
                    Enabled = $true
                    ExpectedValue = "Administrators, SERVICE, LOCAL SERVICE, NETWORK SERVICE"
                    }
        "03766d3c_81c2_438e_8192_91787f2ae69a" = @{
                    RuleId = ""
                    Name = " Ensure 'Create permanent shared objects' is set to 'No One'"
                    FullDescription = "This user right is useful to kernel-mode components that extend the object namespace. However, components that run in kernel mode have this user right inherently. Therefore, it is typically not necessary to specifically assign this user right. The recommended state for this setting is: No One."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users who have the Create permanent shared objects user right could create new shared objects and expose sensitive data to the network."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "49258884_b2f0_4a4e_b66a_6954bb8473bf" = @{
                    RuleId = ""
                    Name = " Ensure 'Deny log on as a batch job' to include 'Guests'"
                    FullDescription = "This policy setting determines which accounts will not be able to log on to the computer as a batch job. A batch job is not a batch (.bat) file, but rather a batch-queue facility. Accounts that use the Task Scheduler to schedule jobs need this user right. The **Deny log on as a batch job** user right overrides the **Log on as a batch job** user right, which could be used to allow accounts to schedule jobs that consume excessive system resources. Such an occurrence could cause a DoS condition. Failure to assign this user right to the recommended accounts can be a security risk. The recommended state for this setting is to include: Guests."
                    PotentialImpact = "If you assign the Deny log on as a batch job user right to other accounts, you could deny users who are assigned to specific administrative roles the ability to perform their required job activities. You should confirm that delegated tasks will not be affected adversely. For example, if you assign this user right to the IWAM_(ComputerName) account, the MSM Management Point will fail. On a newly installed computer that runs Windows Server 2003 this account does not belong to the Guests group, but on a computer that was upgraded from Windows 2000 this account is a member of the Guests group. Therefore, it is important that you understand which accounts belong to any groups that you assign the Deny log on as a batch job user right."
                    Vulnerability = "Accounts that have the Deny log on as a batch job user right could be used to schedule jobs that could consume excessive computer resources and cause a DoS condition."
                    Enabled = $true
                    ExpectedValue = "Guests"
                    }
        "3b993f8f_245d_4f4e_9e8b_f94cbc71c3f6" = @{
                    RuleId = ""
                    Name = " Ensure 'Deny log on as a service' to include 'Guests'"
                    FullDescription = "This security setting determines which service accounts are prevented from registering a process as a service. This policy setting supersedes the **Log on as a service** policy setting if an account is subject to both policies. The recommended state for this setting is to include: Guests. **Note:** This security setting does not apply to the System, Local Service, or Network Service accounts."
                    PotentialImpact = "If you assign the Deny log on as a service user right to specific accounts, services may not be able to start and a DoS condition could result."
                    Vulnerability = "Accounts that can log on as a service could be used to configure and start new unauthorized services, such as a keylogger or other malicious software. The benefit of the specified countermeasure is somewhat reduced by the fact that only users with administrative privileges can install and configure services, and an attacker who has already attained that level of access could configure the service to run with the System account."
                    Enabled = $true
                    ExpectedValue = "Guests"
                    }
        "b7432fc2_51ba_4ddf_83dd_ca7f92e670c1" = @{
                    RuleId = ""
                    Name = " Ensure 'Deny log on locally' to include 'Guests'"
                    FullDescription = "This security setting determines which users are prevented from logging on at the computer. This policy setting supersedes the **Allow log on locally** policy setting if an account is subject to both policies. **Important:** If you apply this security policy to the Everyone group, no one will be able to log on locally. The recommended state for this setting is to include: Guests."
                    PotentialImpact = "If you assign the Deny log on locally user right to additional accounts, you could limit the abilities of users who are assigned to specific roles in your environment. However, this user right should explicitly be assigned to the ASPNET account on computers that run IIS 6.0. You should confirm that delegated activities will not be adversely affected."
                    Vulnerability = "Any account with the ability to log on locally could be used to log on at the console of the computer. If this user right is not restricted to legitimate users who need to log on to the console of the computer, unauthorized users might download and run malicious software that elevates their privileges."
                    Enabled = $true
                    ExpectedValue = "Guests"
                    }
        "60e0c2c9_0b14_44fe_83d6_2b7095e06674" = @{
                    RuleId = ""
                    Name = " Ensure 'Deny log on through Remote Desktop Services' to include 'Guests, Local account'"
                    FullDescription = "This policy setting determines whether users can log on as Terminal Services clients. After the baseline member server is joined to a domain environment, there is no need to use local accounts to access the server from the network. Domain accounts can access the server for administration and end-user processing. The recommended state for this setting is to include: Guests, Local account. **Caution:** Configuring a standalone (non-domain-joined) server as described above may result in an inability to remotely administer the server."
                    PotentialImpact = "If you assign the Deny log on through Terminal Services user right to other groups, you could limit the abilities of users who are assigned to specific administrative roles in your environment. Accounts that have this user right will be unable to connect to the computer through either Terminal Services or Remote Assistance. You should confirm that delegated tasks will not be negatively impacted."
                    Vulnerability = "Any account with the right to log on through Terminal Services could be used to log on to the remote console of the computer. If this user right is not restricted to legitimate users who need to log on to the console of the computer, unauthorized users might download and run malicious software that elevates their privileges."
                    Enabled = $true
                    ExpectedValue = "Guests"
                    }
        "dad8097d_db46_4df3_9839_a8504e60c878" = @{
                    RuleId = ""
                    Name = " Ensure 'Enforce password history' is set to '24 or more password'"
                    FullDescription = "<p><span>This policy setting determines the number of renewed, unique passwords that have to be associated with a user account before you can reuse an old password. The value for this policy setting must be between 0 and 24 passwords. The default value for Windows Vista is 0 passwords, but the default setting in a domain is 24 passwords. To maintain the effectiveness of this policy setting, use the Minimum password age setting to prevent users from repeatedly changing their password. The recommended state for this setting is: '24 or more password(s)'.</span></p>"
                    PotentialImpact = "The major impact of this configuration is that users must create a new password every time they are required to change their old one. If users are required to change their passwords to new unique values, there is an increased risk of users who write their passwords somewhere so that they do not forget them. Another risk is that users may create passwords that change incrementally (for example, password01, password02, and so on) to facilitate memorization but make them easier to guess. Also, an excessively low value for the Minimum password age setting will likely increase administrative overhead, because users who forget their passwords might ask the help desk to reset them frequently."
                    Vulnerability = "The longer a user uses the same password, the greater the chance that an attacker can determine the password through brute force attacks. Also, any accounts that may have been compromised will remain exploitable for as long as the password is left unchanged. If password changes are required but password reuse is not prevented, or if users continually reuse a small number of passwords, the effectiveness of a good password policy is greatly reduced. If you specify a low number for this policy setting, users will be able to use the same small number of passwords repeatedly. If you do not also configure the Minimum password age setting, users might repeatedly change their passwords until they can reuse their original password."
                    Enabled = $true
                    ExpectedValue = "24"
                    }
        "3531261f_1644_4d10_9242_8e35ef386a83" = @{
                    RuleId = ""
                    Name = " Ensure 'Force shutdown from a remote system' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to shut down Windows Vista-based computers from remote locations on the network. Anyone who has been assigned this user right can cause a denial of service (DoS) condition, which would make the computer unavailable to service user requests. Therefore, it is recommended that only highly trusted administrators be assigned this user right. The recommended state for this setting is: Administrators."
                    PotentialImpact = "If you remove the Force shutdown from a remote system user right from the Server Operator group you could limit the abilities of users who are assigned to specific administrative roles in your environment. You should confirm that delegated activities will not be adversely affected."
                    Vulnerability = "Any user who can shut down a computer could cause a DoS condition to occur. Therefore, this user right should be tightly restricted."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "46e66c68_266e_4bdc_9ebe_4c5164c0acfe" = @{
                    RuleId = ""
                    Name = " Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
                    FullDescription = "This policy setting determines which users or processes can generate audit records in the Security log. The recommended state for this setting is: LOCAL SERVICE, NETWORK SERVICE. **Note:** A Member Server that holds the _Web Server (IIS)_ Role with _Web Server_ Role Service will require a special exception to this recommendation, to allow IIS application pool(s) to be granted this user right. **Note #2:** A Member Server that holds the _Active Directory Federation Services_ Role will require a special exception to this recommendation, to allow the NT SERVICE\ADFSSrv and NT SERVICE\DRS services, as well as the associated Active Directory Federation Services service account, to be granted this user right."
                    PotentialImpact = "On most computers, this is the default configuration and there will be no negative impact. However, if you have installed the _Web Server (IIS)_ Role with _Web Services_ Role Service, you will need to allow the IIS application pool(s) to be granted this User Right Assignment."
                    Vulnerability = "An attacker could use this capability to create a large number of audited events, which would make it more difficult for a system administrator to locate any illicit activity. Also, if the event log is configured to overwrite events as needed, any evidence of unauthorized activities could be overwritten by a large number of unrelated events."
                    Enabled = $true
                    ExpectedValue = "Local Service, Network Service, IIS APPPOOL\DefaultAppPool"
                    }
        "98372fa4_c0dc_499a_a218_abc96fc04684" = @{
                    RuleId = ""
                    Name = " Ensure 'Increase scheduling priority' is set to 'Administrators'"
                    FullDescription = "This policy setting determines whether users can increase the base priority class of a process. (It is not a privileged operation to increase relative priority within a priority class.) This user right is not required by administrative tools that are supplied with the operating system but might be required by software development tools. The recommended state for this setting is: Administrators."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "A user who is assigned this user right could increase the scheduling priority of a process to Real-Time, which would leave little processing time for all other processes and could lead to a DoS condition."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "50f4447d_0bdd_4e8c_ba06_2e0b22ec5d04" = @{
                    RuleId = ""
                    Name = " Ensure 'Load and unload device drivers' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to dynamically load a new device driver on a system. An attacker could potentially use this capability to install malicious code that appears to be a device driver. This user right is required for users to add local printers or printer drivers in Windows Vista. The recommended state for this setting is: Administrators."
                    PotentialImpact = "If you remove the Load and unload device drivers user right from the Print Operators group or other accounts you could limit the abilities of users who are assigned to specific administrative roles in your environment. You should ensure that delegated tasks will not be negatively affected."
                    Vulnerability = "Device drivers run as highly privileged code. A user who has the Load and unload device drivers user right could unintentionally install malicious code that masquerades as a device driver. Administrators should exercise greater care and install only drivers with verified digital signatures."
                    Enabled = $true
                    ExpectedValue = "Administrators, Print Operators"
                    }
        "6e635d8c_3496_4c66_b734_c46ebccc5d38" = @{
                    RuleId = ""
                    Name = " Ensure 'Lock pages in memory' is set to 'No One'"
                    FullDescription = "This policy setting allows a process to keep data in physical memory, which prevents the system from paging the data to virtual memory on disk. If this user right is assigned, significant degradation of system performance can occur. The recommended state for this setting is: No One."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Users with the Lock pages in memory user right could assign physical memory to several processes, which could leave little or no RAM for other processes and result in a DoS condition."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "d43b43ec_abd0_4420_ba8c_d4e53b057205" = @{
                    RuleId = ""
                    Name = " Ensure 'Maximum password age' is set to '60 or fewer days, but not 0'"
                    FullDescription = "This policy setting defines how long a user can use their password before it expires. Values for this policy setting range from 0 to 999 days. If you set the value to 0, the password will never expire. Because attackers can crack passwords, the more frequently you change the password the less opportunity an attacker has to use a cracked password. However, the lower this value is set, the higher the potential for an increase in calls to help desk support due to users having to change their password or forgetting which password is current. The recommended state for this setting is 60 or fewer days, but not 0."
                    PotentialImpact = "If the Maximum password age setting is too low, users are required to change their passwords very often. Such a configuration can reduce security in the organization, because users might write their passwords in an insecure location or lose them. If the value for this policy setting is too high, the level of security within an organization is reduced because it allows potential attackers more time in which to discover user passwords or to use compromised accounts."
                    Vulnerability = "The longer a password exists the higher the likelihood that it will be compromised by a brute force attack, by an attacker gaining general knowledge about the user, or by the user sharing the password. Configuring the Maximum password age setting to 0 so that users are never required to change their passwords is a major security risk because that allows a compromised password to be used by the malicious user for as long as the valid user is authorized access."
                    Enabled = $true
                    ExpectedValue = "1,70"
                    }
        "45bdfbf8_155f_41f8_b9cf_72f1ba26c5be" = @{
                    RuleId = ""
                    Name = " Ensure 'Minimum password age' is set to '1 or more day'"
                    FullDescription = "This policy setting determines the number of days that you must use a password before you can change it. The range of values for this policy setting is between 1 and 999 days. (You may also set the value to 0 to allow immediate password changes.) The default value for this setting is 0 days. The recommended state for this setting is: 1 or more day(s)."
                    PotentialImpact = "If an administrator sets a password for a user but wants that user to change the password when the user first logs on, the administrator must select the User must change password at next logon check box, or the user will not be able to change the password until the next day."
                    Vulnerability = "Users may have favorite passwords that they like to use because they are easy to remember and they believe that their password choice is secure from compromise. Unfortunately, passwords are compromised and if an attacker is targeting a specific individual user account, with foreknowledge of data about that user, reuse of old passwords can cause a security breach. To address password reuse a combination of security settings is required. Using this policy setting with the Enforce password history setting prevents the easy reuse of old passwords. For example, if you configure the Enforce password history setting to ensure that users cannot reuse any of their last 12 passwords, they could change their password 13 times in a few minutes and reuse the password they started with, unless you also configure the Minimum password age setting to a number that is greater than 0. You must configure this policy setting to a number that is greater than 0 for the Enforce password history setting to be effective."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "bc9d4fef_9e33_48fc_bcbd_b53e60caf4a2" = @{
                    RuleId = ""
                    Name = " Ensure 'Minimum password length' is set to '14 or more character'"
                    FullDescription = "This policy setting determines the least number of characters that make up a password for a user account. There are many different theories about how to determine the best password length for an organization, but perhaps pass phrase is a better term than password. In Microsoft Windows 2000 or later, pass phrases can be quite long and can include spaces. Therefore, a phrase such as I want to drink a 5 milkshake is a valid pass phrase; it is a considerably stronger password than an 8 or 10 character string of random numbers and letters, and yet is easier to remember. Users must be educated about the proper selection and maintenance of passwords, especially with regard to password length. In enterprise environments, the ideal value for the Minimum password length setting is 14 characters, however you should adjust this value to meet your organization's business requirements. The recommended state for this setting is: 14 or more character(s)."
                    PotentialImpact = "Requirements for extremely long passwords can actually decrease the security of an organization, because users might leave the information in an insecure location or lose it. If very long passwords are required, mistyped passwords could cause account lockouts and increase the volume of help desk calls. If your organization has issues with forgotten passwords due to password length requirements, consider teaching your users about pass phrases, which are often easier to remember and, due to the larger number of character combinations, much harder to discover. **Note:** Older versions of Windows such as Windows 98 and Windows NT 4.0 do not support passwords that are longer than 14 characters. Computers that run these older operating systems are unable to authenticate with computers or domains that use accounts that require long passwords."
                    Vulnerability = "Types of password attacks include dictionary attacks (which attempt to use common words and phrases) and brute force attacks (which try every possible combination of characters). Also, attackers sometimes try to obtain the account database so they can use tools to discover the accounts and passwords."
                    Enabled = $true
                    ExpectedValue = "14"
                    }
        "25c07385_c03d_4f61_b4d2_13852635abb7" = @{
                    RuleId = ""
                    Name = " Ensure 'Modify an object label' is set to 'No One'"
                    FullDescription = "This privilege determines which user accounts can modify the integrity label of objects, such as files, registry keys, or processes owned by other users. Processes running under a user account can modify the label of an object owned by that user to a lower level without this privilege. The recommended state for this setting is: No One."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "By modifying the integrity label of an object owned by another user a malicious user may cause them to execute code at a higher level of privilege than intended."
                    Enabled = $true
                    ExpectedValue = "No One"
                    }
        "910405d5_3ee9_427c_baf1_77c69c7c209d" = @{
                    RuleId = ""
                    Name = " Ensure 'Modify firmware environment values' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to configure the system-wide environment variables that affect hardware configuration. This information is typically stored in the Last Known Good Configuration. Modification of these values and could lead to a hardware failure that would result in a denial of service condition. The recommended state for this setting is: Administrators."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Anyone who is assigned the Modify firmware environment values user right could configure the settings of a hardware component to cause it to fail, which could lead to data corruption or a DoS condition."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "299d1595_5ab2_4ef5_b287_6477c0df5178" = @{
                    RuleId = ""
                    Name = " Ensure 'Password must meet complexity requirements' is set to 'Enabled'"
                    FullDescription = "This policy setting checks all new passwords to ensure that they meet basic requirements for strong passwords. When this policy is enabled, passwords must meet the following minimum requirements: - Does not contain the user's account name or parts of the user's full name that exceed two consecutive characters - Be at least six characters in length - Contain characters from three of the following four categories: - English uppercase characters (A through Z) - English lowercase characters (a through z) - Base 10 digits (0 through 9) - Non-alphabetic characters (for example, !, , #, %) - A catch-all category of any Unicode character that does not fall under the previous four categories. This fifth category can be regionally specific. Each additional character in a password increases its complexity exponentially. For instance, a seven-character, all lower-case alphabetic password would have 267 (approximately 8 x 109 or 8 billion) possible combinations. At 1,000,000 attempts per second (a capability of many password-cracking utilities), it would only take 133 minutes to crack. A seven-character alphabetic password with case sensitivity has 527 combinations. A seven-character case-sensitive alphanumeric password without punctuation has 627 combinations. An eight-character password has 268 (or 2 x 1011) possible combinations. Although this might seem to be a large number, at 1,000,000 attempts per second it would take only 59 hours to try all possible passwords. Remember, these times will significantly increase for passwords that use ALT characters and other special keyboard characters such as ! or @. Proper use of the password settings can help make it difficult to mount a brute force attack. The recommended state for this setting is: Enabled."
                    PotentialImpact = "If the default password complexity configuration is retained, additional help desk calls for locked-out accounts could occur because users might not be accustomed to passwords that contain non-alphabetic characters. However, all users should be able to comply with the complexity requirement with minimal difficulty. If your organization has more stringent security requirements, you can create a custom version of the Passfilt.dll file that allows the use of arbitrarily complex password strength rules. For example, a custom password filter might require the use of non-upper row characters. (Upper row characters are those that require you to hold down the SHIFT key and press any of the digits between 1 and 0.) A custom password filter might also perform a dictionary check to verify that the proposed password does not contain common dictionary words or fragments. Also, the use of ALT key character combinations can greatly enhance the complexity of a password. However, such stringent password requirements can result in unhappy users and an extremely busy help desk. Alternatively, your organization could consider a requirement for all administrator passwords to use ALT characters in the 01280159 range. (ALT characters outside of this range can represent standard alphanumeric characters that would not add additional complexity to the password.)"
                    Vulnerability = "Passwords that contain only alphanumeric characters are extremely easy to discover with several publicly available tools."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "506fa45a_f043_46b0_bca9_da87e2f2618b" = @{
                    RuleId = ""
                    Name = " Ensure 'Perform volume maintenance tasks' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to manage the system's volume or disk configuration, which could allow a user to delete a volume and cause data loss as well as a denial-of-service condition. The recommended state for this setting is: Administrators."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "A user who is assigned the Perform volume maintenance tasks user right could delete a volume, which could result in the loss of data or a DoS condition."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "aec3dc3b_3625_47ea_8e11_fef4b1be8adb" = @{
                    RuleId = ""
                    Name = " Ensure 'Profile single process' is set to 'Administrators'"
                    FullDescription = "This policy setting determines which users can use tools to monitor the performance of non-system processes. Typically, you do not need to configure this user right to use the Microsoft Management Console (MMC) Performance snap-in. However, you do need this user right if System Monitor is configured to collect data using Windows Management Instrumentation (WMI). Restricting the Profile single process user right prevents intruders from gaining additional information that could be used to mount an attack on the system. The recommended state for this setting is: Administrators."
                    PotentialImpact = "If you remove the Profile single process user right from the Power Users group or other accounts, you could limit the abilities of users who are assigned to specific administrative roles in your environment. You should ensure that delegated tasks will not be negatively affected."
                    Vulnerability = "The Profile single process user right presents a moderate vulnerability. An attacker with this user right could monitor a computer's performance to help identify critical processes that they might wish to attack directly. The attacker may also be able to determine what processes run on the computer so that they could identify countermeasures that they may need to avoid, such as antivirus software, an intrusion-detection system, or which other users are logged on to a computer."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "e61c2d81_389a_4e59_bf19_2a6db7a0dc0b" = @{
                    RuleId = ""
                    Name = " Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'"
                    FullDescription = "This policy setting allows users to use tools to view the performance of different system processes, which could be abused to allow attackers to determine a system's active processes and provide insight into the potential attack surface of the computer. The recommended state for this setting is: Administrators, NT SERVICE\WdiServiceHost."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "The Profile system performance user right poses a moderate vulnerability. Attackers with this user right could monitor a computer's performance to help identify critical processes that they might wish to attack directly. Attackers may also be able to determine what processes are active on the computer so that they could identify countermeasures that they may need to avoid, such as antivirus software or an intrusion detection system."
                    Enabled = $true
                    ExpectedValue = "Administrators, NT SERVICE\WdiServiceHost"
                    }
        "08a4b141_c737_404e_8617_9830268e8bfa" = @{
                    RuleId = ""
                    Name = " Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
                    FullDescription = "This policy setting allows one process or service to start another service or process with a different security access token, which can be used to modify the security access token of that sub-process and result in the escalation of privileges. The recommended state for this setting is: LOCAL SERVICE, NETWORK SERVICE. **Note:** A Member Server that holds the _Web Server (IIS)_ Role with _Web Server_ Role Service will require a special exception to this recommendation, to allow IIS application pool(s) to be granted this user right. **Note #2:** A Member Server with Microsoft SQL Server installed will require a special exception to this recommendation for additional SQL-generated entries to be granted this user right."
                    PotentialImpact = "On most computers, this is the default configuration and there will be no negative impact. However, if you have installed the _Web Server (IIS)_ Role with _Web Services_ Role Service, you will need to allow the IIS application pool(s) to be granted this User Right Assignment."
                    Vulnerability = "User with the Replace a process level token privilege are able to start processes as other users whose credentials they know. They could use this method to hide their unauthorized actions on the computer. (On Windows 2000-based computers, use of the Replace a process level token user right also requires the user to have the Adjust memory quotas for a process user right that is discussed earlier in this section.)"
                    Enabled = $true
                    ExpectedValue = "LOCAL SERVICE, NETWORK SERVICE"
                    }
        "1baa8699_ca1c_466b_b17c_f8eab728b0ee" = @{
                    RuleId = ""
                    Name = " Ensure 'Restore files and directories' is set to 'Administrators'"
                    FullDescription = "This policy setting determines which users can bypass file, directory, registry, and other persistent object permissions when restoring backed up files and directories on computers that run Windows Vista in your environment. This user right also determines which users can set valid security principals as object owners; it is similar to the Backup files and directories user right. The recommended state for this setting is: Administrators."
                    PotentialImpact = "If you remove the Restore files and directories user right from the Backup Operators group and other accounts you could make it impossible for users who have been delegated specific tasks to perform those tasks. You should verify that this change won't negatively affect the ability of your organization's personnel to do their jobs."
                    Vulnerability = "An attacker with the Restore files and directories user right could restore sensitive data to a computer and overwrite data that is more recent, which could lead to loss of important data, data corruption, or a denial of service. Attackers could overwrite executable files that are used by legitimate administrators or system services with versions that include malicious software to grant themselves elevated privileges, compromise data, or install backdoors for continued access to the computer. **Note:** Even if the following countermeasure is configured, an attacker could still restore data to a computer in a domain that is controlled by the attacker. Therefore, it is critical that organizations carefully protect the media that are used to backup data."
                    Enabled = $true
                    ExpectedValue = "Administrators, Backup Operators"
                    }
        "ef0eefbb_e845_47f3_af9a_3409296d3264" = @{
                    RuleId = ""
                    Name = " Ensure 'Shut down the system' is set to 'Administrators'"
                    FullDescription = "This policy setting determines which users who are logged on locally to the computers in your environment can shut down the operating system with the Shut Down command. Misuse of this user right can result in a denial of service condition. The recommended state for this setting is: Administrators."
                    PotentialImpact = "The impact of removing these default groups from the Shut down the system user right could limit the delegated abilities of assigned roles in your environment. You should confirm that delegated activities will not be adversely affected."
                    Vulnerability = "The ability to shut down domain controllers and member servers should be limited to a very small number of trusted administrators. Although the **Shut down the system** user right requires the ability to log on to the server, you should be very careful about which accounts and groups you allow to shut down a domain controller or member server. When a domain controller is shut down, it is no longer available to process logons, serve Group Policy, and answer Lightweight Directory Access Protocol (LDAP) queries. If you shut down domain controllers that possess Flexible Single Master Operations (FSMO) roles, you can disable key domain functionality, such as processing logons for new passwordsthe Primary Domain Controller (PDC) Emulator role."
                    Enabled = $true
                    ExpectedValue = "Administrators, Backup Operators"
                    }
        "adb052b7_c17e_4b8c_86b8_d81b6a89af20" = @{
                    RuleId = ""
                    Name = " Ensure 'Store passwords using reversible encryption' is set to 'Disabled'"
                    FullDescription = "This policy setting determines whether the operating system stores passwords in a way that uses reversible encryption, which provides support for application protocols that require knowledge of the user's password for authentication purposes. Passwords that are stored with reversible encryption are essentially the same as plaintext versions of the passwords. The recommended state for this setting is: Disabled."
                    PotentialImpact = "If your organization uses either the CHAP authentication protocol through remote access or IAS services or Digest Authentication in IIS, you must configure this policy setting to Enabled. This setting is extremely dangerous to apply through Group Policy on a user-by-user basis, because it requires the appropriate user account object to be opened in Active Directory Users and Computers."
                    Vulnerability = "Enabling this policy setting allows the operating system to store passwords in a weaker format that is much more susceptible to compromise and weakens your system security."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "b8841a6a_97b1_485b_9f3c_e5ccef30d2e6" = @{
                    RuleId = ""
                    Name = " Ensure 'Take ownership of files or other objects' is set to 'Administrators'"
                    FullDescription = "This policy setting allows users to take ownership of files, folders, registry keys, processes, or threads. This user right bypasses any permissions that are in place to protect objects to give ownership to the specified user. The recommended state for this setting is: Administrators."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "Any users with the Take ownership of files or other objects user right can take control of any object, regardless of the permissions on that object, and then make any changes they wish to that object. Such changes could result in exposure of data, corruption of data, or a DoS condition."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "23d0f843_e7bf_40e9_82cb_6299b35e52ab" = @{
                    RuleId = ""
                    Name = "Increase a process working set"
                    FullDescription = "This privilege determines which user accounts can increase or decrease the size of a processs working set. The working set of a process is the set of memory pages currently visible to the process in physical RAM memory. These pages are resident and available for an application to use without triggering a page fault. The minimum and maximum working set sizes affect the virtual memory paging behavior of a process.


When configuring a user right in the SCM enter a comma delimited list of accounts. Accounts can be either local or located in Active Directory, they can be groups, users, or computers."
                    PotentialImpact = "0"
                    Vulnerability = "0"
                    Enabled = $true
                    ExpectedValue = "Administrators, Local Service"
                    }
        "ca5d1a59_f141_441d_a57e_6f8bdf078ff3" = @{
                    RuleId = ""
                    Name = "Audit Authorization Policy Change"
                    FullDescription = "This subcategory reports changes in authorization policy. Events for this subcategory include:

- 4704: A user right was assigned.
- 4705: A user right was removed.
- 4706: A new trust was created to a domain.
- 4707: A trust to a domain was removed.
- 4714: Encrypted data recovery policy was changed.

The recommended state for this setting is to include: Success."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "b2e8d5f9_3d4e_4b8b_b6a1_ddcd60f437b9" = @{
                    RuleId = ""
                    Name = " Ensure 'Configure registry policy processing: Process even if the Group Policy objects have not changed' is set to 'Enabled: TRUE'"
                    FullDescription = "The Process even if the Group Policy objects have not changed option updates and reapplies policies even if the policies have not changed. The recommended state for this setting is: Enabled: TRUE (checked)."
                    PotentialImpact = "Group Policies will be reapplied even if they have not been changed, which could have a slight impact on performance."
                    Vulnerability = "Setting this option to true (checked) will ensure unauthorized changes that might have been configured locally are forced to match the domain-based Group Policy settings again."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "29395413_af1d_4052_86c4_2b059fd4a778" = @{
                    RuleId = ""
                    Name = "Audit Directory Service Access"
                    FullDescription = "This subcategory reports when an AD DS object is accessed. Only objects with SACLs cause audit events to be generated, and only when they are accessed in a manner that matches their SACL. These events are similar to the directory service access events in previous versions of Windows Server. This subcategory applies only to Domain Controllers. Events for this subcategory include:

- 4662 : An operation was performed on an object.

The recommended state for this setting is to include: Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Failure"
                    }
        "6e6cd31c_e045_4b04_9fad_475aef45dd15" = @{
                    RuleId = ""
                    Name = "Audit Directory Service Changes"
                    FullDescription = "This subcategory reports changes to objects in Active Directory Domain Services (AD DS). The types of changes that are reported are create, modify, move, and undelete operations that are performed on an object. DS Change auditing, where appropriate, indicates the old and new values of the changed properties of the objects that were changed. Only objects with SACLs cause audit events to be generated, and only when they are accessed in a manner that matches their SACL. Some objects and properties do not cause audit events to be generated due to settings on the object class in the schema. This subcategory applies only to Domain Controllers. Events for this subcategory include:

- 5136 : A directory service object was modified.
- 5137 : A directory service object was created.
- 5138 : A directory service object was undeleted.
- 5139 : A directory service object was moved.

The recommended state for this setting is to include: Success."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "3b8a1eba_64e5_4117_b7bc_2cf5042de658" = @{
                    RuleId = ""
                    Name = "Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether all secure channel traffic that is initiated by the domain member must be signed or encrypted.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior. However, only Windows NT 4.0 with Service Pack 6a (SP6a) and subsequent versions of the Windows operating system support digital encryption and signing of the secure channel. Windows 98 Second Edition clients do not support it unless they have Dsclient installed. Therefore, you cannot enable the Domain member: Digitally encrypt or sign secure channel data (always) setting on Domain Controllers that support Windows 98 clients as members of the domain. Potential impacts can include the following:

- The ability to create or delete trust relationships with clients running versions of Windows earlier than Windows NT 4.0 with SP6a will be disabled.
- Logons from clients running versions of Windows earlier than Windows NT 4.0 with SP6a will be disabled.
- The ability to authenticate other domains' users from a Domain Controller running a version of Windows earlier than Windows NT 4.0 with SP6a in a trusted domain will be disabled.

You can enable this policy setting after you eliminate all Windows 9x clients from the domain and upgrade all Windows NT 4.0 servers and Domain Controllers from trusted/trusting domains to Windows NT 4.0 with SP6a."
                    Vulnerability = "When a computer joins a domain, a computer account is created. After it joins the domain, the computer uses the password for that account to create a secure channel with the Domain Controller for its domain every time that it restarts. Requests that are sent on the secure channel are authenticatedand sensitive information such as passwords are encryptedbut the channel is not integrity-checked, and not all information is encrypted.

Digital encryption and signing of the secure channel is a good idea where it is supported. The secure channel protects domain credentials as they are sent to the Domain Controller."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "915714e9_c2ae_42af_a391_c289db580e08" = @{
                    RuleId = ""
                    Name = "Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'"
                    FullDescription = "This policy setting determines whether a domain member should attempt to negotiate encryption for all secure channel traffic that it initiates.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior. However, only Windows NT 4.0 Service Pack 6a (SP6a) and subsequent versions of the Windows operating system support digital encryption and signing of the secure channel. Windows 98 Second Edition clients do not support it unless they have Dsclient installed."
                    Vulnerability = "When a computer joins a domain, a computer account is created. After it joins the domain, the computer uses the password for that account to create a secure channel with the Domain Controller for its domain every time that it restarts. Requests that are sent on the secure channel are authenticatedand sensitive information such as passwords are encryptedbut the channel is not integrity-checked, and not all information is encrypted.

Digital encryption and signing of the secure channel is a good idea where it is supported. The secure channel protects domain credentials as they are sent to the Domain Controller."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "b399c529_eeec_48dd_92e5_f1b2e14f12c9" = @{
                    RuleId = ""
                    Name = " Ensure 'Domain member: Digitally sign secure channel data ' is set to 'Enabled'"
                    FullDescription = "<p><span>This policy setting determines whether a domain member should attempt to negotiate whether all secure channel traffic that it initiates must be digitally signed. Digital signatures protect the traffic from being modified by anyone who captures the data as it traverses the network. The recommended state for this setting is: 'Enabled'.</span></p>"
                    PotentialImpact = "None - this is the default configuration. However, only Windows NT 4.0 with Service Pack 6a (SP6a) and subsequent versions of the Windows operating system support digital encryption and signing of the secure channel. Windows 98 Second Edition clients do not support it unless they have the Dsclient installed."
                    Vulnerability = "When a computer joins a domain, a computer account is created. After it joins the domain, the computer uses the password for that account to create a secure channel with the domain controller for its domain every time that it restarts. Requests that are sent on the secure channel are authenticatedand sensitive information such as passwords are encryptedbut the channel is not integrity-checked, and not all information is encrypted. Digital encryption and signing of the secure channel is a good idea where it is supported. The secure channel protects domain credentials as they are sent to the domain controller."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "e30d6758_fb3c_4e9d_8493_f717cd504cf4" = @{
                    RuleId = ""
                    Name = " Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'"
                    FullDescription = "This policy setting determines the maximum allowable age for a computer account password. By default, domain members automatically change their domain passwords every 30 days. If you increase this interval significantly so that the computers no longer change their passwords, an attacker would have more time to undertake a brute force attack against one of the computer accounts. The recommended state for this setting is: 30 or fewer days, but not 0. **Note:** A value of 0 does not conform to the benchmark as it disables maximum password age."
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "In Active Directory-based domains, each computer has an account and password just like every user. By default, the domain members automatically change their domain password every 30 days. If you increase this interval significantly, or set it to 0 so that the computers no longer change their passwords, an attacker will have more time to undertake a brute force attack to guess the password of one or more computer accounts."
                    Enabled = $true
                    ExpectedValue = "1,30"
                    }
        "ed9a6795_2803_4b77_9fc8_04f74aef49ed" = @{
                    RuleId = ""
                    Name = "Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'"
                    FullDescription = "When this policy setting is enabled, a secure channel can only be established with Domain Controllers that are capable of encrypting secure channel data with a strong (128-bit) session key.

To enable this policy setting, all Domain Controllers in the domain must be able to encrypt secure channel data with a strong key, which means all Domain Controllers must be running Microsoft Windows 2000 or newer.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior. However, computers will not be able to join Windows NT 4.0 domains, and trusts between Active Directory domains and Windows NT-style domains may not work properly. Also, Domain Controllers with this setting configured will not allow older pre-Windows 2000 clients (that that do not support this policy setting) to join the domain."
                    Vulnerability = "Session keys that are used to establish secure channel communications between Domain Controllers and member computers are much stronger in Windows 2000 than they were in previous Microsoft operating systems. Whenever possible, you should take advantage of these stronger session keys to help protect secure channel communications from attacks that attempt to hijack network sessions and eavesdropping. (Eavesdropping is a form of hacking in which network data is read or altered in transit. The data can be modified to hide or change the sender, or be redirected.)"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "5c532b76_16c0_4a8c_ac67_015b93f458dc" = @{
                    RuleId = ""
                    Name = "Audit IPsec Driver"
                    FullDescription = "This subcategory reports on the activities of the Internet Protocol security (IPsec) driver. Events for this subcategory include:

- 4960: IPsec dropped an inbound packet that failed an integrity check. If this problem persists, it could indicate a network issue or that packets are being modified in transit to this computer. Verify that the packets sent from the remote computer are the same as those received by this computer. This error might also indicate interoperability problems with other IPsec implementations.
- 4961: IPsec dropped an inbound packet that failed a replay check. If this problem persists, it could indicate a replay attack against this computer.
- 4962: IPsec dropped an inbound packet that failed a replay check. The inbound packet had too low a sequence number to ensure it was not a replay.
- 4963: IPsec dropped an inbound clear text packet that should have been secured. This is usually due to the remote computer changing its IPsec policy without informing this computer. This could also be a spoofing attack attempt.
- 4965: IPsec received a packet from a remote computer with an incorrect Security Parameter Index (SPI). This is usually caused by malfunctioning hardware that is corrupting packets. If these errors persist, verify that the packets sent from the remote computer are the same as those received by this computer. This error may also indicate interoperability problems with other IPsec implementations. In that case, if connectivity is not impeded, then these events can be ignored.
- 5478: IPsec Services has started successfully.
- 5479: IPsec Services has been shut down successfully. The shutdown of IPsec Services can put the computer at greater risk of network attack or expose the computer to potential security risks.
- 5480: IPsec Services failed to get the complete list of network interfaces on the computer. This poses a potential security risk because some of the network interfaces may not get the protection provided by the applied IPsec filters. Use the IP Security Monitor snap-in to diagnose the problem.
- 5483: IPsec Services failed to initialize RPC server. IPsec Services could not be started.
- 5484: IPsec Services has experienced a critical failure and has been shut down. The shutdown of IPsec Services can put the computer at greater risk of network attack or expose the computer to potential security risks.
- 5485: IPsec Services failed to process some IPsec filters on a plug-and-play event for network interfaces. This poses a potential security risk because some of the network interfaces may not get the protection provided by the applied IPsec filters. Use the IP Security Monitor snap-in to diagnose the problem.

The recommended state for this setting is: Success and Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "3f78e74e_1601_4bcc_b2c0_5408642d4b81" = @{
                    RuleId = ""
                    Name = "Audit Other System Events"
                    FullDescription = "This subcategory reports on other system events. Events for this subcategory include:

- 5024 : The Windows Firewall Service has started successfully.
- 5025 : The Windows Firewall Service has been stopped.
- 5027 : The Windows Firewall Service was unable to retrieve the security policy from the local storage. The service will continue enforcing the current policy.
- 5028 : The Windows Firewall Service was unable to parse the new security policy. The service will continue with currently enforced policy.
- 5029: The Windows Firewall Service failed to initialize the driver. The service will continue to enforce the current policy.
- 5030: The Windows Firewall Service failed to start.
- 5032: Windows Firewall was unable to notify the user that it blocked an application from accepting incoming connections on the network.
- 5033 : The Windows Firewall Driver has started successfully.
- 5034 : The Windows Firewall Driver has been stopped.
- 5035 : The Windows Firewall Driver failed to start.
- 5037 : The Windows Firewall Driver detected critical runtime error. Terminating.
- 5058: Key file operation.
- 5059: Key migration operation.

The recommended state for this setting is: Success and Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Capturing these audit events may be useful for identifying when the Windows Firewall is not performing as expected."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "824438cc_72b2_4a24_b13b_7ff0954f0130" = @{
                    RuleId = ""
                    Name = "Caching of logon credentials must be limited"
                    FullDescription = "This policy setting determines whether a user can log on to a Windows domain using cached account information. Logon information for domain accounts can be cached locally to allow users to log on even if a Domain Controller cannot be contacted. This policy setting determines the number of unique users for whom logon information is cached locally. If this value is set to 0, the logon cache feature is disabled. An attacker who is able to access the file system of the server could locate this cached information and use a brute force attack to determine user passwords.

The recommended state for this setting is: 4 or fewer logon(s)."
                    PotentialImpact = "Users will be unable to log on to any computers if there is no Domain Controller available to authenticate them. Organizations may want to configure this value to 2 for end-user computers, especially for mobile users. A configuration value of 2 means that the user's logon information will still be in the cache, even if a member of the IT department has recently logged on to their computer to perform system maintenance. This method allows users to log on to their computers when they are not connected to the organization's network."
                    Vulnerability = "The number that is assigned to this policy setting indicates the number of users whose logon information the computer will cache locally. If the number is set to 4, then the computer caches logon information for 4 users. When a 5th user logs on to the computer, the server overwrites the oldest cached logon session.

Users who access the computer console will have their logon credentials cached on that computer. An attacker who is able to access the file system of the computer could locate this cached information and use a brute force attack to attempt to determine user passwords. To mitigate this type of attack, Windows encrypts the information and obscures its physical location."
                    Enabled = $true
                    ExpectedValue = "1,4"
                    }
        "c1557cd3_5d47_42af_b4e0_993ec42cd697" = @{
                    RuleId = ""
                    Name = "The Application Compatibility Program Inventory must be prevented from collecting data and sending the information to Microsoft."
                    FullDescription = "Some features may communicate with the vendor, sending system information or downloading data or components for the feature. Turning off this capability will prevent potentially sensitive information from being sent outside the enterprise and will prevent uncontrolled updates to the system.

This setting will prevent the Program Inventory from collecting data about a system and sending the information to Microsoft."
                    PotentialImpact = ""
                    Vulnerability = ""
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "691b418f_e20e_4d4a_b084_3b7563f38879" = @{
                    RuleId = ""
                    Name = "Interactive logon: Machine inactivity limit"
                    FullDescription = "Windows notices inactivity of a logon session, and if the amount of inactive time exceeds the inactivity limit, then the screen saver will run, locking the session.

The recommended state for this setting is: 900 or fewer second(s), but not 0.

**Note:** A value of 0 does not conform to the benchmark as it disables the machine inactivity limit."
                    PotentialImpact = "The screen saver will automatically activate when the computer has been unattended for the amount of time specified. The impact should be minimal since the screen saver is enabled by default."
                    Vulnerability = "If a user forgets to lock their computer when they walk away it's possible that a passerby will hijack it."
                    Enabled = $true
                    ExpectedValue = "1,900"
                    }
        "a07ccc0e_fc6a_48d7_a46c_9c7d464c5439" = @{
                    RuleId = ""
                    Name = "Users must be required to enter a password to access private keys stored on the computer."
                    FullDescription = "If the private key is discovered, an attacker can use the key to authenticate as an authorized user and gain access to the network infrastructure.

The cornerstone of the PKI is the private key used to encrypt or digitally sign information.

If the private key is stolen, this will lead to the compromise of the authentication and non-repudiation gained through PKI because the attacker can use the private key to digitally sign documents and pretend to be the authorized user.

Both the holders of a digital certificate and the issuing authority must protect the computers, storage devices, or whatever they use to keep the private keys."
                    PotentialImpact = ""
                    Vulnerability = ""
                    Enabled = $true
                    ExpectedValue = "2"
                    }
        "b6285a67_7909_4ac1_9e0d_b156a1494b46" = @{
                    RuleId = ""
                    Name = "Windows Server must be configured to use FIPS-compliant algorithms for encryption, hashing, and signing."
                    FullDescription = "This setting ensures the system uses algorithms that are FIPS-compliant for encryption, hashing, and signing. FIPS-compliant algorithms meet specific standards established by the U.S. Government and must be the algorithms used for all OS encryption functions."
                    PotentialImpact = ""
                    Vulnerability = ""
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "403670e7_8c1b_4c09_81f8_9c2f3c3ebe30" = @{
                    RuleId = ""
                    Name = "Windows Server must be configured to prevent Internet Control Message Protocol (ICMP) redirects from overriding Open Shortest Path First (OSPF)-generated routes."
                    FullDescription = "Internet Control Message Protocol (ICMP) redirects cause the IPv4 stack to plumb host routes. These routes override the Open Shortest Path First (OSPF) generated routes.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "When Routing and Remote Access Service (RRAS) is configured as an autonomous system boundary router (ASBR), it does not correctly import connected interface subnet routes. Instead, this router injects host routes into the OSPF routes. However, the OSPF router cannot be used as an ASBR router, and when connected interface subnet routes are imported into OSPF the result is confusing routing tables with strange routing paths."
                    Vulnerability = "This behavior is expected. The problem is that the 10 minute time-out period for the ICMP redirect-plumbed routes temporarily creates a network situation in which traffic will no longer be routed properly for the affected host. Ignoring such ICMP redirects will limit the system's exposure to attacks that will impact its ability to participate on the network."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "feb86a88_2259_4ba0_b68e_2dbb7a43b4ce" = @{
                    RuleId = ""
                    Name = "Remote host allows delegation of non-exportable credentials"
                    FullDescription = "Remote host allows delegation of non-exportable credentials. When using credential delegation, devices provide an exportable version of credentials to the remote host. This exposes users to the risk of credential theft from attackers on the remote host. The Restricted Admin Mode and Windows Defender Remote Credential Guard features are two options to help protect against this risk.

The recommended state for this setting is: Enabled.

**Note:** More detailed information on Windows Defender Remote Credential Guard and how it compares to Restricted Admin Mode can be found at this link: [Protect Remote Desktop credentials with Windows Defender Remote Credential Guard (Windows 10) | Microsoft Docs](https://docs.microsoft.com/en-us/windows/access-protection/remote-credential-guard)"
                    PotentialImpact = "The host will support the _Restricted Admin Mode_ and _Windows Defender Remote Credential Guard_ features."
                    Vulnerability = "_Restricted Admin Mode_ was designed to help protect administrator accounts by ensuring that reusable credentials are not stored in memory on remote devices that could potentially be compromised.
_Windows Defender Remote Credential Guard_ helps you protect your credentials over a Remote Desktop connection by redirecting Kerberos requests back to the device that is requesting the connection.
Both features should be enabled and supported, as they reduce the chance of credential theft."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "4d909207_5803_4047_9b53_1d5029d8fe4e" = @{
                    RuleId = ""
                    Name = "Audit Kerberos Authentication Service"
                    FullDescription = "This subcategory reports the results of events generated after a Kerberos authentication TGT request. Kerberos is a distributed authentication service that allows a client running on behalf of a user to prove its identity to a server without sending data across the network. This helps mitigate an attacker or server from impersonating a user.

- 4768: A Kerberos authentication ticket (TGT) was requested.
- 4771: Kerberos pre-authentication failed.
- 4772: A Kerberos authentication ticket request failed.

The recommended state for this setting is: Success and Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may be useful when investigating a security incident."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "e40b12a5_37b5_44be_9824_97f4456924d9" = @{
                    RuleId = ""
                    Name = "Audit Directory Service Replication"
                    FullDescription = "This subcategory reports when replication between two domain controllers begins and ends. Events for this subcategory include:
- 4932: Synchronization of a replica of an Active Directory naming context has begun.
 4933: Synchronization of a replica of an Active Directory naming context has ended.
Refer to the Microsoft Knowledgebase article Description of security events in Windows Vista and in Windows Server 2008 for the most recent information about this setting: http:--support.microsoft.com-default.aspx-kb-947226"
                    PotentialImpact = "Audit Directory Service Replication determines whether the operating system generates audit events when replication between two domain controllers begins and ends"
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "No Auditing"
                    }
        "04212107_de72_4eb7_a427_1876b5604a98" = @{
                    RuleId = ""
                    Name = "Audit Detailed File Share"
                    FullDescription = "This subcategory allows you to audit attempts to access files and folders on a shared folder. Events for this subcategory include:

- 5145: network share object was checked to see whether client can be granted desired access.

The recommended state for this setting is to include: Failure"
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing the Failures will log which unauthorized users attempted (and failed) to get access to a file or folder on a network share on this computer, which could possibly be an indication of malicious intent."
                    Enabled = $true
                    ExpectedValue = "Failure"
                    }
        "88b87546_b3c8_434f_9cc6_01e117033296" = @{
                    RuleId = ""
                    Name = "Audit Other Policy Change Events"
                    FullDescription = "This subcategory contains events about EFS Data Recovery Agent policy changes, changes in Windows Filtering Platform filter, status on Security policy settings updates for local Group Policy settings, Central Access Policy changes, and detailed troubleshooting events for Cryptographic Next Generation (CNG) operations.

- 5063: A cryptographic provider operation was attempted.

- 5064: A cryptographic context operation was attempted.

- 5065: A cryptographic context modification was attempted.

- 5066: A cryptographic function operation was attempted.

- 5067: A cryptographic function modification was attempted.

- 5068: A cryptographic function provider operation was attempted.

- 5069: A cryptographic function property operation was attempted.

- 5070: A cryptographic function property modification was attempted.

- 6145: One or more errors occurred while processing security policy in the group policy objects.

The recommended state for this setting is to include: Failure."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "This setting can help detect errors in applied Security settings which came from Group Policy, and failure events related to Cryptographic Next Generation (CNG) functions."
                    Enabled = $true
                    ExpectedValue = "Failure"
                    }
        "C9A0B1BF_D925_48D6_8BC6_FB137B5D8C3D" = @{
                    RuleId = ""
                    Name = "Audit Distribution Group Management"
                    FullDescription = "This subcategory reports each event of distribution group management, such as when a distribution group is created, changed, or deleted or when a member is added to or removed from a distribution group. If you enable this Audit policy setting, administrators can track events to detect malicious, accidental, and authorized creation of group accounts. Events for this subcategory include:

- 4744: A security-disabled local group was created.
- 4745: A security-disabled local group was changed.
- 4746: A member was added to a security-disabled local group.
- 4747: A member was removed from a security-disabled local group.
- 4748: A security-disabled local group was deleted.
- 4749: A security-disabled global group was created.
- 4750: A security-disabled global group was changed.
- 4751: A member was added to a security-disabled global group.
- 4752: A member was removed from a security-disabled global group.
- 4753: A security-disabled global group was deleted.
- 4759: A security-disabled universal group was created.
- 4760: A security-disabled universal group was changed.
- 4761: A member was added to a security-disabled universal group.
- 4762: A member was removed from a security-disabled universal group.
- 4763: A security-disabled universal group was deleted.

The recommended state for this setting is to include: Success."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing these events may provide an organization with insight when investigating an incident. For example, when a given unauthorized user was added to a sensitive distribution group."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "164BCF05_B0FE_456F_8A25_04D7D920F88A" = @{
                    RuleId = ""
                    Name = "Audit Computer Account Management"
                    FullDescription = "This subcategory reports each event of computer account management, such as when a computer account is created, changed, deleted, renamed, disabled, or enabled. Events for this subcategory include:

- 4741: A computer account was created.
- 4742: A computer account was changed.
- 4743: A computer account was deleted.

The recommended state for this setting is to include: Success."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "Auditing events in this category may be useful when investigating an incident."
                    Enabled = $true
                    ExpectedValue = "Success"
                    }
        "a15a5700_6efb_46af_bf52_1b1104f2aa20" = @{
                    RuleId = ""
                    Name = "Block all consumer Microsoft account user authentication"
                    FullDescription = "This setting determines whether applications and services on the device can utilize new consumer Microsoft account authentication via the Windows OnlineID and WebAccountManager APIs.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "All applications and services on the device will be prevented from _new_ authentications using consumer Microsoft accounts via the Windows OnlineID and WebAccountManager APIs. Authentications performed directly by the user in web browsers or in apps that use OAuth will remain unaffected."
                    Vulnerability = "Organizations that want to effectively implement identity management policies and maintain firm control of what accounts are used on their computers will probably want to block Microsoft accounts. Organizations may also need to block Microsoft accounts in order to meet the requirements of compliance standards that apply to their information systems."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "071cf127_7766_4551_9a72_788c23f17442" = @{
                    RuleId = ""
                    Name = "Reset account lockout counter after"
                    FullDescription = "This policy setting determines the length of time before the Account lockout threshold resets to zero. The default value for this policy setting is Not Defined. If the Account lockout threshold is defined, this reset time must be less than or equal to the value for the Account lockout duration setting.

If you leave this policy setting at its default value or configure the value to an interval that is too long, your environment could be vulnerable to a DoS attack. An attacker could maliciously perform a number of failed logon attempts on all users in the organization, which will lock out their accounts. If no policy were determined to reset the account lockout, it would be a manual task for administrators. Conversely, if a reasonable time value is configured for this policy setting, users would be locked out for a set period until all of the accounts are unlocked automatically.

The recommended state for this setting is: 15 or more minute(s).

**Note:** Password Policy settings (section 1.1) and Account Lockout Policy settings (section 1.2) must be applied via the **Default Domain Policy** GPO in order to be globally in effect on **domain** user accounts as their default behavior. If these settings are configured in another GPO, they will only affect **local** user accounts on the computers that receive the GPO. However, custom exceptions to the default password policy and account lockout policy rules for specific domain users and/or groups can be defined using Password Settings Objects (PSOs), which are completely separate from Group Policy and most easily configured using Active Directory Administrative Center."
                    PotentialImpact = "If you do not configure this policy setting or if the value is configured to an interval that is too long, a DoS attack could occur. An attacker could maliciously attempt to log on to each user's account numerous times and lock out their accounts as described in the preceding paragraphs. If you do not configure the Reset account lockout counter after setting, administrators would have to manually unlock all accounts. If you configure this policy setting to a reasonable value the users would be locked out for some period, after which their accounts would unlock automatically. Be sure that you notify users of the values used for this policy setting so that they will wait for the lockout timer to expire before they call the help desk about their inability to log on."
                    Vulnerability = "Users can accidentally lock themselves out of their accounts if they mistype their password multiple times. To reduce the chance of such accidental lockouts, the Reset account lockout counter after setting determines the number of minutes that must elapse before the counter that tracks failed logon attempts and triggers lockouts is reset to 0."
                    Enabled = $true
                    ExpectedValue = "15"
                    }
        "2c4d3323_de56_450a_acda_75b55f60dba2" = @{
                    RuleId = ""
                    Name = "Account lockout threshold"
                    FullDescription = "This policy setting determines the number of failed logon attempts before the account is locked. Setting this policy to 0 does not conform to the benchmark as doing so disables the account lockout threshold.

The recommended state for this setting is: 5 or fewer invalid logon attempt(s), but not 0.

**Note:** Password Policy settings (section 1.1) and Account Lockout Policy settings (section 1.2) must be applied via the **Default Domain Policy** GPO in order to be globally in effect on **domain** user accounts as their default behavior. If these settings are configured in another GPO, they will only affect **local** user accounts on the computers that receive the GPO. However, custom exceptions to the default password policy and account lockout policy rules for specific domain users and/or groups can be defined using Password Settings Objects (PSOs), which are completely separate from Group Policy and most easily configured using Active Directory Administrative Center."
                    PotentialImpact = "If this policy setting is enabled, a locked-out account will not be usable until it is reset by an administrator or until the account lockout duration expires. This setting may generate additional help desk calls.

If you enforce this setting an attacker could cause a denial of service condition by deliberately generating failed logons for multiple user, therefore you should also configure the Account Lockout Duration to a relatively low value.

If you configure the Account Lockout Threshold to 0, there is a possibility that an attacker's attempt to discover passwords with a brute force password attack might go undetected if a robust audit mechanism is not in place."
                    Vulnerability = "Setting an account lockout threshold reduces the likelihood that an online password brute force attack will be successful. Setting the account lockout threshold too low introduces risk of increased accidental lockouts and/or a malicious actor intentionally locking out accounts."
                    Enabled = $true
                    ExpectedValue = "1,3"
                    }
        "b5c7204a_96b7_4fb9_a7fa_5201b89f5146" = @{
                    RuleId = ""
                    Name = "Turn on PowerShell Script Block Logging"
                    FullDescription = "This policy setting enables logging of all PowerShell script input to the Applications and Services Logs\Microsoft\Windows\PowerShell\Operational Event Log channel.

The recommended state for this setting is: Enabled.

**Note:** If logging of _Script Block Invocation Start/Stop Events_ is enabled (option box checked), PowerShell will log additional events when invocation of a command, script block, function, or script starts or stops. Enabling this option generates a high volume of event logs. CIS has intentionally chosen not to make a recommendation for this option, since it generates a large volume of events. **If an organization chooses to enable the optional setting (checked), this also conforms to the benchmark.**"
                    PotentialImpact = "PowerShell script input will be logged to the Applications and Services Logs\Microsoft\Windows\PowerShell\Operational Event Log channel, which can contain credentials and sensitive information.

**Warning:** There are potential risks of capturing credentials and sensitive information in the PowerShell logs, which could be exposed to users who have read-access to those logs. Microsoft provides a feature called Protected Event Logging to better secure event log data. For assistance with protecting event logging, visit: [About Logging Windows - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logging_windows?view=powershell-7.2#protected-event-logging)."
                    Vulnerability = "Logs of PowerShell script input can be very valuable when performing forensic investigations of PowerShell attack incidents to determine what occurred."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "f7d5fa8e_54ed_4e3e_a531_8ed38114bdab" = @{
                    RuleId = ""
                    Name = "Debug programs"
                    FullDescription = "This policy setting determines which user accounts will have the right to attach a debugger to any process or to the kernel, which provides complete access to sensitive and critical operating system components. Developers who are debugging their own applications do not need to be assigned this user right; however, developers who are debugging new system components will need it.

The recommended state for this setting is: Administrators.

**Note:** This user right is considered a sensitive privilege for the purposes of auditing."
                    PotentialImpact = "If you revoke this user right, no one will be able to debug programs. However, typical circumstances rarely require this capability on production computers. If a problem arises that requires an application to be debugged on a production server, you can move the server to a different OU temporarily and assign the **Debug programs** user right to a separate Group Policy for that OU.

The service account that is used for the cluster service needs the **Debug programs** user right; if it does not have it, Windows Clustering will fail.

Tools that are used to manage processes will be unable to affect processes that are not owned by the person who runs the tools. For example, the Windows Server 2003 Resource Kit tool Kill.exe requires this user right for administrators to terminate processes that they did not start."
                    Vulnerability = "The **Debug programs** user right can be exploited to capture sensitive computer information from system memory, or to access and modify kernel or application structures. Some attack tools exploit this user right to extract hashed passwords and other private security information, or to insert rootkit code. By default, the **Debug programs** user right is assigned only to administrators, which helps to mitigate the risk from this vulnerability."
                    Enabled = $true
                    ExpectedValue = "Administrators"
                    }
        "8718a173_58d6_42ab_a37d_0819c398b5f5" = @{
                    RuleId = ""
                    Name = "The Impersonate a client after authentication user right must only be assigned to Administrators, Service, Local Service, and Network Service."
                    FullDescription = "The policy setting allows programs that run on behalf of a user to impersonate that user (or another specified account) so that they can act on behalf of the user. If this user right is required for this kind of impersonation, an unauthorized user will not be able to convince a client to connectfor example, by remote procedure call (RPC) or named pipesto a service that they have created to impersonate that client, which could elevate the unauthorized user's permissions to administrative or system levels.

Services that are started by the Service Control Manager have the built-in Service group added by default to their access tokens. COM servers that are started by the COM infrastructure and configured to run under a specific account also have the Service group added to their access tokens. As a result, these processes are assigned this user right when they are started.

Also, a user can impersonate an access token if any of the following conditions exist:
- The access token that is being impersonated is for this user.
- The user, in this logon session, logged on to the network with explicit credentials to create the access token.
- The requested level is less than Impersonate, such as Anonymous or Identify.

An attacker with the **Impersonate a client after authentication** user right could create a service, trick a client to make them connect to the service, and then impersonate that client to elevate the attacker's level of access to that of the client.

The recommended state for this setting is: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE.

**Note:** This user right is considered a sensitive privilege for the purposes of auditing.

**Note #2:** A Member Server with Microsoft SQL Server _and_ its optional Integration Services component installed will require a special exception to this recommendation for additional SQL-generated entries to be granted this user right."
                    PotentialImpact = "In most cases this configuration will have no impact. If you have installed the _Web Server (IIS)_ Role with _Web Services_ Role Service, you will need to also assign the user right to IIS_IUSRS."
                    Vulnerability = "An attacker with the **Impersonate a client after authentication** user right could create a service, trick a client to make them connect to the service, and then impersonate that client to elevate the attacker's level of access to that of the client."
                    Enabled = $true
                    ExpectedValue = "Administrators,Service,Local Service,Network Service"
                    }
        "99cd4fc9_bcf1_4def_8ce6_5a3c4ea8f8c9" = @{
                    RuleId = ""
                    Name = " Ensure 'Configure registry policy processing: Do not apply during periodic background processing' is set to 'Enabled: False'"
                    FullDescription = "The Do not apply during periodic background processing option prevents the system from updating affected policies in the background while the computer is in use. When background updates are disabled, policy changes will not take effect until the next user logon or system restart. The recommended state for this setting is: Enabled: FALSE (unchecked)."
                    PotentialImpact = "Group Policies will be reapplied every time they are refreshed, which could have a slight impact on performance."
                    Vulnerability = "Setting this option to false (unchecked) will ensure that domain policy changes take effect more quickly, as compared to waiting until the next user logon or system restart."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "cb4110e4_23c8_46ab_9202_497a70efd077" = @{
                    RuleId = ""
                    Name = " Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'"
                    FullDescription = "<p><span>This policy setting determines whether a domain member can periodically change its computer account password. Computers that cannot automatically change their account passwords are potentially vulnerable, because an attacker might be able to determine the password for the system's domain account. The recommended state for this setting is: 'Disabled'.</span></p>"
                    PotentialImpact = "None - this is the default configuration."
                    Vulnerability = "The default configuration for Windows Server 2003-based computers that belong to a domain is that they are automatically required to change the passwords for their accounts every 30 days. If you disable this policy setting, computers that run Windows Server 2003 will retain the same passwords as their computer accounts. Computers that are no longer able to automatically change their account password are at risk from an attacker who could determine the password for the computer's domain account."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "1926dc04_79ea_4a6e_9e35_892c27876bf5" = @{
                    RuleId = ""
                    Name = "Audit File Share"
                    FullDescription = "This policy setting allows you to audit attempts to access a shared folder.

The recommended state for this setting is: Success and Failure.

**Note:** There are no system access control lists (SACLs) for shared folders. If this policy setting is enabled, access to all shared folders on the system is audited."
                    PotentialImpact = "If no audit settings are configured, or if audit settings are too lax on the computers in your organization, security incidents might not be detected or not enough evidence will be available for network forensic analysis after security incidents occur. However, if audit settings are too severe, critically important entries in the Security log may be obscured by all of the meaningless entries and computer performance and the available amount of data storage may be seriously affected. Companies that operate in certain regulated industries may have legal obligations to log certain events or activities."
                    Vulnerability = "In an enterprise managed environment, it's important to track deletion, creation, modification, and access events for network shares. Any unusual file sharing activity may be useful in an investigation of potentially malicious activity."
                    Enabled = $true
                    ExpectedValue = "Success and Failure"
                    }
        "16394616_4a4d_4416_9985_b8a3251eb70c" = @{
                    RuleId = ""
                    Name = "Disable SMB v1 client (remove dependency on LanmanWorkstation)"
                    FullDescription = "SMBv1 is a legacy protocol that uses the MD5 algorithm as part of SMB. MD5 is known to be vulnerable to a number of attacks such as collision and preimage attacks as well as not being FIPS compliant."
                    PotentialImpact = ""
                    Vulnerability = ""
                    Enabled = $true
                    ExpectedValue = "Bowser|#|MRxSmb20|#|NSI"
                    }
        "20670f2c_01b1_4f5b_9dff_023c697babdb" = @{
                    RuleId = ""
                    Name = "Encryption Oracle Remediation for CredSSP protocol"
                    FullDescription = "Some versions of the CredSSP protocol that is used by some applications (such as Remote Desktop Connection) are vulnerable to an encryption oracle attack against the client. This policy controls compatibility with vulnerable clients and servers and allows you to set the level of protection desired for the encryption oracle vulnerability.

The recommended state for this setting is: Enabled: Force Updated Clients."
                    PotentialImpact = "Client applications which use CredSSP will not be able to fall back to the insecure versions and services using CredSSP will not accept unpatched clients. This setting should not be deployed until all remote hosts support the newest version, which is achieved by ensuring that all Microsoft security updates at least through May 2018 are installed."
                    Vulnerability = "This setting is important to mitigate the CredSSP encryption oracle vulnerability, for which information was published by Microsoft on 03/13/2018 in [CVE-2018-0886 | CredSSP Remote Code Execution Vulnerability](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-0886). All versions of Windows Server from Server 2008 (non-R2) onwards are affected by this vulnerability, and will be compatible with this recommendation provided that they have been patched up through May 2018 (or later)."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "336d9398_7f8b_4743_bf48_9bddc7906984" = @{
                    RuleId = ""
                    Name = "WDigest Authentication"
                    FullDescription = "When WDigest authentication is enabled, Lsass.exe retains a copy of the user's plaintext password in memory, where it can be at risk of theft. If this setting is not configured, WDigest authentication is disabled in Windows 8.1 and in Windows Server 2012 R2; it is enabled by default in earlier versions of Windows and Windows Server.

For more information about local accounts and credential theft, review the [Mitigating Pass-the-Hash (PtH) Attacks and Other Credential Theft Techniques](http://www.microsoft.com/en-us/download/details.aspx?id=36036) documents.

For more information about UseLogonCredential, see Microsoft Knowledge Base article 2871997: [Microsoft Security Advisory Update to improve credentials protection and management May 13, 2014](https://support.microsoft.com/en-us/kb/2871997).

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is also the default configuration for Server 2012 R2 and newer."
                    Vulnerability = "Preventing the plaintext storage of credentials in memory may reduce opportunity for credential theft."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "f1943ce4_9d62_4aff_aa89_d8ddcab0173e" = @{
                    RuleId = ""
                    Name = "Adjust memory quotas for a process"
                    FullDescription = "This policy setting allows a user to adjust the maximum amount of memory that is available to a process. The ability to adjust memory quotas is useful for system tuning, but it can be abused. In the wrong hands, it could be used to launch a denial of service (DoS) attack.

The recommended state for this setting is: Administrators, LOCAL SERVICE, NETWORK SERVICE.

**Note:** A Member Server that holds the _Web Server (IIS)_ Role with _Web Server_ Role Service will require a special exception to this recommendation, to allow IIS application pool(s) to be granted this user right.

**Note #2:** A Member Server with Microsoft SQL Server installed will require a special exception to this recommendation for additional SQL-generated entries to be granted this user right."
                    PotentialImpact = "Organizations that have not restricted users to roles with limited privileges will find it difficult to impose this countermeasure. Also, if you have installed optional components such as ASP.NET or IIS, you may need to assign the **Adjust memory quotas for a process** user right to additional accounts that are required by those components. Otherwise, this countermeasure should have no impact on most computers. If this user right is necessary for a user account, it can be assigned to a local computer account instead of a domain account."
                    Vulnerability = "A user with the **Adjust memory quotas for a process** user right can reduce the amount of memory that is available to any process, which could cause business-critical network applications to become slow or to fail. In the wrong hands, this privilege could be used to start a denial of service (DoS) attack."
                    Enabled = $true
                    ExpectedValue = "Administrators, Local Service, Network Service"
                    }
        "c4718464_3486_4a14_9cfe_8ef78e8ec56b" = @{
                    RuleId = ""
                    Name = "Accounts: Block Microsoft accounts"
                    FullDescription = "This policy setting prevents users from adding new Microsoft accounts on this computer.

The recommended state for this setting is: Users can't add or log on with Microsoft accounts."
                    PotentialImpact = "Users will not be able to log onto the computer with their Microsoft account."
                    Vulnerability = "Organizations that want to effectively implement identity management policies and maintain firm control of what accounts are used to log onto their computers will probably want to block Microsoft accounts. Organizations may also need to block Microsoft accounts in order to meet the requirements of compliance standards that apply to their information systems."
                    Enabled = $true
                    ExpectedValue = "3"
                    }
        "e8b0cc71_407d_4de9_a8db_4c60ef3ac70a" = @{
                    RuleId = ""
                    Name = "Accounts: Rename administrator account"
                    FullDescription = "The built-in local administrator account is a well-known account name that attackers will target. It is recommended to choose another name for this account, and to avoid names that denote administrative or elevated access accounts. Be sure to also change the default description for the local administrator (through the Computer Management console). On Domain Controllers, since they do not have their own local accounts, this rule refers to the built-in Administrator account that was established when the domain was first created."
                    PotentialImpact = "You will have to inform users who are authorized to use this account of the new account name. (The guidance for this setting assumes that the Administrator account was not disabled, which was recommended earlier in this chapter.)"
                    Vulnerability = "The Administrator account exists on all computers that run the Windows 2000 or newer operating systems. If you rename this account, it is slightly more difficult for unauthorized persons to guess this privileged user name and password combination.

The built-in Administrator account cannot be locked out, regardless of how many times an attacker might use a bad password. This capability makes the Administrator account a popular target for brute force attacks that attempt to guess passwords. The value of this countermeasure is lessened because this account has a well-known SID, and there are third-party tools that allow authentication by using the SID rather than the account name. Therefore, even if you rename the Administrator account, an attacker could launch a brute force attack by using the SID to log on."
                    Enabled = $true
                    ExpectedValue = "Administrator"
                    }
        "032b9c30_0082_4199_b1ae_2f1fcafd59c6" = @{
                    RuleId = ""
                    Name = "Interactive logon: Prompt user to change password before expiration"
                    FullDescription = "This policy setting determines how far in advance users are warned that their password will expire. It is recommended that you configure this policy setting to at least 5 days but no more than 14 days to sufficiently warn users when their passwords will expire.

The recommended state for this setting is: between 5 and 14 days."
                    PotentialImpact = "Users will see a dialog box prompt to change their password each time that they log on to the domain when their password is configured to expire between 5 and 14 days."
                    Vulnerability = "It is recommended that user passwords be configured to expire periodically. Users will need to be warned that their passwords are going to expire, or they may inadvertently be locked out of the computer when their passwords expire. This condition could lead to confusion for users who access the network locally, or make it impossible for users to access your organization's network through dial-up or virtual private network (VPN) connections."
                    Enabled = $true
                    ExpectedValue = "5,14"
                    }
        "e9118234_b52b_4b54_ae1a_893a63fe859d" = @{
                    RuleId = ""
                    Name = "Microsoft network server: Server SPN target name validation level"
                    FullDescription = "This policy setting controls the level of validation a computer with shared folders or printers (the server) performs on the service principal name (SPN) that is provided by the client computer when it establishes a session using the server message block (SMB) protocol.

The server message block (SMB) protocol provides the basis for file and print sharing and other networking operations, such as remote Windows administration. The SMB protocol supports validating the SMB server service principal name (SPN) within the authentication blob provided by a SMB client to prevent a class of attacks against SMB servers referred to as SMB relay attacks. This setting will affect both SMB1 and SMB2.

The recommended state for this setting is: Accept if provided by client. Configuring this setting to Required from client also conforms to the benchmark.

**Note:** Since the release of the MS [KB3161561](https://support.microsoft.com/en-us/kb/3161561) security patch, this setting can cause significant issues (such as replication problems, group policy editing issues and blue screen crashes) on Domain Controllers when used _simultaneously_ with UNC path hardening (i.e. Rule 18.5.14.1). **CIS therefore recommends against deploying this setting on Domain Controllers.**"
                    PotentialImpact = "All Windows operating systems support both a client-side SMB component and a server-side SMB component. This setting affects the server SMB behavior, and its implementation should be carefully evaluated and tested to prevent disruptions to file and print serving capabilities.

If configured to Accept if provided by client, the SMB server will accept and validate the SPN provided by the SMB client and allow a session to be established if it matches the SMB servers list of SPNs for itself. If the SPN does NOT match, the session request for that SMB client will be denied.

If configured to Required from client, the SMB client MUST send a SPN name in session setup, and the SPN name provided MUST match the SMB server that is being requested to establish a connection. If no SPN is provided by client, or the SPN provided does not match, the session is denied."
                    Vulnerability = "The identity of a computer can be spoofed to gain unauthorized access to network resources."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "16f2e42a_e89d_43a3_b904_cb4d312a8e4a" = @{
                    RuleId = ""
                    Name = "Network access: Allow anonymous SID/Name translation"
                    FullDescription = "This policy setting determines whether an anonymous user can request security identifier (SID) attributes for another user, or use a SID to obtain its corresponding user name.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "If this policy setting is enabled, a user with local access could use the well-known Administrator's SID to learn the real name of the built-in Administrator account, even if it has been renamed. That person could then use the account name to initiate a password guessing attack."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "514725e3_fa3e_4f3a_9d58_a31449937003" = @{
                    RuleId = ""
                    Name = "Limits print driver installation to Administrators"
                    FullDescription = "This policy setting controls whether users that aren't Administrators can install print drivers on the system.

The recommended state for this setting is: Enabled.

**Note:** On August 10, 2021, Microsoft announced a [Point and Print Default Behavior Change](https://msrc-blog.microsoft.com/2021/08/10/point-and-print-default-behavior-change/) which modifies the default Point and Print driver installation and update behavior to require Administrator privileges. This is documented in [KB5005652Manage new Point and Print default driver installation behavior (CVE-2021-34481)](https://support.microsoft.com/en-gb/topic/kb5005652-manage-new-point-and-print-default-driver-installation-behavior-cve-2021-34481-873642bf-2634-49c5-a23b-6d8e9a302872)."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "Restricting the installation of print drives to Administrators can help mitigate the PrintNightmare vulnerability ([CVE-2021-34527](https://support.microsoft.com/en-gb/topic/kb5005652-manage-new-point-and-print-default-driver-installation-behavior-cve-2021-34481-873642bf-2634-49c5-a23b-6d8e9a302872)) and other Print Spooler attacks."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "d74f926c_8ee5_4f06_8c59_2871197d8f41" = @{
                    RuleId = ""
                    Name = "Hardened UNC Paths - NETLOGON"
                    FullDescription = "This policy setting configures secure access to UNC paths"
                    PotentialImpact = "Windows only allows access to the specified UNC paths after fulfilling additional security requirements"
                    Vulnerability = "In February 2015, Microsoft released a new control mechanism to mitigate a security risk in Group Policy as part of the MS15-011 / MSKB 3000483 security update. This mechanism requires both the installation of the new security update and also the deployment of specific group policy settings to all computers on the domain from Windows Vista / Server 2008 (non-R2) or newer (the associated security patch to enable this feature was not released for Server 2003). A new group policy template (NetworkProvider.admx/adml) was also provided with the security update"
                    Enabled = $true
                    ExpectedValue = "RequireMutualAuthentication=1, RequireIntegrity=1"
                    }
        "da9fef3f_5a75_43e0_aa0a_d1d8c23af706" = @{
                    RuleId = ""
                    Name = "Hardened UNC Paths - SYSVOL"
                    FullDescription = "This policy setting configures secure access to UNC paths"
                    PotentialImpact = "Windows only allows access to the specified UNC paths after fulfilling additional security requirements"
                    Vulnerability = "In February 2015, Microsoft released a new control mechanism to mitigate a security risk in Group Policy as part of the MS15-011 / MSKB 3000483 security update. This mechanism requires both the installation of the new security update and also the deployment of specific group policy settings to all computers on the domain from Windows Vista / Server 2008 (non-R2) or newer (the associated security patch to enable this feature was not released for Server 2003). A new group policy template (NetworkProvider.admx/adml) was also provided with the security update"
                    Enabled = $true
                    ExpectedValue = "RequireMutualAuthentication=1, RequireIntegrity=1"
                    }
        "589fad5b_4d43_4f88_92d4_33af8dba19d6" = @{
                    RuleId = ""
                    Name = "Turn off background refresh of Group Policy"
                    FullDescription = "This policy setting prevents Group Policy from being updated while the computer is in use. This policy setting applies to Group Policy for computers, users and Domain Controllers.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "This setting ensures that group policy changes take effect more quickly, as compared to waiting until the next user logon or system restart."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "0644341a_0db8_4ff6_8bfe_5751a9b3d1dc" = @{
                    RuleId = ""
                    Name = "Enumerate local users on domain-joined computers"
                    FullDescription = "This policy setting allows local users to be enumerated on domain-joined computers.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "A malicious user could use this feature to gather account names of other users, that information could then be used in conjunction with other types of attacks such as guessing passwords or social engineering. The value of this countermeasure is small because a user with domain credentials could gather the same account information using other methods."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "d2d187ef_0321_4e5e_95aa_ac03f16e6373" = @{
                    RuleId = ""
                    Name = "Configure Attack Surface Reduction rules"
                    FullDescription = "This policy setting controls the state for the Attack Surface Reduction (ASR) rules.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "When a rule is triggered, a notification will be displayed from the Action Center."
                    Vulnerability = "Attack surface reduction helps prevent actions and apps that are typically used by exploit-seeking malware to infect machines."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "ca8da650_4a25_46fa_8aff_2a4b498de6a5" = @{
                    RuleId = ""
                    Name = "Prevent users and apps from accessing dangerous websites"
                    FullDescription = "This policy setting controls Microsoft Defender Exploit Guard network protection. 

The recommended state for this setting is: Enabled: Block."
                    PotentialImpact = "Users and applications will not be able to access dangerous domains."
                    Vulnerability = "This setting can help prevent employees from using any application to access dangerous domains that may host phishing scams, exploit-hosting sites, and other malicious content on the Internet."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "3085af32_217a_4e4b_ba6c_a81c342f8d2c" = @{
                    RuleId = ""
                    Name = "Do not allow drive redirection"
                    FullDescription = "This policy setting prevents users from sharing the local drives on their client computers to Remote Desktop Servers that they access. Mapped drives appear in the session folder tree in Windows Explorer in the following format:

\\TSClient\<driveletter>

If local drives are shared they are left vulnerable to intruders who want to exploit the data that is stored on them.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "Drive redirection will not be possible. In most situations, traditional network drive mapping to file shares (including administrative shares) performed manually by the connected user will serve as a capable substitute to still allow file transfers when needed."
                    Vulnerability = "Data could be forwarded from the user's Remote Desktop Services session to the user's local computer without any direct user interaction. Malicious software already present on a compromised server would have direct and stealthy disk access to the user's local computer during the Remote Desktop session."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "181da750_0ecf_4af3_8724_ab1d6718fd6b" = @{
                    RuleId = ""
                    Name = "Turn on PowerShell Transcription"
                    FullDescription = "This Policy setting lets you capture the input and output of Windows PowerShell commands into text-based transcripts.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "If this setting is enabled there is a risk that passwords could get stored in plain text in the PowerShell_transcript output file."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "ee69b98c_4bce_4af5_88b9_b8cee25b7524" = @{
                    RuleId = ""
                    Name = "Prevent users from modifying settings"
                    FullDescription = "This policy setting prevent users from making changes to the Exploit protection settings area in the Windows Security settings.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "Local users cannot make changes in the Exploit protection settings area."
                    Vulnerability = "Only authorized IT staff should be able to make changes to the exploit protection settings in order to ensure the organizations specific configuration is not modified."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "2f9a914c_e88c_401b_9c21_5ddb94b31b4a" = @{
                    RuleId = ""
                    Name = "Enable Structured Exception Handling Overwrite Protection (SEHOP)"
                    FullDescription = "Windows includes support for Structured Exception Handling Overwrite Protection (SEHOP). We recommend enabling this feature to improve the security profile of the computer.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "After you enable SEHOP, existing versions of Cygwin, Skype, and Armadillo-protected applications may not work correctly."
                    Vulnerability = "This feature is designed to block exploits that use the Structured Exception Handler (SEH) overwrite technique. This protection mechanism is provided at run-time. Therefore, it helps protect applications regardless of whether they have been compiled with the latest improvements, such as the /SAFESEH option."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "d1a15c43_08e0_4d7f_a3f1_e8253fa2083e" = @{
                    RuleId = ""
                    Name = "NetBT NodeType configuration"
                    FullDescription = "This setting determines which method NetBIOS over TCP/IP (NetBT) uses to register and resolve names. The available methods are:

- The B-node (broadcast) method only uses broadcasts.
- The P-node (point-to-point) method only uses name queries to a name server (WINS).
- The M-node (mixed) method broadcasts first, then queries a name server (WINS) if broadcast failed.
- The H-node (hybrid) method queries a name server (WINS) first, then broadcasts if the query failed.

The recommended state for this setting is: Enabled: P-node (recommended) (point-to-point).

**Note:** Resolution through LMHOSTS or DNS follows these methods. If the NodeType registry value is present, it overrides any DhcpNodeType registry value. If neither NodeType nor DhcpNodeType is present, the computer uses B-node (broadcast) if there are no WINS servers configured for the network, or H-node (hybrid) if there is at least one WINS server configured."
                    PotentialImpact = "NetBIOS name resolution queries will require a defined and available WINS server for external NetBIOS name resolution. If a WINS server is not defined or not reachable, and the desired hostname is not defined in the local cache, local LMHOSTS or HOSTS files, NetBIOS name resolution will fail."
                    Vulnerability = "In order to help mitigate the risk of NetBIOS Name Service (NBT-NS) poisoning attacks, setting the node type to P-node (point-to-point) will prevent the system from sending out NetBIOS broadcasts."
                    Enabled = $true
                    ExpectedValue = "2"
                    }
        "ae110ac5_8387_464d_8790_e29ffce8f8d9" = @{
                    RuleId = ""
                    Name = "MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning"
                    FullDescription = "This setting can generate a security audit in the Security event log when the log reaches a user-defined threshold.

The recommended state for this setting is: Enabled: 90% or less.

**Note:** If log settings are configured to Overwrite events as needed or Overwrite events older than x days, this event will not be generated."
                    PotentialImpact = "An audit event will be generated when the Security log reaches the 90% percent full threshold (or whatever lower value may be set) unless the log is configured to overwrite events as needed."
                    Vulnerability = "If the Security log reaches 90 percent of its capacity and the computer has not been configured to overwrite events as needed, more recent events will not be written to the log. If the log reaches its capacity and the computer has been configured to shut down when it can no longer record events to the Security log, the computer will shut down and will no longer be available to provide network services."
                    Enabled = $true
                    ExpectedValue = "90"
                    }
        "d0b4769e_bbfa_4fe0_b6e8_1fd4977d76dd" = @{
                    RuleId = ""
                    Name = "MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing)"
                    FullDescription = "IP source routing is a mechanism that allows the sender to determine the IP route that a datagram should follow through the network.

The recommended state for this setting is: Enabled: Highest protection, source routing is completely disabled."
                    PotentialImpact = "All incoming source routed packets will be dropped."
                    Vulnerability = "An attacker could use source routed packets to obscure their identity and location. Source routing allows a computer that sends a packet to specify the route that the packet takes."
                    Enabled = $true
                    ExpectedValue = "2"
                    }
        "8f624a01_c694_4d61_9d85_bf6d9a4be86d" = @{
                    RuleId = ""
                    Name = "MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers"
                    FullDescription = "NetBIOS over TCP/IP is a network protocol that among other things provides a way to easily resolve NetBIOS names that are registered on Windows-based systems to the IP addresses that are configured on those systems. This setting determines whether the computer releases its NetBIOS name when it receives a name-release request.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "The NetBT protocol is designed not to use authentication, and is therefore vulnerable to spoofing. Spoofing makes a transmission appear to come from a user other than the user who performed the action. A malicious user could exploit the unauthenticated nature of the protocol to send a name-conflict datagram to a target computer, which would cause the computer to relinquish its name and not respond to queries.

An attacker could send a request over the network and query a computer to release its NetBIOS name. As with any change that could affect applications, it is recommended that you test this change in a non-production environment before you change the production environment.

The result of such an attack could be to cause intermittent connectivity issues on the target computer, or even to prevent the use of Network Neighborhood, domain logons, the NET SEND command, or additional NetBIOS name resolution."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "e1b7d5ea_8e40_47ae_b53e_910959c6649e" = @{
                    RuleId = ""
                    Name = "MSS: (SafeDllSearchMode) Enable Safe DLL search mode (recommended)"
                    FullDescription = "The DLL search order can be configured to search for DLLs that are requested by running processes in one of two ways:

- Search folders specified in the system path first, and then search the current working folder.
- Search current working folder first, and then search the folders specified in the system path.

When enabled, the registry value is set to 1. With a setting of 1, the system first searches the folders that are specified in the system path and then searches the current working folder. When disabled the registry value is set to 0 and the system first searches the current working folder and then searches the folders that are specified in the system path.

Applications will be forced to search for DLLs in the system path first. For applications that require unique versions of these DLLs that are included with the application, this entry could cause performance or stability problems.

The recommended state for this setting is: Enabled.

**Note:** More information on how Safe DLL search mode works is available at this link: [Dynamic-Link Library Search Order - Windows applications | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order)"
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "If a user unknowingly executes hostile code that was packaged with additional files that include modified versions of system DLLs, the hostile code could load its own versions of those DLLs and potentially increase the type and degree of damage the code can render."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "4a1c7313_02f4_46a3_a16f_5b4a12db44e4" = @{
                    RuleId = ""
                    Name = "Do not enumerate connected users on domain-joined computers"
                    FullDescription = "This policy setting prevents connected users from being enumerated on domain-joined computers.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "The Logon UI will not enumerate any connected users on domain-joined computers."
                    Vulnerability = "A malicious user could use this feature to gather account names of other users, that information could then be used in conjunction with other types of attacks such as guessing passwords or social engineering. The value of this countermeasure is small because a user with domain credentials could gather the same account information using other methods."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "dd3e3ed2_65d2_484f_b909_c9001e347671" = @{
                    RuleId = ""
                    Name = "Turn off cloud consumer account state content"
                    FullDescription = "This policy setting determines whether cloud consumer account state content is allowed in all Windows experiences. 

The recommended state for this setting is: Enabled."
                    PotentialImpact = "Users will not be able to use Microsoft consumer accounts on the system."
                    Vulnerability = "The use of consumer accounts in an enterprise managed environment is not good security practice as it could lead to possible data leakage."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "1eb84c57_2252_466d_8504_c7d34fce2126" = @{
                    RuleId = ""
                    Name = "Turn on e-mail scanning"
                    FullDescription = "This policy setting allows you to configure e-mail scanning. When e-mail scanning is enabled, the engine will parse the mailbox and mail files, according to their specific format, in order to analyze the mail bodies and attachments. Several e-mail formats are currently supported, for example: pst (Outlook), dbx, mbx, mime (Outlook Express), binhex (Mac).

The recommended state for this setting is: Enabled."
                    PotentialImpact = "E-mail scanning by Microsoft Defender Antivirus will be enabled."
                    Vulnerability = "Incoming e-mails should be scanned by an antivirus solution such as Microsoft Defender Antivirus, as email attachments are a commonly used attack vector to infiltrate computers with malicious software."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "dcb8d6a6_45b5_4c3c_8f12_86e0c3680a72" = @{
                    RuleId = ""
                    Name = "Configure detection for potentially unwanted applications"
                    FullDescription = "This policy setting controls detection and action for Potentially Unwanted Applications (PUA), which are sneaky unwanted application bundlers or their bundled applications, that can deliver adware or malware.

The recommended state for this setting is: Enabled: Block.

For more information, see this link: [Block potentially unwanted applications with Microsoft Defender Antivirus | Microsoft Docs](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-antivirus/detect-block-potentially-unwanted-apps-windows-defender-antivirus)"
                    PotentialImpact = "Applications that are identified by Microsoft as PUA will be blocked at download and install time."
                    Vulnerability = "Potentially unwanted applications can increase the risk of your network being infected with malware, cause malware infections to be harder to identify, and can waste IT resources in cleaning up the applications. They should be blocked from installation."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "f569293f_f00a_4f11_803c_b1fd2fecd7d8" = @{
                    RuleId = ""
                    Name = "Turn off Microsoft Defender AntiVirus"
                    FullDescription = "This policy setting turns off Microsoft Defender Antivirus. If the setting is configured to Disabled, Microsoft Defender Antivirus runs and computers are scanned for malware and other potentially unwanted software.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "It is important to ensure a current, updated antivirus product is scanning each computer for malicious file activity. Microsoft provides a competent solution out of the box in Microsoft Defender Antivirus.

Organizations that choose to purchase a reputable 3rd-party antivirus solution may choose to exempt themselves from this recommendation in lieu of the commercial alternative."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "d243297a_f2a7_49b3_850c_28ceddcd6a5f" = @{
                    RuleId = ""
                    Name = "Scan all downloaded files and attachments"
                    FullDescription = "This policy setting configures scanning for all downloaded files and attachments.

The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "When running an antivirus solution such as Microsoft Defender Antivirus, it is important to ensure that it is configured to heuristically monitor in real-time for suspicious and known malicious activity."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "822cb00e_9414_44af_9ff3_20bedf3dfe54" = @{
                    RuleId = ""
                    Name = "Turn off real-time protection"
                    FullDescription = "This policy setting configures real-time protection prompts for known malware detection.

Microsoft Defender Antivirus alerts you when malware or potentially unwanted software attempts to install itself or to run on your computer.

The recommended state for this setting is: Disabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "When running an antivirus solution such as Microsoft Defender Antivirus, it is important to ensure that it is configured to heuristically monitor in real-time for suspicious and known malicious activity."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "23d573d1_0d29_435c_bbc9_509b3c9cfa60" = @{
                    RuleId = ""
                    Name = "Turn on script scanning"
                    FullDescription = "This policy setting allows script scanning to be turned on/off. Script scanning intercepts scripts then scans them before they are executed on the system. 

The recommended state for this setting is: Enabled."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "When running an antivirus solution such as Microsoft Defender Antivirus, it is important to ensure that it is configured to heuristically monitor in real-time for suspicious and known malicious activity."
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "02e555c8_7deb_4fab_a565_d018af8ba39e" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Domain: Logging: Name"
                    FullDescription = "Use this option to specify the path and name of the file in which Windows Firewall will write its log information.

The recommended state for this setting is: %SystemRoot%\System32\logfiles\firewall\domainfw.log."
                    PotentialImpact = "The log file will be stored in the specified file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "%SystemRoot%\System32\logfiles\firewall\domainfw.log"
                    }
        "c67e4967_4e36_4d6a_b1ee_bad7cd747c7c" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Domain: Logging: Size limit (KB)"
                    FullDescription = "Use this option to specify the size limit of the file in which Windows Firewall will write its log information.

The recommended state for this setting is: 16,384 KB or greater."
                    PotentialImpact = "The log file size will be limited to the specified size, old events will be overwritten by newer ones when the limit is reached."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "16384"
                    }
        "df94d448_eb5c_40f8_a2c1_35af6ba6e566" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Domain: Logging: Log dropped packets"
                    FullDescription = "Use this option to log when Windows Firewall with Advanced Security discards an inbound packet for any reason. The log records why and when the packet was dropped. Look for entries with the word DROP in the action column of the log.

The recommended state for this setting is: Yes."
                    PotentialImpact = "Information about dropped packets will be recorded in the firewall log file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "7a9e9e07_2e95_48ec_9a3b_7ee693e35711" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Domain: Logging: Log successful connections"
                    FullDescription = "Use this option to log when Windows Firewall with Advanced Security allows an inbound connection. The log records why and when the connection was formed. Look for entries with the word ALLOW in the action column of the log.

The recommended state for this setting is: Yes."
                    PotentialImpact = "Information about successful connections will be recorded in the firewall log file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "52bb00ec_987c_4f16_a81d_96ef84259bea" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Private: Inbound connections"
                    FullDescription = "This setting determines the behavior for inbound connections that do not match an inbound firewall rule.

The recommended state for this setting is: Block (default)."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "If the firewall allows all traffic to access the system then an attacker may be more easily able to remotely exploit a weakness in a network service."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "1196a355_37e4_4a6f_8a8e_740db0d73f09" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Domain: Inbound connections"
                    FullDescription = "This setting determines the behavior for inbound connections that do not match an inbound firewall rule.

The recommended state for this setting is: Block (default)."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "If the firewall allows all traffic to access the system then an attacker may be more easily able to remotely exploit a weakness in a network service."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "4c40870a_fe76_4e52_a71c_8344d17a9bc3" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Private: Logging: Name"
                    FullDescription = "Use this option to specify the path and name of the file in which Windows Firewall will write its log information.

The recommended state for this setting is: %SystemRoot%\System32\logfiles\firewall\privatefw.log."
                    PotentialImpact = "The log file will be stored in the specified file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "%SystemRoot%\System32\logfiles\firewall\privatefw.log"
                    }
        "c3bdeda2_0740_42b6_aac2_7d7234f3a557" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Private: Logging: Size limit (KB)"
                    FullDescription = "Use this option to specify the size limit of the file in which Windows Firewall will write its log information.

The recommended state for this setting is: 16,384 KB or greater."
                    PotentialImpact = "The log file size will be limited to the specified size, old events will be overwritten by newer ones when the limit is reached."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "16384"
                    }
        "be3bba5f_7bd3_4574_b6c2_93341e01b8c0" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Private: Logging: Log dropped packets"
                    FullDescription = "Use this option to log when Windows Firewall with Advanced Security discards an inbound packet for any reason. The log records why and when the packet was dropped. Look for entries with the word DROP in the action column of the log.

The recommended state for this setting is: Yes."
                    PotentialImpact = "Information about dropped packets will be recorded in the firewall log file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "396f1552_406d_4b58_b4a6_fc56c75eb70a" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Private: Logging: Log successful connections"
                    FullDescription = "Use this option to log when Windows Firewall with Advanced Security allows an inbound connection. The log records why and when the connection was formed. Look for entries with the word ALLOW in the action column of the log.

The recommended state for this setting is: Yes."
                    PotentialImpact = "Information about successful connections will be recorded in the firewall log file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "2f38577d_b711_4eb3_bdc8_b423fc013ed2" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Public: Logging: Log successful connections"
                    FullDescription = "Use this option to log when Windows Firewall with Advanced Security allows an inbound connection. The log records why and when the connection was formed. Look for entries with the word ALLOW in the action column of the log.

The recommended state for this setting is: Yes."
                    PotentialImpact = "Information about successful connections will be recorded in the firewall log file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "d33c1242_a351_4a00_8a0c_0b50f44441ef" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Public: Inbound connections"
                    FullDescription = "This setting determines the behavior for inbound connections that do not match an inbound firewall rule.

The recommended state for this setting is: Block (default)."
                    PotentialImpact = "None - this is the default behavior."
                    Vulnerability = "If the firewall allows all traffic to access the system then an attacker may be more easily able to remotely exploit a weakness in a network service."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "2614f6be_da8e_4dbc_89d9_7ba4d63564c7" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Public: Logging: Name"
                    FullDescription = "Use this option to specify the path and name of the file in which Windows Firewall will write its log information.

The recommended state for this setting is: %SystemRoot%\System32\logfiles\firewall\publicfw.log."
                    PotentialImpact = "The log file will be stored in the specified file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "%SystemRoot%\System32\logfiles\firewall\publicfw.log"
                    }
        "8c115a38_7ea4_4aa8_9115_c78e31bdb411" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Public: Logging: Size limit (KB)"
                    FullDescription = "Use this option to specify the size limit of the file in which Windows Firewall will write its log information.

The recommended state for this setting is: 16,384 KB or greater."
                    PotentialImpact = "The log file size will be limited to the specified size, old events will be overwritten by newer ones when the limit is reached."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "16384"
                    }
        "4ef05db7_7bdc_4a89_b488_31893914e994" = @{
                    RuleId = ""
                    Name = "Windows Firewall: Public: Logging: Log dropped packets"
                    FullDescription = "Use this option to log when Windows Firewall with Advanced Security discards an inbound packet for any reason. The log records why and when the packet was dropped. Look for entries with the word DROP in the action column of the log.

The recommended state for this setting is: Yes."
                    PotentialImpact = "Information about dropped packets will be recorded in the firewall log file."
                    Vulnerability = "If events are not recorded it may be difficult or impossible to determine the root cause of system problems or the unauthorized activities of malicious users."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "5cde9936_ffd5_4aca_9f05_6699353ed3ce" = @{
                    RuleId = ""
                    Name = "Account Lockout Duration"
                    FullDescription = "This policy setting determines the length of time that must pass before a locked account is unlocked and a user can try to log on again. The setting does this by specifying the number of minutes a locked out account will remain unavailable. If the value for this policy setting is configured to 0, locked out accounts will remain locked out until an administrator manually unlocks them.

Although it might seem like a good idea to configure the value for this policy setting to a high value, such a configuration will likely increase the number of calls that the help desk receives to unlock accounts locked by mistake. Users should be aware of the length of time a lock remains in place, so that they realize they only need to call the help desk if they have an extremely urgent need to regain access to their computer.

The recommended state for this setting is: 15 or more minute(s).

**Note:** Password Policy settings (section 1.1) and Account Lockout Policy settings (section 1.2) must be applied via the **Default Domain Policy** GPO in order to be globally in effect on **domain** user accounts as their default behavior. If these settings are configured in another GPO, they will only affect **local** user accounts on the computers that receive the GPO. However, custom exceptions to the default password policy and account lockout policy rules for specific domain users and/or groups can be defined using Password Settings Objects (PSOs), which are completely separate from Group Policy and most easily configured using Active Directory Administrative Center."
                    PotentialImpact = "Although it may seem like a good idea to configure this policy setting to never automatically unlock an account, such a configuration can increase the number of requests that your organization's help desk receives to unlock accounts that were locked by mistake."
                    Vulnerability = "A denial of service (DoS) condition can be created if an attacker abuses the Account lockout threshold and repeatedly attempts to log on with a specific account. Once you configure the Account lockout threshold setting, the account will be locked out after the specified number of failed attempts. If you configure the Account lockout duration setting to 0, then the account will remain locked out until an administrator unlocks it manually."
                    Enabled = $true
                    ExpectedValue = "15"
                    }
        "276603c5_bd48_407a_949f_6dbbb5b3f61d" = @{
                    RuleId = ""
                    Name = "MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing)"
                    FullDescription = "IP source routing is a mechanism that allows the sender to determine the IP route that a datagram should take through the network. It is recommended to configure this setting to Not Defined for enterprise environments and to Highest Protection for high security environments to completely disable source routing.

The recommended state for this setting is: Enabled: Highest protection, source routing is completely disabled."
                    PotentialImpact = "All incoming source routed packets will be dropped."
                    Vulnerability = "An attacker could use source routed packets to obscure their identity and location. Source routing allows a computer that sends a packet to specify the route that the packet takes."
                    Enabled = $true
                    ExpectedValue = "2"
                    }
        "202b60aa_5854_458d_a315_f394c7660df8" = @{
                    RuleId = ""
                    Name = "Enable virtualization based security"
                    FullDescription = "Virtualization-based security, or VBS, uses hardware virtualization features to create and isolate a secure region of memory from the normal operating system. This helps to ensure that servers remain devoted to running critical workloads and helps protect related applications and data from attack and exfiltration. VBS is enabled and locked by default on Azure Stack HCI."
                    PotentialImpact = "Protections and OS security features relies on VBS, such as Credential Guard, Hypervisor enforced code integrity, secure enclave, etc. will not function."
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "3783b34c_f774_4034_99f0_3e53874d559e" = @{
                    RuleId = ""
                    Name = "Enable hypervisor enforced code integrity"
                    FullDescription = "HVCI and VBS improve the threat model of Windows and provide stronger protections against malware trying to exploit the Windows Kernel. HVCI is a critical component that protects and hardens the isolated virtual environment created by VBS by running kernel mode code integrity within it and restricting kernel memory allocations that could be used to compromise the system."
                    PotentialImpact = "Without HVCI, your VBS environment is not protected from unsigned-codes to execute in the Windows kernel."
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "61156130_85d1_4609_9cd5_01351a0ca7c3" = @{
                    RuleId = ""
                    Name = "Enable system guard"
                    FullDescription = "Using processor support for Dynamic Root of Trust of Measurement (DRTM) technology, System Guard put firmware in a hardware-based sandbox helping to limit the impact of vulnerabilities in millions of lines of highly privileged firmware code. "
                    PotentialImpact = "Servers without System Guard are less protected against firmware level attacks."
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "0"
                    }
        "16281d26_36b2_49a7_8592_974bfce3f975" = @{
                    RuleId = ""
                    Name = "Enable secure boot"
                    FullDescription = "Secure boot is a security standard developed by members of the PC industry to help make sure that a device boots using only software that is trusted by the Original Equipment Manufacturer (OEM)."
                    PotentialImpact = "Servers without Secure boot are less protected against attackes targeting the boot chain."
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "e0780d07_8f0c_4b4a_a4a1_1237f7d2e6d0" = @{
                    RuleId = ""
                    Name = "Set TPM version"
                    FullDescription = "Trusted Platform Module (TPM) technology is designed to provide hardware-based, security-related functions. TPM2.0 is required for the Secured-core features."
                    PotentialImpact = "Servers without TPM lack a protected store for sensitive keys and data, such as measurements of the components loaded during boot. "
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "2.0"
                    }
        "1b954f4b_ac61_478a_8ad9_75f953a6e76a" = @{
                    RuleId = ""
                    Name = "Enable boot DMA protection"
                    FullDescription = "Secured-core capable servers support system firmware which provides protection against malicious and unintended Direct Memory Access (DMA) attacks for all DMA-capable devices during the boot process."
                    PotentialImpact = "Servers without boot DMA protection is less protected against DMA attacks during the boot process."
                    Vulnerability = "NA"
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "d11ed6f2_03ae_4deb_94d9_096b7e6789cb" = @{
                    RuleId = ""
                    Name = "Prevent device metadata retrieval from the Internet"
                    FullDescription = "This policy setting allows you to prevent Windows from retrieving device metadata from the Internet. 

The recommended state for this setting is: Enabled.

**Note:** This will not prevent the installation of basic hardware drivers, but does prevent associated 3rd-party utility software from automatically being installed under the context of the SYSTEM account."
                    PotentialImpact = "Standard users without administrator privileges will not be able to install associated 3rd-party utility software for peripheral devices. This may limit the use of advanced features of those devices unless/until an administrator installs the associated utility software for the device."
                    Vulnerability = "Installation of software should be conducted by an authorized system administrator and not a standard user. Allowing automatic 3rd-party software installations under the context of the SYSTEM account has potential for allowing unauthorized access via backdoors or installation software bugs."
                    Enabled = $true
                    ExpectedValue = "1"
                    }
        "36f1578b_8702_488a_b213_6e30963e8958" = @{
                    RuleId = ""
                    Name = "Interactive logon: Message text for users attempting to log on"
                    FullDescription = "This policy setting specifies a text message that displays to users when they log on. Configure this setting in a manner that is consistent with the security and operational requirements of your organization."
                    PotentialImpact = "Users will have to acknowledge a dialog box containing the configured text before they can log on to the computer.

**Note:** Windows Vista and Windows XP Professional support logon banners that can exceed 512 characters in length and that can also contain carriage-return line-feed sequences. However, Windows 2000-based clients cannot interpret and display these messages. You must use a Windows 2000-based computer to create a logon message policy that applies to Windows 2000-based computers."
                    Vulnerability = "Displaying a warning message before logon may help prevent an attack by warning the attacker about the consequences of their misconduct before it happens. It may also help to reinforce corporate policy by notifying employees of the appropriate policy during the logon process. This text is often used for legal reasonsfor example, to warn users about the ramifications of misusing company information or to warn them that their actions may be audited.

**Note:** Any warning that you display should first be approved by your organization's legal and human resources representatives."
                    Enabled = $true
                    ExpectedValue = ""
                    }
        "80cb1237_8de9_4124_b6bc_b077e67f2557" = @{
                    RuleId = ""
                    Name = "Interactive logon: Message title for users attempting to log on"
                    FullDescription = "This policy setting specifies the text displayed in the title bar of the window that users see when they log on to the system. Configure this setting in a manner that is consistent with the security and operational requirements of your organization."
                    PotentialImpact = "Users will have to acknowledge a dialog box with the configured title before they can log on to the computer."
                    Vulnerability = "Displaying a warning message before logon may help prevent an attack by warning the attacker about the consequences of their misconduct before it happens. It may also help to reinforce corporate policy by notifying employees of the appropriate policy during the logon process."
                    Enabled = $true
                    ExpectedValue = ""
                    }
        "a1272685_6a0d_4008_9d40_fc5c83a8fd8f" = @{
                    RuleId = ""
                    Name = "Accounts: Rename guest account"
                    FullDescription = "The built-in local guest account is another well-known name to attackers. It is recommended to rename this account to something that does not indicate its purpose. Even if you disable this account, which is recommended, ensure that you rename it for added security. On Domain Controllers, since they do not have their own local accounts, this rule refers to the built-in Guest account that was established when the domain was first created."
                    PotentialImpact = "There should be little impact, because the Guest account is disabled by default."
                    Vulnerability = "The Guest account exists on all computers that run the Windows 2000 or newer operating systems. If you rename this account, it is slightly more difficult for unauthorized persons to guess this privileged user name and password combination."
                    Enabled = $true
                    ExpectedValue = "Guest"
                    }
    }
}
