@{
   AllNodes = @(

        
    )
    NonNodeData =
    @{
                "MSID 60" = @{
                        Name = "Ensure logging is configured"
                        FullDescription = "Ensure logging is configured"
                        PotentialImpact = "A great deal of important security-related information is sent via rsyslog (e.g., successful and failed su attempts, failed login attempts, root login attempts, etc.)."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 63.1" = @{
                        Name = "Ensure logger configuration files are restricted."
                        FullDescription = "Ensure logger configuration files are restricted."
                        PotentialImpact = "It is important to ensure that log files exist and have the correct permissions to ensure that sensitive syslog data is archived and protected."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 98" = @{
                        Name = "Ensure at/cron is restricted to authorized users"
                        FullDescription = "Ensure at/cron is restricted to authorized users"
                        PotentialImpact = "On many systems, only the system administrator is authorized to schedule cron jobs. Using the cron.allow file to control who can run cron jobs enforces this policy. It is easier to manage an allowlist than a denylist. In a denylist, you could potentially add a user ID to the system and forget to add it to the deny files."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 111" = @{
                        Name = "Ensure remote login warning banner is configured properly."
                        FullDescription = "Ensure remote login warning banner is configured properly."
                        PotentialImpact = "Warning messages inform users who are attempting to login to the system of their legal status regarding the system and must include the name of the organization that owns the system and any monitoring policies that are in place. Displaying OS and patch level information in login banners also has the side effect of providing detailed system information to attackers attempting to target specific exploits of a system. Authorized users can easily get this information by running the uname -acommand once they have logged in."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 111.1" = @{
                        Name = "Ensure local login warning banner is configured properly."
                        FullDescription = "Ensure local login warning banner is configured properly."
                        PotentialImpact = "Warning messages inform users who are attempting to login to the system of their legal status regarding the system and must include the name of the organization that owns the system and any monitoring policies that are in place. Displaying OS and patch level information in login banners also has the side effect of providing detailed system information to attackers attempting to target specific exploits of a system. Authorized users can easily get this information by running the uname -acommand once they have logged in."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 162" = @{
                        Name = "Ensure auditd service is enabled"
                        FullDescription = "Ensure auditd service is enabled"
                        PotentialImpact = "The capturing of system events provides system administrators with information to allow them to determine if unauthorized access to their system is occurring."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 163" = @{
                        Name = "Run AuditD service"
                        FullDescription = "Run AuditD service"
                        PotentialImpact = "The capturing of system events provides system administrators with information to allow them to determine if unauthorized access to their system is occurring."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.21.1" = @{
                        Name = "Ensure mounting of USB storage devices is disabled"
                        FullDescription = "Ensure mounting of USB storage devices is disabled"
                        PotentialImpact = "Removing support for USB storage devices reduces the local attack surface of the server."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 2.1" = @{
                        Name = "The nodev option should be enabled for all removable media."
                        FullDescription = "The nodev option should be enabled for all removable media."
                        PotentialImpact = "An attacker could mount a special device (e.g. block or character device) via removable media"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 2.2" = @{
                        Name = "The noexec option should be enabled for all removable media."
                        FullDescription = "The noexec option should be enabled for all removable media."
                        PotentialImpact = "An attacker could load executable file via removable media"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 2.3" = @{
                        Name = "The nosuid option should be enabled for all removable media."
                        FullDescription = "The nosuid option should be enabled for all removable media."
                        PotentialImpact = "An attacker could load files that run with an elevated security context via removable media"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 5" = @{
                        Name = "The nodev/nosuid option should be enabled for all NFS mounts."
                        FullDescription = "The nodev/nosuid option should be enabled for all NFS mounts."
                        PotentialImpact = "An attacker could load files that run with an elevated security context or special devices via remote file system"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.1" = @{
                        Name = "Disable the installation and use of file systems that are not required (cramfs)"
                        FullDescription = "Disable the installation and use of file systems that are not required (cramfs)"
                        PotentialImpact = "An attacker could use a vulnerability in cramfs to elevate privileges"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2" = @{
                        Name = "Disable the installation and use of file systems that are not required (freevxfs)"
                        FullDescription = "Disable the installation and use of file systems that are not required (freevxfs)"
                        PotentialImpact = "An attacker could use a vulnerability in freevxfs to elevate privileges"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.3" = @{
                        Name = "Disable the installation and use of file systems that are not required (hfs)"
                        FullDescription = "Disable the installation and use of file systems that are not required (hfs)"
                        PotentialImpact = "An attacker could use a vulnerability in hfs to elevate privileges"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.4" = @{
                        Name = "Disable the installation and use of file systems that are not required (hfsplus)"
                        FullDescription = "Disable the installation and use of file systems that are not required (hfsplus)"
                        PotentialImpact = "An attacker could use a vulnerability in hfsplus to elevate privileges"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.5" = @{
                        Name = "Disable the installation and use of file systems that are not required (jffs2)"
                        FullDescription = "Disable the installation and use of file systems that are not required (jffs2)"
                        PotentialImpact = "An attacker could use a vulnerability in jffs2 to elevate privileges"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 10" = @{
                        Name = "Kernels should only be compiled from approved sources."
                        FullDescription = "Kernels should only be compiled from approved sources."
                        PotentialImpact = "A kernel from an unapproved source could contain vulnerabilities or backdoors to grant access to an attacker."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 11.1" = @{
                        Name = "/etc/shadow file permissions should be set to 0400"
                        FullDescription = "/etc/shadow file permissions should be set to 0400"
                        PotentialImpact = "An attacker that can retrieve or manipulate hashed passwords from /etc/shadow if it is not correctly secured."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 11.2" = @{
                        Name = "/etc/shadow- file permissions should be set to 0400"
                        FullDescription = "/etc/shadow- file permissions should be set to 0400"
                        PotentialImpact = "An attacker that can retrieve or manipulate hashed passwords from /etc/shadow- if it is not correctly secured."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 11.3" = @{
                        Name = "/etc/gshadow file permissions should be set to 0400"
                        FullDescription = "/etc/gshadow file permissions should be set to 0400"
                        PotentialImpact = "An attacker could join security groups if this file is not properly secured"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 11.4" = @{
                        Name = "/etc/gshadow- file permissions should be set to 0400"
                        FullDescription = "/etc/gshadow- file permissions should be set to 0400"
                        PotentialImpact = "An attacker could join security groups if this file is not properly secured"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 12.1" = @{
                        Name = "/etc/passwd file permissions should be 0644"
                        FullDescription = "/etc/passwd file permissions should be 0644"
                        PotentialImpact = "An attacker could modify userIDs and login shells"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 12.2" = @{
                        Name = "/etc/group file permissions should be 0644"
                        FullDescription = "/etc/group file permissions should be 0644"
                        PotentialImpact = "An attacker could elevate privileges by modifying group membership"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 12.3" = @{
                        Name = "/etc/passwd- file permissions should be set to 0600"
                        FullDescription = "/etc/passwd- file permissions should be set to 0600"
                        PotentialImpact = "An attacker could join security groups if this file is not properly secured"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 12.4" = @{
                        Name = "/etc/group file permissions should be 0644"
                        FullDescription = "/etc/group file permissions should be 0644"
                        PotentialImpact = "An attacker could elevate privileges by modifying group membership"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 21" = @{
                        Name = "Access to the root account via su should be restricted to the 'root' group"
                        FullDescription = "Access to the root account via su should be restricted to the 'root' group"
                        PotentialImpact = "An attacker could escalate permissions by password guessing if su is not restricted to users in the root group."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 22" = @{
                        Name = "The 'root' group should exist, and contain all members who can su to root"
                        FullDescription = "The 'root' group should exist, and contain all members who can su to root"
                        PotentialImpact = "An attacker could escalate permissions by password guessing if su is not restricted to users in the root group."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 23.2" = @{
                        Name = "There are no accounts without passwords"
                        FullDescription = "There are no accounts without passwords"
                        PotentialImpact = "An attacker can login to accounts with no password and execute arbitrary commands."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 24" = @{
                        Name = "Accounts other than root must have unique UIDs greater than zero(0)"
                        FullDescription = "Accounts other than root must have unique UIDs greater than zero(0)"
                        PotentialImpact = "If an account other than root has uid zero, an attacker could compromise the account and gain root privileges."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 25" = @{
                        Name = "Randomized placement of virtual memory regions should be enabled"
                        FullDescription = "Randomized placement of virtual memory regions should be enabled"
                        PotentialImpact = "An attacker could write executable code to known regions in memory resulting in elevation of privilege"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 26" = @{
                        Name = "Kernel support for the XD/NX processor feature should be enabled"
                        FullDescription = "Kernel support for the XD/NX processor feature should be enabled"
                        PotentialImpact = "An attacker could cause a system to executable code from data regions in memory resulting in elevation of privilege."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 27.1" = @{
                        Name = " The '.' should not appear in root's `$PATH"
                        FullDescription = " The '.' should not appear in root's PATH"
                        PotentialImpact = "An attacker could elevate privileges by placing a malicious file in root's PATH"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 28" = @{
                        Name = "User home directories should be mode 750 or more restrictive"
                        FullDescription = "User home directories should be mode 750 or more restrictive"
                        PotentialImpact = "An attacker could retrieve sensitive information from the home folders of other users."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 29" = @{
                        Name = "The default umask for all users should be set to 077 in login.defs"
                        FullDescription = "The default umask for all users should be set to 077 in login.defs"
                        PotentialImpact = "An attacker could retrieve sensitive information from files owned by other users."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 31" = @{
                        Name = "All bootloaders should have password protection enabled."
                        FullDescription = "All bootloaders should have password protection enabled."
                        PotentialImpact = "An attacker with physical access could modify bootloader options, yielding unrestricted system access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 31.1" = @{
                        Name = "Ensure permissions on bootloader config are configured"
                        FullDescription = "Ensure permissions on bootloader config are configured"
                        PotentialImpact = "Setting the permissions to read and write for root only prevents non-root users from seeing the boot parameters or changing them. Non-root users who read the boot parameters may be able to identify weaknesses in security upon boot and be able to exploit them."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 33" = @{
                        Name = "Ensure authentication required for single user mode."
                        FullDescription = "Ensure authentication required for single user mode."
                        PotentialImpact = "Requiring authentication in single user mode prevents an unauthorized user from rebooting the system into single user to gain root privileges without credentials."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 38.3" = @{
                        Name = "Ensure packet redirect sending is disabled."
                        FullDescription = "Ensure packet redirect sending is disabled."
                        PotentialImpact = "An attacker could use a compromised host to send invalid ICMP redirects to other router devices in an attempt to corrupt routing and have users access a system set up by the attacker as opposed to a valid system."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 38.4" = @{
                        Name = "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.accept_redirects = 0)"
                        FullDescription = "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.accept_redirects = 0)"
                        PotentialImpact = "An attacker could alter this system's routing table, redirecting traffic to an alternate destination"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 38.5" = @{
                        Name = "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.secure_redirects = 0)"
                        FullDescription = "Sending ICMP redirects should be disabled for all interfaces. (net.ipv4.conf.default.secure_redirects = 0)"
                        PotentialImpact = "An attacker could alter this system's routing table, redirecting traffic to an alternate destination"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 40.1" = @{
                        Name = "Accepting source routed packets should be disabled for all interfaces. (net.ipv4.conf.all.accept_source_route &#61; 0)"
                        FullDescription = "Accepting source routed packets should be disabled for all interfaces. (net.ipv4.conf.all.accept_source_route &#61; 0)"
                        PotentialImpact = "An attacker could redirect traffic for malicious purposes."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 40.2" = @{
                        Name = "Accepting source routed packets should be disabled for all interfaces. (net.ipv6.conf.all.accept_source_route &#61; 0)"
                        FullDescription = "Accepting source routed packets should be disabled for all interfaces. (net.ipv6.conf.all.accept_source_route &#61; 0)"
                        PotentialImpact = "An attacker could redirect traffic for malicious purposes."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 42.1" = @{
                        Name = ""
                        FullDescription = ""
                        PotentialImpact = ""
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 42.2" = @{
                        Name = ""
                        FullDescription = ""
                        PotentialImpact = ""
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 43" = @{
                        Name = "Ignoring bogus ICMP responses to broadcasts should be enabled. (net.ipv4.icmp_ignore_bogus_error_responses &#61; 1)"
                        FullDescription = "Ignoring bogus ICMP responses to broadcasts should be enabled. (net.ipv4.icmp_ignore_bogus_error_responses &#61; 1)"
                        PotentialImpact = "An attacker could perform an ICMP attack resulting in DoS"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 44" = @{
                        Name = "Ignoring ICMP echo requests (pings) sent to broadcast / multicast addresses should be enabled. (net.ipv4.icmp_echo_ignore_broadcasts &#61; 1)"
                        FullDescription = "Ignoring ICMP echo requests (pings) sent to broadcast / multicast addresses should be enabled. (net.ipv4.icmp_echo_ignore_broadcasts &#61; 1)"
                        PotentialImpact = "An attacker could perform an ICMP attack resulting in DoS"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 45.1" = @{
                        Name = "Logging of martian packets (those with impossible addresses) should be enabled for all interfaces. (net.ipv4.conf.all.log_martians = 1)"
                        FullDescription = "Logging of martian packets (those with impossible addresses) should be enabled for all interfaces. (net.ipv4.conf.all.log_martians = 1)"
                        PotentialImpact = "An attacker could send traffic from spoofed addresses without being detected"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 46.1" = @{
                        Name = "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.all.rp_filter &#61; 1)"
                        FullDescription = "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.all.rp_filter &#61; 1)"
                        PotentialImpact = "The system will accept traffic from addresses that are unroutable."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 46.2" = @{
                        Name = "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.default.rp_filter &#61; 1)"
                        FullDescription = "Performing source validation by reverse path should be enabled for all interfaces. (net.ipv4.conf.default.rp_filter &#61; 1)"
                        PotentialImpact = "The system will accept traffic from addresses that are unroutable."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 47" = @{
                        Name = "TCP syncookies should be enabled. (net.ipv4.tcp_syncookies &#61; 1)"
                        FullDescription = "TCP syncookies should be enabled. (net.ipv4.tcp_syncookies &#61; 1)"
                        PotentialImpact = "An attacker could perform a DoS over TCP"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 48" = @{
                        Name = "The system should not act as a network sniffer."
                        FullDescription = "The system should not act as a network sniffer."
                        PotentialImpact = "An attacker may use promiscuous interfaces to sniff network traffic"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 49" = @{
                        Name = "All wireless interfaces should be disabled."
                        FullDescription = "All wireless interfaces should be disabled. (disabled)"
                        PotentialImpact = "An attacker could create a fake AP to intercept transmissions."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 50" = @{
                        Name = "The IPv6 protocol should be enabled."
                        FullDescription = "The IPv6 protocol should be enabled."
                        PotentialImpact = "This is necessary for communication on modern networks."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 54" = @{
                        Name = "Ensure DCCP is disabled"
                        FullDescription = "Ensure DCCP is disabled"
                        PotentialImpact = "If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 55" = @{
                        Name = "Ensure SCTP is disabled"
                        FullDescription = "Ensure SCTP is disabled"
                        PotentialImpact = "If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 56" = @{
                        Name = "Disable support for RDS."
                        FullDescription = "Disable support for RDS."
                        PotentialImpact = "An attacker could use a vulnerability in RDS to compromise the system"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 57" = @{
                        Name = "Ensure TIPC is disabled"
                        FullDescription = "Ensure TIPC is disabled"
                        PotentialImpact = "If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 61" = @{
                        Name = "The syslog or rsyslog package should be installed."
                        FullDescription = "The syslog or rsyslog package should be installed."
                        PotentialImpact = "Reliability and security issues will not be logged, preventing proper diagnosis."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 61.1" = @{
                        Name = ""
                        FullDescription = ""
                        PotentialImpact = ""
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 62" = @{
                        Name = "Ensure a logging service is enabled"
                        FullDescription = "Ensure a logging service is enabled"
                        PotentialImpact = "It is imperative to have the ability to log events on a node."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 63" = @{
                        Name = "File permissions for all rsyslog log files should be set to 640."
                        FullDescription = "File permissions for all rsyslog log files should be set to 640."
                        PotentialImpact = "An attacker could cover up activity by manipulating logs"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 64" = @{
                        Name = "All rsyslog log files should be owned by the adm group."
                        FullDescription = "All rsyslog log files should be owned by the adm group."
                        PotentialImpact = "An attacker could cover up activity by manipulating logs"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 65" = @{
                        Name = "All rsyslog log files should be owned by the syslog user."
                        FullDescription = "All rsyslog log files should be owned by the syslog user."
                        PotentialImpact = "An attacker could cover up activity by manipulating logs"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 67" = @{
                        Name = "Rsyslog should not accept remote messages."
                        FullDescription = "Rsyslog should not accept remote messages. (reject)"
                        PotentialImpact = "An attacker could inject messages into syslog, causing a DoS or a distraction from other activity"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 68" = @{
                        Name = "The logrotate (syslog rotater) service should be enabled."
                        FullDescription = "The logrotate (syslog rotater) service should be enabled. (enabled)"
                        PotentialImpact = "Logfiles could grow unbounded and consume all disk space"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 69" = @{
                        Name = "The rlogin service should be disabled."
                        FullDescription = "The rlogin service should be disabled."
                        PotentialImpact = "An attacker could gain access, bypassing strict authentication requirements"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 70.1" = @{
                        Name = "Disable inetd unless required. (inetd)"
                        FullDescription = "Disable inetd unless required. (inetd)"
                        PotentialImpact = "An attacker could exploit a vulnerability in an inetd service to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 70.2" = @{
                        Name = "Disable xinetd unless required. (xinetd)"
                        FullDescription = "Disable xinetd unless required. (xinetd)"
                        PotentialImpact = "An attacker could exploit a vulnerability in an xinetd service to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 71.1" = @{
                        Name = "Install inetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
                        FullDescription = "Install inetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
                        PotentialImpact = "An attacker could exploit a vulnerability in an inetd service to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 71.2" = @{
                        Name = "Install xinetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
                        FullDescription = "Install xinetd only if appropriate and required by your distro. Secure according to current hardening standards. (if required)"
                        PotentialImpact = "An attacker could exploit a vulnerability in an xinetd service to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 72" = @{
                        Name = "The telnet service should be disabled."
                        FullDescription = "The telnet service should be disabled. (disabled)"
                        PotentialImpact = "An attacker could eavesdrop or highjack unencrypted telnet sessions"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 73" = @{
                        Name = "All telnetd packages should be uninstalled."
                        FullDescription = "All telnetd packages should be uninstalled."
                        PotentialImpact = "An attacker could eavesdrop or highjack unencrypted telnet sessions"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 74" = @{
                        Name = "The rcp/rsh service should be disabled."
                        FullDescription = "The rcp/rsh service should be disabled."
                        PotentialImpact = "An attacker could eavesdrop or highjack unencrypted sessions"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 77" = @{
                        Name = "The rsh-server package should be uninstalled."
                        FullDescription = "The rsh-server package should be uninstalled."
                        PotentialImpact = "An attacker could eavesdrop or highjack unencrypted rsh sessions"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 78" = @{
                        Name = "The ypbind service should be disabled."
                        FullDescription = "The ypbind service should be disabled."
                        PotentialImpact = "An attacker could retrieve sensitive information from the ypbind service"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 79" = @{
                        Name = "The nis package should be uninstalled."
                        FullDescription = "The nis package should be uninstalled."
                        PotentialImpact = "An attacker could retrieve sensitive information from the NIS service"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 80" = @{
                        Name = "The tftp service should be disabled."
                        FullDescription = "The tftp service should be disabled."
                        PotentialImpact = "An attacker could eavesdrop or highjack an unencrypted session"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 81" = @{
                        Name = "The tftpd package should be uninstalled."
                        FullDescription = "The tftpd package should be uninstalled."
                        PotentialImpact = "An attacker could eavesdrop or highjack an unencrypted session"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 82" = @{
                        Name = "The readahead-fedora package should be uninstalled."
                        FullDescription = "The readahead-fedora package should be uninstalled."
                        PotentialImpact = "No substantial exposure, but also no substantial benefit"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 84" = @{
                        Name = "The bluetooth/hidd service should be disabled."
                        FullDescription = "The bluetooth/hidd service should be disabled."
                        PotentialImpact = "An attacker could intercept or manipulate wireless communications."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 86" = @{
                        Name = "The isdn service should be disabled."
                        FullDescription = "The isdn service should be disabled."
                        PotentialImpact = "An attacker could use a modem to gain unauthorized access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 87" = @{
                        Name = "The isdnutils-base package should be uninstalled."
                        FullDescription = "The isdnutils-base package should be uninstalled."
                        PotentialImpact = "An attacker could use a modem to gain unauthorized access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 88" = @{
                        Name = "The kdump service should be disabled."
                        FullDescription = "The kdump service should be disabled. (disabled)"
                        PotentialImpact = "An attacker could analyze a previous system crash to retrieve sensitive information"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 89" = @{
                        Name = "Zeroconf networking should be disabled."
                        FullDescription = "Zeroconf networking should be disabled. (disabled)"
                        PotentialImpact = "An attacker could use abuse this to gain information on network systems, or spoof DNS requests due to flaws in its trust model"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 90" = @{
                        Name = "The crond service should be enabled."
                        FullDescription = "The crond service should be enabled. (enabled)"
                        PotentialImpact = "Cron is required by almost all systems for regular maintenance tasks"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 91" = @{
                        Name = "File permissions for /etc/anacrontab should be set to root:root 600."
                        FullDescription = "File permissions for /etc/anacrontab should be set to root:root 600."
                        PotentialImpact = "An attacker could manipulate this file to prevent scheduled tasks or execute malicious tasks"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 93" = @{
                        Name = "Ensure permissions on /etc/cron.d are configured."
                        FullDescription = "Ensure permissions on /etc/cron.d are configured."
                        PotentialImpact = "Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 94" = @{
                        Name = "Ensure permissions on /etc/cron.daily are configured."
                        FullDescription = "Ensure permissions on /etc/cron.daily are configured."
                        PotentialImpact = "Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 95" = @{
                        Name = "Ensure permissions on /etc/cron.hourly are configured."
                        FullDescription = "Ensure permissions on /etc/cron.hourly are configured."
                        PotentialImpact = "Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 96" = @{
                        Name = "Ensure permissions on /etc/cron.monthly are configured."
                        FullDescription = "Ensure permissions on /etc/cron.monthly are configured."
                        PotentialImpact = "Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 97" = @{
                        Name = "Ensure permissions on /etc/cron.weekly are configured."
                        FullDescription = "Ensure permissions on /etc/cron.weekly are configured."
                        PotentialImpact = "Granting write access to this directory for non-privileged users could provide them the means for gaining unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user insight in how to gain elevated privileges or circumvent auditing controls."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 114" = @{
                        Name = "The avahi-daemon service should be disabled."
                        FullDescription = "The avahi-daemon service should be disabled."
                        PotentialImpact = "An attacker could use a vulnerability in the avahi daemon to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 115" = @{
                        Name = "The cups service should be disabled."
                        FullDescription = "The cups service should be disabled."
                        PotentialImpact = "An attacker could use a flaw in the cups service to elevate privileges"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 116" = @{
                        Name = "The dhcpd service should be disabled."
                        FullDescription = "The dhcpd service should be disabled."
                        PotentialImpact = "An attacker could use dhcpd to provide faulty information to clients, interfering with normal operation."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 117" = @{
                        Name = "The isc-dhcp-server package should be uninstalled."
                        FullDescription = "The isc-dhcp-server package should be uninstalled."
                        PotentialImpact = "An attacker could use dhcpd to provide faulty information to clients, interfering with normal operation."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 120" = @{
                        Name = "The sendmail package should be uninstalled."
                        FullDescription = "The sendmail package should be uninstalled."
                        PotentialImpact = "An attacker could use this system to send emails with malicious content to other users"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 121" = @{
                        Name = "The postfix package should be uninstalled."
                        FullDescription = "The postfix package should be uninstalled."
                        PotentialImpact = "An attacker could use this system to send emails with malicious content to other users"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 122" = @{
                        Name = "Postfix network listening should be disabled as appropriate."
                        FullDescription = "Postfix network listening should be disabled as appropriate."
                        PotentialImpact = "An attacker could use this system to send emails with malicious content to other users"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 124" = @{
                        Name = "The ldap service should be disabled."
                        FullDescription = "The ldap service should be disabled. (disabled)"
                        PotentialImpact = "An attacker could manipulate the LDAP service on this host to distribute false data to LDAP clients"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 126" = @{
                        Name = "The rpcgssd service should be disabled."
                        FullDescription = "The rpcgssd service should be disabled."
                        PotentialImpact = "An attacker could use a flaw in rpcgssd/nfs to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 127" = @{
                        Name = "The rpcidmapd service should be disabled."
                        FullDescription = "The rpcidmapd service should be disabled."
                        PotentialImpact = "An attacker could use a flaw in idmapd/nfs to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 129.1" = @{
                        Name = ""
                        FullDescription = ""
                        PotentialImpact = ""
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 129.2" = @{
                        Name = ""
                        FullDescription = ""
                        PotentialImpact = ""
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 130" = @{
                        Name = "The rpcsvcgssd service should be disabled."
                        FullDescription = "The rpcsvcgssd service should be disabled."
                        PotentialImpact = "An attacker could use a flaw in rpcsvcgssd to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 131" = @{
                        Name = "The named service should be disabled."
                        FullDescription = "The named service should be disabled."
                        PotentialImpact = "An attacker could use the DNS service to distribute false data to clients"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 132" = @{
                        Name = "The bind package should be uninstalled."
                        FullDescription = "The bind package should be uninstalled."
                        PotentialImpact = "An attacker could use the DNS service to distribute false data to clients"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 137" = @{
                        Name = "The dovecot service should be disabled."
                        FullDescription = "The dovecot service should be disabled."
                        PotentialImpact = "The system could be used as an IMAP/POP3 server"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 138" = @{
                        Name = "The dovecot package should be uninstalled."
                        FullDescription = "The dovecot package should be uninstalled."
                        PotentialImpact = "The system could be used as an IMAP/POP3 server"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 156.1" = @{
                        Name = "Ensure no legacy `+` entries exist in /etc/passwd"
                        FullDescription = "Ensure no legacy + entries exist in /etc/passwd"
                        PotentialImpact = "An attacker could gain access by using the username '+' with no password"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 156.2" = @{
                        Name = "Ensure no legacy `+` entries exist in /etc/shadow"
                        FullDescription = "Ensure no legacy + entries exist in /etc/shadow"
                        PotentialImpact = "An attacker could gain access by using the username '+' with no password"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 156.3" = @{
                        Name = "Ensure no legacy `+` entries exist in /etc/group"
                        FullDescription = "Ensure no legacy + entries exist in /etc/group"
                        PotentialImpact = "An attacker could gain access by using the username '+' with no password"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.1" = @{
                        Name = "Ensure password expiration is 365 days or less."
                        FullDescription = "Ensure password expiration is 365 days or less."
                        PotentialImpact = "The window of opportunity for an attacker to leverage compromised credentials or successfully compromise credentials via an online brute force attack is limited by the age of the password. Therefore, reducing the maximum age of a password also reduces an attacker's window of opportunity."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.2" = @{
                        Name = "Ensure password expiration warning days is 7 or more."
                        FullDescription = "Ensure password expiration warning days is 7 or more."
                        PotentialImpact = "Providing an advance warning that a password will be expiring gives users time to think of a secure password. Users caught unaware may choose a simple password or write it down where it may be discovered."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.5" = @{
                        Name = "Ensure password reuse is limited."
                        FullDescription = "Ensure password reuse is limited."
                        PotentialImpact = "Forcing users not to reuse their past 5 passwords make it less likely that an attacker will be able to guess the password."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.11" = @{
                        Name = "Ensure password hashing algorithm is SHA-512"
                        FullDescription = "Ensure password hashing algorithm is SHA-512"
                        PotentialImpact = "The SHA-512 algorithm provides much stronger hashing than MD5, thus providing additional protection to the system by increasing the level of effort for an attacker to successfully determine passwords. Note that these changes only apply to accounts configured on the local system."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.12" = @{
                        Name = "Ensure minimum days between password changes is 7 or more."
                        FullDescription = "Ensure minimum days between password changes is 7 or more."
                        PotentialImpact = "By restricting the frequency of password changes, an administrator can prevent users from repeatedly changing their password in an attempt to circumvent password reuse controls."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.14" = @{
                        Name = "Ensure all users last password change date is in the past"
                        FullDescription = "Ensure all users last password change date is in the past"
                        PotentialImpact = "If a users recorded password change date is in the future then they could bypass any set password expiration."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.15" = @{
                        Name = "Ensure system accounts are non-login"
                        FullDescription = "Ensure system accounts are non-login"
                        PotentialImpact = "It is important to make sure that accounts that are not being used by regular users are prevented from being used to provide an interactive shell. By default, Ubuntu sets the password field for these accounts to an invalid string, but it is also recommended that the shell field in the password file be set to /usr/sbin/nologin. This prevents the account from potentially being used to run any commands."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.16" = @{
                        Name = "Ensure default group for the root account is GID 0"
                        FullDescription = "Ensure default group for the root account is GID 0"
                        PotentialImpact = "Using GID 0 for the _root_ account helps prevent _root_-owned files from accidentally becoming accessible to non-privileged users."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 157.18" = @{
                        Name = "Ensure root is the only UID 0 account"
                        FullDescription = "Ensure root is the only UID 0 account"
                        PotentialImpact = "This access must be limited to only the default root account and only from the system console. Administrative access must be through an unprivileged account using an approved mechanism."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 159" = @{
                        Name = "Remove unnecesary accounts"
                        FullDescription = "Remove unnecesary accounts"
                        PotentialImpact = "For compliance"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 179" = @{
                        Name = "Ensure SNMP Server is not enabled"
                        FullDescription = "Ensure SNMP Server is not enabled"
                        PotentialImpact = "The SNMP server can communicate using SNMP v1, which transmits data in the clear and does not require authentication to execute commands. Unless absolutely necessary, it is recommended that the SNMP service not be used. If SNMP is required the server should be configured to disallow SNMP v1."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 181" = @{
                        Name = "Ensure rsync service is not enabled"
                        FullDescription = "Ensure rsync service is not enabled"
                        PotentialImpact = "The rsyncd service presents a security risk as it uses unencrypted protocols for communication."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 182" = @{
                        Name = "Ensure NIS server is not enabled"
                        FullDescription = "Ensure NIS server is not enabled"
                        PotentialImpact = "The NIS service is inherently an insecure system that has been vulnerable to DOS attacks, buffer overflows and has poor authentication for querying NIS maps. NIS generally been replaced by such protocols as Lightweight Directory Access Protocol (LDAP). It is recommended that the service be disabled and other, more secure services be used"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 183" = @{
                        Name = "Ensure rsh client is not installed"
                        FullDescription = "Ensure rsh client is not installed"
                        PotentialImpact = "These legacy clients contain numerous security exposures and have been replaced with the more secure SSH package. Even if the server is removed, it is best to ensure the clients are also removed to prevent users from inadvertently attempting to use these commands and therefore exposing their credentials. Note that removing the rsh package removes the clients for rsh, rcp and rlogin."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 185" = @{
                        Name = "Disable SMB V1 with Samba"
                        FullDescription = "Disable SMB V1 with Samba"
                        PotentialImpact = "SMB v1 has well-known, serious vulnerabilities and does not encrypt data in transit. If it must be used for overriding business reasons, it is strongly recommended that other mitigations be identified to compensate for the use of this protocol. "
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.4" = @{
                        Name = "Ensure nodev option set on /home partition."
                        FullDescription = "Ensure nodev option set on /home partition."
                        PotentialImpact = "An attacker could mount a special device (e.g. block or character device) on the /home partition."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.5" = @{
                        Name = "Ensure nodev option set on /tmp partition."
                        FullDescription = "Ensure nodev option set on /tmp partition."
                        PotentialImpact = "An attacker could mount a special device (e.g. block or character device) on the /tmp partition."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.6" = @{
                        Name = "Ensure nodev option set on /var/tmp partition."
                        FullDescription = "Ensure nodev option set on /var/tmp partition."
                        PotentialImpact = "An attacker could mount a special device (e.g. block or character device) on the /var/tmp partition."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.7" = @{
                        Name = "Ensure nosuid option set on /tmp partition."
                        FullDescription = "Ensure nosuid option set on /tmp partition."
                        PotentialImpact = "Since the/tmpfilesystem is only intended for temporary file storage, set this option to ensure that users cannot createsetuidfiles in/var/tmp."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.8" = @{
                        Name = "Ensure nosuid option set on /var/tmp partition."
                        FullDescription = "Ensure nosuid option set on /var/tmp partition."
                        PotentialImpact = "Since the/var/tmpfilesystem is only intended for temporary file storage, set this option to ensure that users cannot createsetuidfiles in/var/tmp."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.9" = @{
                        Name = "Ensure noexec option set on /var/tmp partition."
                        FullDescription = "Ensure noexec option set on /var/tmp partition."
                        PotentialImpact = "Since the /var/tmp filesystem is only intended for temporary file storage, set this option to ensure that users cannot run executable binaries from /var/tmp ."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.16" = @{
                        Name = "Ensure noexec option set on /dev/shm partition."
                        FullDescription = "Ensure noexec option set on /dev/shm partition."
                        PotentialImpact = "Setting this option on a file system prevents users from executing programs from shared memory. This deters users from introducing potentially malicious software on the system."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.1.21" = @{
                        Name = "Disable automounting"
                        FullDescription = "Disable automounting"
                        PotentialImpact = "With automounting enabled anyone with physical access could attach a USB drive or disc and have its contents available in system even if they lacked permissions to mount it themselves."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.5.1" = @{
                        Name = "Ensure core dumps are restricted."
                        FullDescription = "Ensure core dumps are restricted."
                        PotentialImpact = "Setting a hard limit on core dumps prevents users from overriding the soft variable. If core dumps are required, consider setting limits for user groups (see limits.conf(5) ). In addition, setting the fs.suid_dumpable variable to 0 will prevent setuid programs from dumping core."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.5.4" = @{
                        Name = "Ensure prelink is disabled."
                        FullDescription = "Ensure prelink is disabled."
                        PotentialImpact = "The prelinking feature can interfere with the operation of AIDE, because it changes binaries. Prelinking can also increase the vulnerability of the system if a malicious user is able to compromise a common library such as libc."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.7.1.4" = @{
                        Name = "Ensure permissions on /etc/motd are configured."
                        FullDescription = "Ensure permissions on /etc/motd are configured."
                        PotentialImpact = "If the /etc/motd file does not have the correct ownership it could be modified by unauthorized users with incorrect or misleading information."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.7.1.5" = @{
                        Name = "Ensure permissions on /etc/issue are configured."
                        FullDescription = "Ensure permissions on /etc/issue are configured."
                        PotentialImpact = "If the /etc/issue file does not have the correct ownership it could be modified by unauthorized users with incorrect or misleading information."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 1.7.1.6" = @{
                        Name = "Ensure permissions on /etc/issue.net are configured."
                        FullDescription = "Ensure permissions on /etc/issue.net are configured."
                        PotentialImpact = "If the /etc/issue.net file does not have the correct ownership it could be modified by unauthorized users with incorrect or misleading information."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 2.3.3" = @{
                        Name = "Ensure talk client is not installed."
                        FullDescription = "Ensure talk client is not installed."
                        PotentialImpact = "The software presents a security risk as it uses unencrypted protocols for communication."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 3.4.4" = @{
                        Name = "Ensure permissions on /etc/hosts.allow are configured."
                        FullDescription = "Ensure permissions on /etc/hosts.allow are configured."
                        PotentialImpact = "It is critical to ensure that the /etc/hosts.allow file is protected from unauthorized write access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 3.4.5" = @{
                        Name = "Ensure permissions on /etc/hosts.deny are configured."
                        FullDescription = "Ensure permissions on /etc/hosts.deny are configured."
                        PotentialImpact = "It is critical to ensure that the /etc/hosts.deny file is protected from unauthorized write access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 3.6.2" = @{
                        Name = "Ensure default deny firewall policy"
                        FullDescription = "Ensure default deny firewall policy"
                        PotentialImpact = "With a default accept policy the firewall will accept any packet that is not configured to be denied. It is easier to maintain a secure firewall with a default DROP policy than it is with a default ALLOW policy."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 5.3.1" = @{
                        Name = "Ensure password creation requirements are configured."
                        FullDescription = "Ensure password creation requirements are configured."
                        PotentialImpact = "Strong passwords protect systems from being hacked through brute force methods."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 5.3.2" = @{
                        Name = "Ensure lockout for failed password attempts is configured."
                        FullDescription = "Ensure lockout for failed password attempts is configured."
                        PotentialImpact = "Locking out user IDs after n unsuccessful consecutive login attempts mitigates brute force password attacks against your systems."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.7" = @{
                        Name = "Ensure all users' home directories exist"
                        FullDescription = "Ensure all users' home directories exist"
                        PotentialImpact = "If the user's home directory does not exist or is unassigned, the user will be placed in '/' and will not be able to write any files or have local environment variables set."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.9" = @{
                        Name = "Ensure users own their home directories"
                        FullDescription = "Ensure users own their home directories"
                        PotentialImpact = "Since the user is accountable for files stored in the user home directory, the user must be the owner of the directory."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.10" = @{
                        Name = "Ensure users' dot files are not group or world writable."
                        FullDescription = "Ensure users' dot files are not group or world writable."
                        PotentialImpact = "Group or world-writable user configuration files may enable malicious users to steal or modify other users' data or to gain another user's system privileges."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.11" = @{
                        Name = "Ensure no users have .forward files"
                        FullDescription = "Ensure no users have .forward files"
                        PotentialImpact = "Use of the .forward file poses a security risk in that sensitive data may be inadvertently transferred outside the organization. The .forward file also poses a risk as it can be used to execute commands that may perform unintended actions."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.12" = @{
                        Name = "Ensure no users have .netrc files"
                        FullDescription = "Ensure no users have .netrc files"
                        PotentialImpact = "The .netrc file presents a significant security risk since it stores passwords in unencrypted form. Even if FTP is disabled, user accounts may have brought over .netrc files from other systems which could pose a risk to those systems"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.14" = @{
                        Name = "Ensure no users have .rhosts files"
                        FullDescription = "Ensure no users have .rhosts files"
                        PotentialImpact = "This action is only meaningful if .rhosts support is permitted in the file /etc/pam.conf . Even though the .rhosts files are ineffective if support is disabled in /etc/pam.conf , they may have been brought over from other systems and could contain information useful to an attacker for those other systems."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.15" = @{
                        Name = "Ensure all groups in /etc/passwd exist in /etc/group"
                        FullDescription = "Ensure all groups in /etc/passwd exist in /etc/group"
                        PotentialImpact = "Groups which are defined in the /etc/passwd file but not in the /etc/group file pose a threat to system security since group permissions are not properly managed."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.16" = @{
                        Name = "Ensure no duplicate UIDs exist"
                        FullDescription = "Ensure no duplicate UIDs exist"
                        PotentialImpact = "Users must be assigned unique UIDs for accountability and to ensure appropriate access protections."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.17" = @{
                        Name = "Ensure no duplicate GIDs exist"
                        FullDescription = "Ensure no duplicate GIDs exist"
                        PotentialImpact = "Groups must be assigned unique GIDs for accountability and to ensure appropriate access protections."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.18" = @{
                        Name = "Ensure no duplicate user names exist"
                        FullDescription = "Ensure no duplicate user names exist"
                        PotentialImpact = "If a user is assigned a duplicate user name, it will create and have access to files with the first UID for that username in /etc/passwd . For example, if 'test4' has a UID of 1000 and a subsequent 'test4' entry has a UID of 2000, logging in as 'test4' will use UID 1000. Effectively, the UID is shared, which is a security problem."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.19" = @{
                        Name = "Ensure no duplicate groups exist"
                        FullDescription = "Ensure no duplicate groups exist"
                        PotentialImpact = "If a group is assigned a duplicate group name, it will create and have access to files with the first GID for that group in /etc/group . Effectively, the GID is shared, which is a security problem."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 6.2.20" = @{
                        Name = "Ensure shadow group is empty"
                        FullDescription = "Ensure shadow group is empty"
                        PotentialImpact = "Any users assigned to the shadow group would be granted read access to the /etc/shadow file. If attackers can gain read access to the /etc/shadow file, they can easily run a password cracking program against the hashed passwords to break them. Other security information that is stored in the /etc/shadow file (such as expiration) could also be useful to subvert additional user accounts."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 5.2.1" = @{
                        Name = "Ensure permissions on /etc/ssh/sshd_config are configured."
                        FullDescription = "Ensure permissions on /etc/ssh/sshd_config are configured."
                        PotentialImpact = "The /etc/ssh/sshd_config file needs to be protected from unauthorized changes by non-privileged users."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 106.1" = @{
                        Name = "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config Protocol &#61; 2'"
                        FullDescription = "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config Protocol &#61; 2'"
                        PotentialImpact = "An attacker could use flaws in an earlier version of the SSH protocol to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 106.3" = @{
                        Name = "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config IgnoreRhosts &#61; yes'"
                        FullDescription = "SSH must be configured and managed to meet best practices. - '/etc/ssh/sshd_config IgnoreRhosts &#61; yes'"
                        PotentialImpact = "An attacker could use flaws in the Rhosts protocol to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 106.5" = @{
                        Name = "Ensure SSH LogLevel is set to INFO"
                        FullDescription = "Ensure SSH LogLevel is set to INFO"
                        PotentialImpact = "SSH provides several logging levels with varying amounts of verbosity. DEBUG is specifically _not_ recommended other than strictly for debugging SSH communications since it provides so much data that it is difficult to identify important security information. INFO level is the basic level that only records login activity of SSH users. In many situations, such as Incident Response, it is important to determine when a particular user was active on a system. The logout record can eliminate those users who disconnected, which helps narrow the field."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 106.7" = @{
                        Name = "Ensure SSH MaxAuthTries is set to 6 or less"
                        FullDescription = "Ensure SSH MaxAuthTries is set to 6 or less"
                        PotentialImpact = "Setting the MaxAuthTries parameter to a low number will minimize the risk of successful brute force attacks to the SSH server. While the recommended setting is 4, set the number based on site policy."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 106.11" = @{
                        Name = "Ensure SSH access is limited"
                        FullDescription = "Ensure SSH access is limited"
                        PotentialImpact = "Restricting which users can remotely access the system via SSH will help ensure that only authorized users access the system."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 107" = @{
                        Name = "Emulation of the rsh command through the ssh server should be disabled. - '/etc/ssh/sshd_config RhostsRSAAuthentication &#61; no'"
                        FullDescription = "Emulation of the rsh command through the ssh server should be disabled. - '/etc/ssh/sshd_config RhostsRSAAuthentication &#61; no'"
                        PotentialImpact = "An attacker could use flaws in the RHosts protocol to gain access"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 108" = @{
                        Name = "SSH host-based authentication should be disabled. - '/etc/ssh/sshd_config HostbasedAuthentication &#61; no'"
                        FullDescription = "SSH host-based authentication should be disabled. - '/etc/ssh/sshd_config HostbasedAuthentication &#61; no'"
                        PotentialImpact = "An attacker could use use host-based authentication to gain access from a compromised host"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 109" = @{
                        Name = "Root login via SSH should be disabled. - '/etc/ssh/sshd_config PermitRootLogin = no'"
                        FullDescription = "Root login via SSH should be disabled. - '/etc/ssh/sshd_config PermitRootLogin = no'"
                        PotentialImpact = "An attacker could brute force the root password, or hide their command history by logging in directly as root"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 110" = @{
                        Name = "Remote connections from accounts with empty passwords should be disabled. - '/etc/ssh/sshd_config PermitEmptyPasswords &#61; no'"
                        FullDescription = "Remote connections from accounts with empty passwords should be disabled. - '/etc/ssh/sshd_config PermitEmptyPasswords &#61; no'"
                        PotentialImpact = "An attacker could gain access through password guessing"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 110.1" = @{
                        Name = "Ensure SSH Idle Timeout Interval is configured."
                        FullDescription = "Ensure SSH Idle Timeout Interval is configured."
                        PotentialImpact = "Having no timeout value associated with a connection could allow an unauthorized user access to another user's ssh session. Setting a timeout value at least reduces the risk of this happening. While the recommended setting is 300 seconds (5 minutes), set this timeout value based on site policy. The recommended setting for ClientAliveCountMax is 0. In this case, the client session will be terminated after 5 minutes of idle time and no keepalive messages will be sent."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 110.2" = @{
                        Name = "Ensure SSH LoginGraceTime is set to one minute or less."
                        FullDescription = "Ensure SSH LoginGraceTime is set to one minute or less."
                        PotentialImpact = "Setting the LoginGraceTime parameter to a low number will minimize the risk of successful brute force attacks to the SSH server. It will also limit the number of concurrent unauthenticated connections While the recommended setting is 60 seconds (1 Minute), set the number based on site policy."
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 110.3" = @{
                        Name = "Ensure only approved MAC algorithms are used"
                        FullDescription = "Ensure only approved MAC algorithms are used"
                        PotentialImpact = "MD5 and 96-bit MAC algorithms are considered weak and have been shown to increase exploitability in SSH downgrade attacks. Weak algorithms continue to have a great deal of attention as a weak spot that can be exploited with expanded computing power. An attacker that breaks the algorithm could take advantage of a MiTM position to decrypt the SSH tunnel and capture credentials and information"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 111.2" = @{
                        Name = "SSH warning banner should be enabled. - '/etc/ssh/sshd_config Banner = /etc/issue.net'"
                        FullDescription = "SSH warning banner should be enabled. - '/etc/ssh/sshd_config Banner = /etc/issue.net'"
                        PotentialImpact = "Users will not be warned that their actions on the system are monitored"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 112" = @{
                        Name = "Users are not allowed to set environment options for SSH."
                        FullDescription = "Users are not allowed to set environment options for SSH."
                        PotentialImpact = "An attacker may be able to bypass some access restrictions over SSH"
                        Vulnerability = ""
                        Enabled = $true
                        }

                "MSID 113" = @{
                        Name = "Appropriate ciphers should be used for SSH. (Ciphers aes128-ctr,aes192-ctr,aes256-ctr)"
                        FullDescription = "Appropriate ciphers should be used for SSH. (Ciphers aes128-ctr,aes192-ctr,aes256-ctr)"
                        PotentialImpact = "An attacker could compromise a weakly secured SSH connection"
                        Vulnerability = ""
                        Enabled = $true
                        }
    }
}
