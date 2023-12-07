Configuration AzureOSBaseline 
{
    Import-DscResource -ModuleName GuestConfiguration
    if( $ConfigurationData.NonNodeData."MSID 60".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure logging is configured"
        {
            Msid = "60"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure logging is configured"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 63.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure logger configuration files are restricted."
        {
            Msid = "63.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure logger configuration files are restricted."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 98".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure at/cron is restricted to authorized users"
        {
            Msid = "98"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure at/cron is restricted to authorized users"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 111".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure remote login warning banner is configured properly."
        {
            Msid = "111"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure remote login warning banner is configured properly."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 111.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure local login warning banner is configured properly."
        {
            Msid = "111.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure local login warning banner is configured properly."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 162".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure auditd service is enabled"
        {
            Msid = "162"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure auditd service is enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 163".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Run AuditD service"
        {
            Msid = "163"
            BaselineName = "ASC.Linux"
            PolicyName = "Run AuditD service"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.21.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure mounting of USB storage devices is disabled"
        {
            Msid = "1.1.21.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure mounting of USB storage devices is disabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 2.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The nodev option should be enabled for all removable media."
        {
            Msid = "2.1"
            BaselineName = "ASC.Linux"
            PolicyName = "The nodev option should be enabled for all removable media."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 2.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The noexec option should be enabled for all removable media."
        {
            Msid = "2.2"
            BaselineName = "ASC.Linux"
            PolicyName = "The noexec option should be enabled for all removable media."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 2.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The nosuid option should be enabled for all removable media."
        {
            Msid = "2.3"
            BaselineName = "ASC.Linux"
            PolicyName = "The nosuid option should be enabled for all removable media."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The nodev/nosuid option should be enabled for all NFS mounts."
        {
            Msid = "5"
            BaselineName = "ASC.Linux"
            PolicyName = "The nodev/nosuid option should be enabled for all NFS mounts."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable the installation and use of file systems that are not required (cramfs)"
        {
            Msid = "6.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable the installation and use of file systems that are not required (cramfs)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable the installation and use of file systems that are not required (freevxfs)"
        {
            Msid = "6.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable the installation and use of file systems that are not required (freevxfs)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable the installation and use of file systems that are not required (hfs)"
        {
            Msid = "6.3"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable the installation and use of file systems that are not required (hfs)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable the installation and use of file systems that are not required (hfsplus)"
        {
            Msid = "6.4"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable the installation and use of file systems that are not required (hfsplus)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable the installation and use of file systems that are not required (jffs2)"
        {
            Msid = "6.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable the installation and use of file systems that are not required (jffs2)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 10".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Kernels should only be compiled from approved sources."
        {
            Msid = "10"
            BaselineName = "ASC.Linux"
            PolicyName = "Kernels should only be compiled from approved sources."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 11.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/shadow file permissions should be set to 0400"
        {
            Msid = "11.1"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/shadow file permissions should be set to 0400"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 11.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/shadow- file permissions should be set to 0400"
        {
            Msid = "11.2"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/shadow- file permissions should be set to 0400"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 11.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/gshadow file permissions should be set to 0400"
        {
            Msid = "11.3"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/gshadow file permissions should be set to 0400"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 11.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/gshadow- file permissions should be set to 0400"
        {
            Msid = "11.4"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/gshadow- file permissions should be set to 0400"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 12.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/passwd file permissions should be 0644"
        {
            Msid = "12.1"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/passwd file permissions should be 0644"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 12.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/group file permissions should be 0644"
        {
            Msid = "12.2"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/group file permissions should be 0644"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 12.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/passwd- file permissions should be set to 0644"
        {
            Msid = "12.3"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/passwd- file permissions should be set to 0644"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 12.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "/etc/group- file permissions should be 0644"
        {
            Msid = "12.4"
            BaselineName = "ASC.Linux"
            PolicyName = "/etc/group- file permissions should be 0644"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 21".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Access to the root account via su should be restricted to the 'root' group"
        {
            Msid = "21"
            BaselineName = "ASC.Linux"
            PolicyName = "Access to the root account via su should be restricted to the 'root' group"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 22".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The 'root' group should exist, and contain all members who can su to root"
        {
            Msid = "22"
            BaselineName = "ASC.Linux"
            PolicyName = "The 'root' group should exist, and contain all members who can su to root"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 23.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "All accounts should have a password"
        {
            Msid = "23.2"
            BaselineName = "ASC.Linux"
            PolicyName = "All accounts should have a password"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 24".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Accounts other than root must have unique UIDs greater than zero(0)"
        {
            Msid = "24"
            BaselineName = "ASC.Linux"
            PolicyName = "Accounts other than root must have unique UIDs greater than zero(0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 25".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Randomized placement of virtual memory regions should be enabled"
        {
            Msid = "25"
            BaselineName = "ASC.Linux"
            PolicyName = "Randomized placement of virtual memory regions should be enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 26".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Kernel support for the XD/NX processor feature should be enabled"
        {
            Msid = "26"
            BaselineName = "ASC.Linux"
            PolicyName = "Kernel support for the XD/NX processor feature should be enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 27.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The '.' should not appear in root's $PATH"
        {
            Msid = "27.1"
            BaselineName = "ASC.Linux"
            PolicyName = "The '.' should not appear in root's $PATH"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 28".Enabled -eq $true ) {
        ASM_LinuxAuditResource "User home directories should be mode 750 or more restrictive"
        {
            Msid = "28"
            BaselineName = "ASC.Linux"
            PolicyName = "User home directories should be mode 750 or more restrictive"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 29".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The default umask for all users should be set to 077 in login.defs"
        {
            Msid = "29"
            BaselineName = "ASC.Linux"
            PolicyName = "The default umask for all users should be set to 077 in login.defs"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 31".Enabled -eq $true ) {
        ASM_LinuxAuditResource "All bootloaders should have password protection enabled."
        {
            Msid = "31"
            BaselineName = "ASC.Linux"
            PolicyName = "All bootloaders should have password protection enabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 31.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on bootloader config are configured"
        {
            Msid = "31.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on bootloader config are configured"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 33".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure authentication required for single user mode."
        {
            Msid = "33"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure authentication required for single user mode."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 38.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure packet redirect sending is disabled."
        {
            Msid = "38.3"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure packet redirect sending is disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 38.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.accept_redirects = 0)"
        {
            Msid = "38.4"
            BaselineName = "ASC.Linux"
            PolicyName = "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.accept_redirects = 0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 38.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.secure_redirects = 0)"
        {
            Msid = "38.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.secure_redirects = 0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 40.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Accepting source routed packets should be disabled for all interfaces. (net.ipv4.conf.all.accept_source_route = 0)"
        {
            Msid = "40.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Accepting source routed packets should be disabled for all interfaces. (net.ipv4.conf.all.accept_source_route = 0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 40.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Accepting source routed packets should be disabled for all interfaces. (net.ipv6.conf.all.accept_source_route = 0)"
        {
            Msid = "40.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Accepting source routed packets should be disabled for all interfaces. (net.ipv6.conf.all.accept_source_route = 0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 42.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The default setting for accepting source routed packets should be disabled for network interfaces. (net.ipv4.conf.default.accept_source_route = 0)"
        {
            Msid = "42.1"
            BaselineName = "ASC.Linux"
            PolicyName = "The default setting for accepting source routed packets should be disabled for network interfaces. (net.ipv4.conf.default.accept_source_route = 0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 42.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The default setting for accepting source routed packets should be disabled for network interfaces. (net.ipv6.conf.default.accept_source_route = 0)"
        {
            Msid = "42.2"
            BaselineName = "ASC.Linux"
            PolicyName = "The default setting for accepting source routed packets should be disabled for network interfaces. (net.ipv6.conf.default.accept_source_route = 0)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 43".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ignoring bogus ICMP responses to broadcasts should be enabled. (net.ipv4.icmp_ignore_bogus_error_responses = 1)"
        {
            Msid = "43"
            BaselineName = "ASC.Linux"
            PolicyName = "Ignoring bogus ICMP responses to broadcasts should be enabled. (net.ipv4.icmp_ignore_bogus_error_responses = 1)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 44".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ignoring ICMP echo requests (pings) sent to broadcast / multicast addresses should be enabled. (net.ipv4.icmp_echo_ignore_broadcasts = 1)"
        {
            Msid = "44"
            BaselineName = "ASC.Linux"
            PolicyName = "Ignoring ICMP echo requests (pings) sent to broadcast / multicast addresses should be enabled. (net.ipv4.icmp_echo_ignore_broadcasts = 1)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 45.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Logging of martian packets (those with impossible addresses) should be enabled for all interfaces. (net.ipv4.conf.all.log_martians = 1) and (net.ipv4.conf.default.log_martians = 1)"
        {
            Msid = "45.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Logging of martian packets (those with impossible addresses) should be enabled for all interfaces. (net.ipv4.conf.all.log_martians = 1) and (net.ipv4.conf.default.log_martians = 1)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 46.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.all.rp_filter = 1)"
        {
            Msid = "46.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.all.rp_filter = 1)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 46.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.default.rp_filter = 1)"
        {
            Msid = "46.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.default.rp_filter = 1)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 47".Enabled -eq $true ) {
        ASM_LinuxAuditResource "TCP SYN cookies should be enabled. (net.ipv4.tcp_syncookies = 1)"
        {
            Msid = "47"
            BaselineName = "ASC.Linux"
            PolicyName = "TCP SYN cookies should be enabled. (net.ipv4.tcp_syncookies = 1)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 48".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The system should not act as a network sniffer."
        {
            Msid = "48"
            BaselineName = "ASC.Linux"
            PolicyName = "The system should not act as a network sniffer."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 49".Enabled -eq $true ) {
        ASM_LinuxAuditResource "All wireless interfaces should be disabled."
        {
            Msid = "49"
            BaselineName = "ASC.Linux"
            PolicyName = "All wireless interfaces should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 50".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The IPv6 protocol should be enabled."
        {
            Msid = "50"
            BaselineName = "ASC.Linux"
            PolicyName = "The IPv6 protocol should be enabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 54".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure DCCP is disabled"
        {
            Msid = "54"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure DCCP is disabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 55".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SCTP is disabled"
        {
            Msid = "55"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SCTP is disabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 56".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable support for RDS."
        {
            Msid = "56"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable support for RDS."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 57".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure TIPC is disabled"
        {
            Msid = "57"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure TIPC is disabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 61".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The syslog, rsyslog, or syslog-ng package should be installed."
        {
            Msid = "61"
            BaselineName = "ASC.Linux"
            PolicyName = "The syslog, rsyslog, or syslog-ng package should be installed."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 61.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The systemd-journald service should be configured to persists log messages"
        {
            Msid = "61.1"
            BaselineName = "ASC.Linux"
            PolicyName = "The systemd-journald service should be configured to persists log messages"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 62".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure a logging service is enabled"
        {
            Msid = "62"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure a logging service is enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 63".Enabled -eq $true ) {
        ASM_LinuxAuditResource "File permissions for all rsyslog log files should be set to 640 or 600."
        {
            Msid = "63"
            BaselineName = "ASC.Linux"
            PolicyName = "File permissions for all rsyslog log files should be set to 640 or 600."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 64".Enabled -eq $true ) {
        ASM_LinuxAuditResource "All rsyslog log files should be owned by the adm group."
        {
            Msid = "64"
            BaselineName = "ASC.Linux"
            PolicyName = "All rsyslog log files should be owned by the adm group."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 65".Enabled -eq $true ) {
        ASM_LinuxAuditResource "All rsyslog log files should be owned by the syslog user."
        {
            Msid = "65"
            BaselineName = "ASC.Linux"
            PolicyName = "All rsyslog log files should be owned by the syslog user."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 67".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Rsyslog should not accept remote messages."
        {
            Msid = "67"
            BaselineName = "ASC.Linux"
            PolicyName = "Rsyslog should not accept remote messages."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 68".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The logrotate (syslog rotater) service should be enabled."
        {
            Msid = "68"
            BaselineName = "ASC.Linux"
            PolicyName = "The logrotate (syslog rotater) service should be enabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 69".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The rlogin service should be disabled."
        {
            Msid = "69"
            BaselineName = "ASC.Linux"
            PolicyName = "The rlogin service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 70.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable inetd unless required. (inetd)"
        {
            Msid = "70.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable inetd unless required. (inetd)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 70.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable xinetd unless required. (xinetd)"
        {
            Msid = "70.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable xinetd unless required. (xinetd)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 71.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Install inetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
        {
            Msid = "71.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Install inetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 71.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Install xinetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
        {
            Msid = "71.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Install xinetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 72".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The telnet service should be disabled."
        {
            Msid = "72"
            BaselineName = "ASC.Linux"
            PolicyName = "The telnet service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 73".Enabled -eq $true ) {
        ASM_LinuxAuditResource "All telnetd packages should be uninstalled."
        {
            Msid = "73"
            BaselineName = "ASC.Linux"
            PolicyName = "All telnetd packages should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 74".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The rcp/rsh service should be disabled."
        {
            Msid = "74"
            BaselineName = "ASC.Linux"
            PolicyName = "The rcp/rsh service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 77".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The rsh-server package should be uninstalled."
        {
            Msid = "77"
            BaselineName = "ASC.Linux"
            PolicyName = "The rsh-server package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 78".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The ypbind service should be disabled."
        {
            Msid = "78"
            BaselineName = "ASC.Linux"
            PolicyName = "The ypbind service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 79".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The nis package should be uninstalled."
        {
            Msid = "79"
            BaselineName = "ASC.Linux"
            PolicyName = "The nis package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 80".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The tftp service should be disabled."
        {
            Msid = "80"
            BaselineName = "ASC.Linux"
            PolicyName = "The tftp service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 81".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The tftpd package should be uninstalled."
        {
            Msid = "81"
            BaselineName = "ASC.Linux"
            PolicyName = "The tftpd package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 82".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The readahead-fedora package should be uninstalled."
        {
            Msid = "82"
            BaselineName = "ASC.Linux"
            PolicyName = "The readahead-fedora package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 84".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The bluetooth/hidd service should be disabled."
        {
            Msid = "84"
            BaselineName = "ASC.Linux"
            PolicyName = "The bluetooth/hidd service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 86".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The isdn service should be disabled."
        {
            Msid = "86"
            BaselineName = "ASC.Linux"
            PolicyName = "The isdn service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 87".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The isdnutils-base package should be uninstalled."
        {
            Msid = "87"
            BaselineName = "ASC.Linux"
            PolicyName = "The isdnutils-base package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 88".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The kdump service should be disabled."
        {
            Msid = "88"
            BaselineName = "ASC.Linux"
            PolicyName = "The kdump service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 89".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Zeroconf networking should be disabled."
        {
            Msid = "89"
            BaselineName = "ASC.Linux"
            PolicyName = "Zeroconf networking should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 90".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The crond service should be enabled."
        {
            Msid = "90"
            BaselineName = "ASC.Linux"
            PolicyName = "The crond service should be enabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 91".Enabled -eq $true ) {
        ASM_LinuxAuditResource "File permissions for /etc/anacrontab should be set to root:root 600."
        {
            Msid = "91"
            BaselineName = "ASC.Linux"
            PolicyName = "File permissions for /etc/anacrontab should be set to root:root 600."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 93".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/cron.d are configured."
        {
            Msid = "93"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/cron.d are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 94".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/cron.daily are configured."
        {
            Msid = "94"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/cron.daily are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 95".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/cron.hourly are configured."
        {
            Msid = "95"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/cron.hourly are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 96".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/cron.monthly are configured."
        {
            Msid = "96"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/cron.monthly are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 97".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/cron.weekly are configured."
        {
            Msid = "97"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/cron.weekly are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 114".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The avahi-daemon service should be disabled."
        {
            Msid = "114"
            BaselineName = "ASC.Linux"
            PolicyName = "The avahi-daemon service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 115".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The cups service should be disabled."
        {
            Msid = "115"
            BaselineName = "ASC.Linux"
            PolicyName = "The cups service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 116".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The isc-dhcpd service should be disabled."
        {
            Msid = "116"
            BaselineName = "ASC.Linux"
            PolicyName = "The isc-dhcpd service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 117".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The isc-dhcp-server package should be uninstalled."
        {
            Msid = "117"
            BaselineName = "ASC.Linux"
            PolicyName = "The isc-dhcp-server package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 120".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The sendmail package should be uninstalled."
        {
            Msid = "120"
            BaselineName = "ASC.Linux"
            PolicyName = "The sendmail package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 121".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The postfix package should be uninstalled."
        {
            Msid = "121"
            BaselineName = "ASC.Linux"
            PolicyName = "The postfix package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 122".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Postfix network listening should be disabled as appropriate."
        {
            Msid = "122"
            BaselineName = "ASC.Linux"
            PolicyName = "Postfix network listening should be disabled as appropriate."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 124".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The ldap service should be disabled."
        {
            Msid = "124"
            BaselineName = "ASC.Linux"
            PolicyName = "The ldap service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 126".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The rpcgssd service should be disabled."
        {
            Msid = "126"
            BaselineName = "ASC.Linux"
            PolicyName = "The rpcgssd service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 127".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The rpcidmapd service should be disabled."
        {
            Msid = "127"
            BaselineName = "ASC.Linux"
            PolicyName = "The rpcidmapd service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 129.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The portmap service should be disabled."
        {
            Msid = "129.1"
            BaselineName = "ASC.Linux"
            PolicyName = "The portmap service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 129.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The Network File System (NFS) service should be disabled."
        {
            Msid = "129.2"
            BaselineName = "ASC.Linux"
            PolicyName = "The Network File System (NFS) service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 130".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The rpcsvcgssd service should be disabled."
        {
            Msid = "130"
            BaselineName = "ASC.Linux"
            PolicyName = "The rpcsvcgssd service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 131".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The named service should be disabled."
        {
            Msid = "131"
            BaselineName = "ASC.Linux"
            PolicyName = "The named service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 132".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The bind package should be uninstalled."
        {
            Msid = "132"
            BaselineName = "ASC.Linux"
            PolicyName = "The bind package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 137".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The dovecot service should be disabled."
        {
            Msid = "137"
            BaselineName = "ASC.Linux"
            PolicyName = "The dovecot service should be disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 138".Enabled -eq $true ) {
        ASM_LinuxAuditResource "The dovecot package should be uninstalled."
        {
            Msid = "138"
            BaselineName = "ASC.Linux"
            PolicyName = "The dovecot package should be uninstalled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 156.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no legacy `+` entries exist in /etc/passwd"
        {
            Msid = "156.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no legacy `+` entries exist in /etc/passwd"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 156.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no legacy `+` entries exist in /etc/shadow"
        {
            Msid = "156.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no legacy `+` entries exist in /etc/shadow"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 156.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no legacy `+` entries exist in /etc/group"
        {
            Msid = "156.3"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no legacy `+` entries exist in /etc/group"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure password expiration is 365 days or less."
        {
            Msid = "157.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure password expiration is 365 days or less."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure password expiration warning days is 7 or more."
        {
            Msid = "157.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure password expiration warning days is 7 or more."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure password reuse is limited."
        {
            Msid = "157.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure password reuse is limited."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.11".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure password hashing algorithm is SHA-512"
        {
            Msid = "157.11"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure password hashing algorithm is SHA-512"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.12".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure minimum days between password changes is 7 or more."
        {
            Msid = "157.12"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure minimum days between password changes is 7 or more."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.14".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure all users last password change date is in the past"
        {
            Msid = "157.14"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure all users last password change date is in the past"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.15".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure system accounts are non-login"
        {
            Msid = "157.15"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure system accounts are non-login"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.16".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure default group for the root account is GID 0"
        {
            Msid = "157.16"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure default group for the root account is GID 0"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 157.18".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure root is the only UID 0 account"
        {
            Msid = "157.18"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure root is the only UID 0 account"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 159".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Remove unnecessary accounts"
        {
            Msid = "159"
            BaselineName = "ASC.Linux"
            PolicyName = "Remove unnecessary accounts"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 179".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SNMP Server is not enabled"
        {
            Msid = "179"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SNMP Server is not enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 181".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure rsync service is not enabled"
        {
            Msid = "181"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure rsync service is not enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 182".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure NIS server is not enabled"
        {
            Msid = "182"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure NIS server is not enabled"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 183".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure rsh client is not installed"
        {
            Msid = "183"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure rsh client is not installed"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 185".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable SMB V1 with Samba"
        {
            Msid = "185"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable SMB V1 with Samba"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure nodev option set on /home partition."
        {
            Msid = "1.1.4"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure nodev option set on /home partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure nodev option set on /tmp partition."
        {
            Msid = "1.1.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure nodev option set on /tmp partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.6".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure nodev option set on /var/tmp partition."
        {
            Msid = "1.1.6"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure nodev option set on /var/tmp partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.7".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure nosuid option set on /tmp partition."
        {
            Msid = "1.1.7"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure nosuid option set on /tmp partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.8".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure nosuid option set on /var/tmp partition."
        {
            Msid = "1.1.8"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure nosuid option set on /var/tmp partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.9".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure noexec option set on /var/tmp partition."
        {
            Msid = "1.1.9"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure noexec option set on /var/tmp partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.16".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure noexec option set on /dev/shm partition."
        {
            Msid = "1.1.16"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure noexec option set on /dev/shm partition."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.1.21".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Disable automounting"
        {
            Msid = "1.1.21"
            BaselineName = "ASC.Linux"
            PolicyName = "Disable automounting"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.5.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure core dumps are restricted."
        {
            Msid = "1.5.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure core dumps are restricted."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.5.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure prelink is disabled."
        {
            Msid = "1.5.4"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure prelink is disabled."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.7.1.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/motd are configured."
        {
            Msid = "1.7.1.4"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/motd are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.7.1.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/issue are configured."
        {
            Msid = "1.7.1.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/issue are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 1.7.1.6".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/issue.net are configured."
        {
            Msid = "1.7.1.6"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/issue.net are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 2.3.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure talk client is not installed."
        {
            Msid = "2.3.3"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure talk client is not installed."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 3.4.4".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/hosts.allow are configured."
        {
            Msid = "3.4.4"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/hosts.allow are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 3.4.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/hosts.deny are configured."
        {
            Msid = "3.4.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/hosts.deny are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 3.6.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure default deny firewall policy"
        {
            Msid = "3.6.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure default deny firewall policy"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 5.3.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure password creation requirements are configured."
        {
            Msid = "5.3.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure password creation requirements are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 5.3.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure lockout for failed password attempts is configured."
        {
            Msid = "5.3.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure lockout for failed password attempts is configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.7".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure all users' home directories exist"
        {
            Msid = "6.2.7"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure all users' home directories exist"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.9".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure users own their home directories"
        {
            Msid = "6.2.9"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure users own their home directories"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.10".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure users' dot files are not group or world writable."
        {
            Msid = "6.2.10"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure users' dot files are not group or world writable."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.11".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no users have .forward files"
        {
            Msid = "6.2.11"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no users have .forward files"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.12".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no users have .netrc files"
        {
            Msid = "6.2.12"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no users have .netrc files"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.14".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no users have .rhosts files"
        {
            Msid = "6.2.14"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no users have .rhosts files"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.15".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure all groups in /etc/passwd exist in /etc/group"
        {
            Msid = "6.2.15"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure all groups in /etc/passwd exist in /etc/group"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.16".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no duplicate UIDs exist"
        {
            Msid = "6.2.16"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no duplicate UIDs exist"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.17".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no duplicate GIDs exist"
        {
            Msid = "6.2.17"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no duplicate GIDs exist"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.18".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no duplicate user names exist"
        {
            Msid = "6.2.18"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no duplicate user names exist"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.19".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure no duplicate groups exist"
        {
            Msid = "6.2.19"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure no duplicate groups exist"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 6.2.20".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure shadow group is empty"
        {
            Msid = "6.2.20"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure shadow group is empty"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 5.2.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure permissions on /etc/ssh/sshd_config are configured."
        {
            Msid = "5.2.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure permissions on /etc/ssh/sshd_config are configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 106.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config Protocol = 2'"
        {
            Msid = "106.1"
            BaselineName = "ASC.Linux"
            PolicyName = "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config Protocol = 2'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 106.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config IgnoreRhosts = yes'"
        {
            Msid = "106.3"
            BaselineName = "ASC.Linux"
            PolicyName = "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config IgnoreRhosts = yes'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 106.5".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SSH LogLevel is set to INFO"
        {
            Msid = "106.5"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SSH LogLevel is set to INFO"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 106.7".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SSH MaxAuthTries is set to 6 or less"
        {
            Msid = "106.7"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SSH MaxAuthTries is set to 6 or less"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 106.11".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SSH access is limited"
        {
            Msid = "106.11"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SSH access is limited"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 107".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Emulation of the rsh command through the ssh server should be disabled. - '/etc/ssh/sshd_config RhostsRSAAuthentication = no'"
        {
            Msid = "107"
            BaselineName = "ASC.Linux"
            PolicyName = "Emulation of the rsh command through the ssh server should be disabled. - '/etc/ssh/sshd_config RhostsRSAAuthentication = no'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 108".Enabled -eq $true ) {
        ASM_LinuxAuditResource "SSH host-based authentication should be disabled. - '/etc/ssh/sshd_config HostbasedAuthentication = no'"
        {
            Msid = "108"
            BaselineName = "ASC.Linux"
            PolicyName = "SSH host-based authentication should be disabled. - '/etc/ssh/sshd_config HostbasedAuthentication = no'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 109".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Root login via SSH should be disabled. - '/etc/ssh/sshd_config PermitRootLogin = no'"
        {
            Msid = "109"
            BaselineName = "ASC.Linux"
            PolicyName = "Root login via SSH should be disabled. - '/etc/ssh/sshd_config PermitRootLogin = no'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 110".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Remote connections from accounts with empty passwords should be disabled. - '/etc/ssh/sshd_config PermitEmptyPasswords = no'"
        {
            Msid = "110"
            BaselineName = "ASC.Linux"
            PolicyName = "Remote connections from accounts with empty passwords should be disabled. - '/etc/ssh/sshd_config PermitEmptyPasswords = no'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 110.1".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SSH Idle Timeout Interval is configured."
        {
            Msid = "110.1"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SSH Idle Timeout Interval is configured."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 110.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure SSH LoginGraceTime is set to one minute or less."
        {
            Msid = "110.2"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure SSH LoginGraceTime is set to one minute or less."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 110.3".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Ensure only approved MAC algorithms are used"
        {
            Msid = "110.3"
            BaselineName = "ASC.Linux"
            PolicyName = "Ensure only approved MAC algorithms are used"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 111.2".Enabled -eq $true ) {
        ASM_LinuxAuditResource "SSH warning banner should be enabled. - '/etc/ssh/sshd_config Banner = /etc/issue.net'"
        {
            Msid = "111.2"
            BaselineName = "ASC.Linux"
            PolicyName = "SSH warning banner should be enabled. - '/etc/ssh/sshd_config Banner = /etc/issue.net'"
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 112".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Users are not allowed to set environment options for SSH."
        {
            Msid = "112"
            BaselineName = "ASC.Linux"
            PolicyName = "Users are not allowed to set environment options for SSH."
        }
    }
    if( $ConfigurationData.NonNodeData."MSID 113".Enabled -eq $true ) {
        ASM_LinuxAuditResource "Appropriate ciphers should be used for SSH. (Ciphers aes128-ctr,aes192-ctr,aes256-ctr)"
        {
            Msid = "113"
            BaselineName = "ASC.Linux"
            PolicyName = "Appropriate ciphers should be used for SSH. (Ciphers aes128-ctr,aes192-ctr,aes256-ctr)"
        }
    }
}
