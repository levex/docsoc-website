---
title: Windows Versioning and UAC Elevation in a Batch Script
author: Matthew Sojourner Newton
date: 2012-05-23 12:24
template: article.jade
---

**Edited 07/18/2012: See updated post, [Windows Installer Batch Script Revisited](/post/27511333721/windows-installer-batch-script-revisited)**


Recently, I needed to write a script that would install multiple independent components onto Windows XP and Windows 7 machines. The Windows 7 machines would be both 32-bit and 64-bit architectures. 
The install routine needed to:
Determine which Windows version it was running on
Elevate UAC (User Account Control) on the Windows 7 machines.
Determine which processor architecture it was running on (32 bit or 64 bit)
Run other install routines according to the above findings and report on their success
Run itself and other routintes from a UNC share
It turns out there is no simple way to elevate UAC in a batch file. You have to drop to VBScript. The whole routine is a pain to write in VBScript though, because VBScript is a terrible mess of a language.

After some searching, I stumbled across this post with a great script by Evan Greene that I used as a starting point:
http://sites.google.com/site/eneerge/home/BatchGotAdmin

Thanks Evan!

I wrapped some additional code around it to determine OS version and processor architecture.

Check it out:

    @ECHO OFF

    REM ===========================================================================
    REM Check Windows Version
    REM ===========================================================================

    ver | findstr /i "5\.0\." > nul
    IF %ERRORLEVEL% == 0 goto ver_2000
    ver | findstr /i "5\.1\." > nul
    IF %ERRORLEVEL% == 0 goto ver_XP
    ver | findstr /i "5\.2\." > nul
    IF %ERRORLEVEL% == 0 goto ver_2003
    ver | findstr /i "6\.0\." > nul
    IF %ERRORLEVEL% == 0 goto ver_Vista
    ver | findstr /i "6\.1\." > nul
    IF %ERRORLEVEL% == 0 goto ver_Win7
    goto warn_and_proceed

    :ver_Win7
    echo OS Version: Windows 7
    goto elevate

    :ver_Vista
    echo OS Version: Windows Vista
    goto elevate


    REM ===========================================================================
    REM Elevate credentials
    REM ===========================================================================

    :elevate
    REM Check for permissions
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

    REM If error flag set, we do not have admin.
    if '%errorlevel%' NEQ '0' (
      echo Requesting administrative privileges...
      goto UACPrompt
    ) else ( goto gotAdmin )


    :UACPrompt
      echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
      echo UAC.ShellExecute "%~s0", "", "", "runas", 1  >> "%temp%\getadmin.vbs"
     
      "%temp%\getadmin.vbs"
      exit /B

    :warn_and_proceed
      echo Cannot determine Windows version, proceeding anyway...

    :gotAdmin
    :ver_2000
    :ver_XP
    :ver_2003
      if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
      echo We have admin privileges, proceeding...


    REM ===========================================================================
    REM Run privileged commands
    REM ===========================================================================

    echo Executing install commands
    start /wait %~dp0vc80_vcredist_x86.exe /q
    if %ERRORLEVEL% == 0 (
      echo.  vc_redist_x86 installed successfully
      ) else ( 
      echo.  ERROR in installing vc_redist_x86
      )

    if %processor_architecture% == x86 (
      echo Installing 32 bit version
      %~dp0CitrixSSOPlugin32.exe /silent SYNCPOINTTYPE=FileSyncPath  SSPR_SELECT=1
      if %ERRORLEVEL% == 0 (
        echo.  Citrix SSO Plugin 32-bit installed successfully
      ) else (
        echo.  ERROR in installing Citrix SSO Plugin 32-bit
      )
    )

    if %processor_architecture% == AMD64 (
      echo Installing 64 bit version
      %~dp0vc80_vcredist_x64.exe /q
      if %ERRORLEVEL% == 0 (
        echo.  vc_redist_x64 installed successfully
        ) else ( 
        echo.  ERROR in installing vc_redist_x64
      )
      %~dp0CitrixSSOPlugin64.exe /silent SYNCPOINTTYPE=FileSyncPath SSPR_SELECT=1
      if %ERRORLEVEL% == 0 (
        echo.  Citrix SSO Plugin 64-bit installed successfully
      ) else (
        echo.  ERROR in installing Citrix SSO Plugin 64-bit
      )
    )

    echo Script execution complete
    echo You may close this window now.
    pause

Hopefully this will help you out.
