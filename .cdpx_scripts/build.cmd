REM -----------------------------------------------------------------------------------------------------------------------------
REM
REM SYNOPSIS
REM This script is triggered by CDPx YML files to restore Nuget packages required by projects inside our main Visual Studio solution.
REM
REM ARGS1 RelativeLogFileName (Optional)
REM     The repo relative log file path where logs will be written to.
REM     Defaults to 'buildLogs\RestoreStorSimple.log' if not specified.
REM
REM NOTE
REM DO NOT ADD VSTS Build environment variables here as this script is designed to run on a CDPx local developer environment.
REM
REM -----------------------------------------------------------------------------------------------------------------------------

echo "Running build command for Windows ..."

rem Save working directory so that we can restore it back after building everything. This will make developers happy and then
rem switch to the folder this script resides in. Don't assume absolute paths because on the build host and on the dev host the locations may be different.
pushd .
cd "%~dp0"

set guestConfigRoot=%CD%
echo extension root path ..%guestConfigRoot%...
where.exe pwsh
call %SYSTEMDRIVE%\Windows\system32\WindowsPowershell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File %guestConfigRoot%\build.ps1
call %SYSTEMDRIVE%\Program Files\PowerShell\7\pwsh.exe -ExecutionPolicy Unrestricted -File %guestConfigRoot%\build.ps1
echo "Finished running build command  ..."

exit 0
