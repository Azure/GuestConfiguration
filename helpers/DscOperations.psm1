Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Import-Module $PSScriptRoot/GuestConfigPath.psm1 -Force

$script:ExecuteDscOperationsScript = @"
using System;
using System.Runtime.InteropServices;
using System.Management.Automation;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace GuestConfig
{{
    public class DscOperations
    {{
        [DllImport("{0}", CharSet = CharSet.Ansi, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        public static extern IntPtr new_dsc_library_context(string assignment_name, string dsc_binary_path, IntPtr writeMessageCallback, IntPtr writeErrorCallback, IntPtr writeResultCallback);

        [DllImport("{0}", CharSet = CharSet.Ansi, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        public static extern Int32 test_dsc_configuration(IntPtr context, string job_id, string assignment_name, string file_path);

        [DllImport("{0}", CharSet = CharSet.Ansi, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        public static extern Int32 get_dsc_configuration(IntPtr context, string job_id, string assignment_name, string file_path);

        [DllImport("{0}", CharSet = CharSet.Ansi, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        public static extern Int32 publish_dsc_assignment(IntPtr context, string job_id, string assignment_name, string assignments_path);

        [DllImport("{0}", CharSet = CharSet.Ansi, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        public static extern Int32 set_dsc_meta_configuration(IntPtr context, string job_id, string assignment_name, string assignments_path);

        [DllImport("{0}", CharSet = CharSet.Ansi, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        public static extern void delete_dsc_library_context(IntPtr context);

        internal enum MessageChannel
        {{
            Warning,
            Verbose,
            Debug,
            Error
        }}

        public DscOperations()
        {{
            m_messages = new List<Tuple<MessageChannel, string>>();
            m_result = "";

            WriteMessageDelegate delegate_write_message = new WriteMessageDelegate(WriteMessage);
            GCHandle m_write_message_gc_handle = GCHandle.Alloc(delegate_write_message);
            m_write_message_callback = Marshal.GetFunctionPointerForDelegate(delegate_write_message);

            WriteErrorDelegate delegate_write_error = new WriteErrorDelegate(WriteError);
            m_write_error_gc_handle = GCHandle.Alloc(delegate_write_error);
            m_write_error_callback = Marshal.GetFunctionPointerForDelegate(delegate_write_error);

            WriteResultDelegate delegate_write_result = new WriteResultDelegate(WriteResult);
            m_write_result_gc_handle = GCHandle.Alloc(delegate_write_result);
            m_write_result_callback = Marshal.GetFunctionPointerForDelegate(delegate_write_result);
        }}

        ~DscOperations()
        {{
            if (m_write_message_gc_handle.IsAllocated)
            {{
                m_write_message_gc_handle.Free();
            }}

            if (m_write_error_gc_handle.IsAllocated)
            {{
                m_write_error_gc_handle.Free();
            }}

            if (m_write_result_gc_handle.IsAllocated)
            {{
                m_write_result_gc_handle.Free();
            }}
        }}

        public string TestDscConfiguration(PSCmdlet ps_cmdlet, string job_id, string configuration_name, string gc_bin_path)
        {{
            IntPtr context = IntPtr.Zero;
            try
            {{
                ClearMessages();

                context = new_dsc_library_context(configuration_name, gc_bin_path, m_write_message_callback, m_write_error_callback, m_write_result_callback);
                if(context == IntPtr.Zero) 
                {{
                    ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", "Failed to initialize Guest Configuration library.", true));
                }}

                Int32 result = test_dsc_configuration(context, job_id, configuration_name, "");
                for (int i = 0; i < m_messages.Count; i++) 
                {{
                    var message = m_messages[i];
                    if(message.Item1 == MessageChannel.Error) 
                    {{
                        ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", message.Item2, false));
                    }}
                    else if(message.Item1 == MessageChannel.Warning) 
                    {{
                        ps_cmdlet.WriteWarning(message.Item2);
                    }}
                    else if(message.Item1 == MessageChannel.Debug) 
                    {{
                        ps_cmdlet.WriteDebug(message.Item2);
                    }}
                    else 
                    {{
                        ps_cmdlet.WriteVerbose(message.Item2);
                    }}
                }}
            }}
            finally 
            {{
                delete_dsc_library_context(context);
            }}

            return m_result;
        }}

        public string GettDscConfiguration(PSCmdlet ps_cmdlet, string job_id, string configuration_name, string gc_bin_path)
        {{
            IntPtr context = IntPtr.Zero;
            try
            {{
                ClearMessages();

                context = new_dsc_library_context(configuration_name, gc_bin_path, m_write_message_callback, m_write_error_callback, m_write_result_callback);
                if(context == IntPtr.Zero) 
                {{
                    ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", "Failed to initialize Guest Configuration library.", true));
                }}

                Int32 result = get_dsc_configuration(context, job_id, configuration_name, "");
                for (int i = 0; i < m_messages.Count; i++) 
                {{
                    var message = m_messages[i];
                    if(message.Item1 == MessageChannel.Error) 
                    {{
                        ps_cmdlet.WriteError(new ErrorRecord(
                                    new InvalidOperationException(message.Item2),
                                    "TestGuestConfiguration",
                                    ErrorCategory.InvalidResult,
                                    null));
                    }}
                    else if(message.Item1 == MessageChannel.Warning) 
                    {{
                        ps_cmdlet.WriteWarning(message.Item2);
                    }}
                    else 
                    {{
                        ps_cmdlet.WriteVerbose(message.Item2);
                    }}
                }}
            }}
            finally 
            {{
                delete_dsc_library_context(context);
            }}

            return m_result;
        }}

        public void PublishDscConfiguration(PSCmdlet ps_cmdlet, string job_id, string configuration_name, string gc_bin_path, string policy_path)
        {{
            IntPtr context = IntPtr.Zero;
            try
            {{
                ClearMessages();

                context = new_dsc_library_context(configuration_name, gc_bin_path, m_write_message_callback, m_write_error_callback, m_write_result_callback);
                if(context == IntPtr.Zero)
                {{
                    ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", "Failed to initialize Guest Configuration library.", true));
                }}

                Int32 result = publish_dsc_assignment(context, job_id, configuration_name, policy_path);
                if(result != 0)
                {{
                    ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", "Failed to publish Guest Configuration policy package.", true));
                }}
            }}
            finally 
            {{
                delete_dsc_library_context(context);
            }}
        }}

        public void SetDscLocalConfigurationManager(PSCmdlet ps_cmdlet, string job_id, string configuration_name, string gc_bin_path, string policy_path)
        {{
            IntPtr context = IntPtr.Zero;
            try
            {{
                ClearMessages();

                context = new_dsc_library_context(configuration_name, gc_bin_path, m_write_message_callback, m_write_error_callback, m_write_result_callback);
                if(context == IntPtr.Zero)
                {{
                    ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", "Failed to initialize Guest Configuration library.", true));
                }}

                Int32 result = set_dsc_meta_configuration(context, job_id, configuration_name, policy_path);
                if(result != 0) 
                {{
                    ps_cmdlet.WriteError(CreateErrorRecord("TestGuestConfiguration", "Failed to set Meta config settings.", true));
                }}
            }}
            finally 
            {{
                delete_dsc_library_context(context);
            }}
        }}

        private delegate Int32 WriteMessageDelegate(Int32 channel, IntPtr message);
        private delegate Int32 WriteErrorDelegate(IntPtr error);
        private delegate Int32 WriteResultDelegate(IntPtr result);

        private string m_result;
        private List<Tuple<MessageChannel, string>> m_messages;

        private GCHandle m_write_message_gc_handle;
        private GCHandle m_write_error_gc_handle;
        private GCHandle m_write_result_gc_handle;
        private IntPtr m_write_message_callback;
        private IntPtr m_write_error_callback;
        private IntPtr m_write_result_callback;

        internal Int32 WriteMessage(Int32 channel, IntPtr message_ptr)
        {{
            string message;
            message = Marshal.PtrToStringAnsi(message_ptr);
            m_messages.Add(Tuple.Create((MessageChannel)channel, message));
            return 0;
        }}

        internal Int32 WriteError(IntPtr error_ptr)
        {{
            string error;
            error = Marshal.PtrToStringAnsi(error_ptr);
            m_messages.Add(Tuple.Create(MessageChannel.Error, error));
            return 0;
        }}

        internal Int32 WriteResult(IntPtr result_ptr)
        {{
            m_result = Marshal.PtrToStringAnsi(result_ptr);
            return 0;
        }}

        private void ClearMessages()
        {{
            m_messages.Clear();
        }}

        private ErrorRecord CreateErrorRecord(string error_id, string error_message, bool include_error_from_message_list) 
        {{
            string error = error_message + "\r\n";
            for (int i = 0; include_error_from_message_list && i < m_messages.Count; i++) 
            {{
                var message = m_messages[i];
                if(message.Item1 == MessageChannel.Error) 
                {{
                    error = message.Item2 + "\r\n";
                }}
            }}

            return new ErrorRecord(
                    new InvalidOperationException(error),
                    error_id,
                    ErrorCategory.InvalidResult,
                    null);
        }}
    }}
}}
"@


<#
    .SYNOPSIS
        Test DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Test-DscConfiguration -ConfigurationName WindowsTLS
#>

function Test-DscConfiguration
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.TestDscConfiguration($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath)

    return ConvertFrom-Json $result
}

<#
    .SYNOPSIS
        Get DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Get-DscConfiguration -ConfigurationName WindowsTLS
#>

function Get-DscConfiguration
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.GettDscConfiguration($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath)

    return ConvertFrom-Json $result
}

<#
    .SYNOPSIS
        Publish DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Publish-DscConfiguration -Path C:\metaconfig
#>

function Publish-DscConfiguration
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName,

        [parameter(Position=1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.PublishDscConfiguration($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath, $Path)
}

<#
    .SYNOPSIS
        Set DSC LCM settings.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Set-DscLocalConfigurationManager -Path C:\metaconfig
#>

function Set-DscLocalConfigurationManager
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName,

        [parameter(Position=1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.SetDscLocalConfigurationManager($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath, $Path)
}