---
title: Windows Installer Batch Script Revisited
author: Matthew Sojourner Newton
date: 2012-07-18 15:33
template: article.jade
---

## Recap
In a previous post, ["Windows Versioning and UAC Elevation in a Batch Script"](/post/27496719688/windows-versioning-and-uac-elevation-in-a-batch-script), I shared a script I wrote (with the help of some other blogs) in order to install Citrix Single Sign-On (aka Password Manager). It is modular, however, and there are a numer of pieces that could be repurposed for a variety of automated installation applications.

Since publishing that post, I have evolved the script noticeably. The biggest changes revolve around my client's changing needs with respect to the specifics of the Citrix Single Sign-On deployment. 

## Lessons Learned
However, there are a number of things that I learned while writing and revising this script that I think will be useful to those who need to deploy Windows applications across a network. These include:

 - How to detect Windows versions using just batch script
 - How to Elevate UAC with a single batch script
 - How to properly run a batch script with multiple parts from a UNC path
 - How best to react to installer success, error, and reboot prompts from batch scripts
 - How to check for installation of a package and install it only if necessary, all from the batch script
 - How to uninstall a package from a batch script

I think that's a sizable percentage of the common problems you find when writing slightly complex install scripts

## Why batch files?
There are many systems to deploy applications to Windows computers. You have fancy things like Microsoft System Center Configuration Manager (SCCM) and other tools like VBScript and PowerShell. Only VBScript is ubiquitous across Windows XP and up. When necessary, VBScript is a nice tool; however, it's a lot heavier to develop and would have made this script much longer, without adding anything particularly useful.

## Detect Windows versions
First, we need to know what we're working with. We use the `ver` command together with `findstr` (Windows' answer to `grep`) to decide which version of Windows the script is running against:
    
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

## Elevate User Account Control (UAC)
The crux of this script is handling Windows Vista/7 User Account Control. Since the script could have been run in an un-elevated state, we need to check and if necessary run a new script, since we can't elevate a program once it's already running (that's the whole point of UAC!). 
The user will receive a UAC prompt at this point if Windows is configured to do so.
Yes, there's a little VBScript in there. Use when necessary.

    REM ===========================================================================
    REM Elevate credentials
    REM ===========================================================================
    
    :warn_and_proceed
      echo Cannot determine Windows version, proceeding anyway...

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
      REM we are done, exiting recursive call
      exit /B
    
      if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
      echo We have admin privileges, proceeding...
    
## Run install commands from the UNC working directory
We finally get to the meat of the script. The first line tests whether the package is already installed by querying the registry for its Installer GUID. The rest is just housekeeping. 

    REM ===========================================================================
    REM Run (privileged) Install Commands
    REM ===========================================================================
    
    :prerequisites
    echo Installing prerequisites...
    
    REM Install vc80_vcredist_x86 if not already installed
    >nul 2>&1 reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{710f4c1c-cc18-4c49-8cbf-51240c89a1a2}
    if %ERRORLEVEL% == 0 (
      echo. vc80_vcredist_x86 already installed
    ) else (
      echo. Installing vc80_vcredist_x86
      start /wait %~dp0vc80_vcredist_x86.exe /q
      if %ERRORLEVEL% == 0 (
        echo.  SUCCESS
      ) else (
        if %ERRORLEVEL% == 3010 (
          echo. SUCCESS, reboot required
          set REBOOT_FLAG=1
        ) else (
          echo. ERROR = %ERRORLEVEL%
        )
      )
    )
    
However, there is one particular part that may throw you off.

     start /wait %~dp0vc80_vcredist_x86.exe /q

What is that `%~dp0` business? This is because the script is meant to be run from a UNC path. Most scripts, when executed, work from the directory where their file is located, or the CWD, depending on how they were launched. When you run a script from `\\server\share` you do not have that luxury. So how do you ensure that you can copy your script anywhere and not have to re-write every reference to every file?
Enter `%~dp0`. That prefix tells `command.com` to use the script's own path to find the file. In the case of the above command, it would expand it to:

     start /wait \\server\share\vc80_vcredist_x86.exe /q

Very handy. And odd. But that is the way of batch scripting. Nothing but corner cases. `command.com` must have a lot of corners.

## All together now
Finally, here is the complete script for your reference, slicing and dicing. If you use it, it would make me happy for you to let me know, and perhaps even share your modifications here.

    @ECHO OFF

    REM ===========================================================================
    REM ===========================================================================
    REM Elevated credential install script
    REM Created by Matt Newton
    REM 07.17.2012
    REM matt@mnewton.com
    REM
    REM This script checks for Windows OS version and if Vista or 7 is detected
    REM then it re-runs itself within a VBS wrapper to elevate the credentials.
    REM It then runs the :install commands, cleans up temp files, and exits.
    REM ===========================================================================
    REM ===========================================================================

    set REBOOT_FLAG=0

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

    :warn_and_proceed
      echo Cannott determine Windows version, proceeding anyway...

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
      REM we are done, exiting recursive call
      exit /B


    REM ===========================================================================
    REM Identify OS Versions
    REM ===========================================================================

    :ver_2000
    echo OS Version: Windows 2000
    goto gotAdmin

    :ver_XP
    echo OS Version: Windows XP
    goto gotAdmin

    :ver_2003
    echo OS Version: Windows 2003
    goto gotAdmin


    :gotAdmin
      if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
      echo We have admin privileges, proceeding...


    :install
    REM ===========================================================================
    REM Run (privileged) Install Commands
    REM ===========================================================================

    :prerequisites
    echo Installing prerequisites...

    REM Install vc80_vcredist_x86 if not already installed
    >nul 2>&1 reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{710f4c1c-cc18-4c49-8cbf-51240c89a1a2}
    if %ERRORLEVEL% == 0 (
      echo. vc80_vcredist_x86 already installed
    ) else (
      echo. Installing vc80_vcredist_x86
      start /wait %~dp0vc80_vcredist_x86.exe /q
      if %ERRORLEVEL% == 0 (
        echo.  SUCCESS
      ) else (
        if %ERRORLEVEL% == 3010 (
          echo. SUCCESS, reboot required
          set REBOOT_FLAG=1
        ) else (
          echo. ERROR = %ERRORLEVEL%
        )
      )
    )


    REM Install vc90_vcredist_x86 if not already installed
    >nul 2>&1 reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1F1C2DFC-2D24-3E06-BCB8-725134ADF989}
    if %ERRORLEVEL% == 0 (
      echo. vc90_vcredist_x86 already installed
    ) else (
      echo. Installing vc90_vcredist_x86
      start /wait %~dp0vc90_vcredist_x86.exe /q
      if %ERRORLEVEL% == 0 (
        echo.  SUCCESS
      ) else ( 
        if %ERRORLEVEL% == 3010 (
          echo. SUCCESS, reboot required
          set REBOOT_FLAG=1
        ) else (
          echo. ERROR = %ERRORLEVEL%
        )
      )
    )


    REM Install if on Windows 32 bit
    if %processor_architecture% == x86 (
      REM Test if Citrix Receiver is installed
      >nul 2>&1 dir /s "C:\Program Files\Citrix\receiver.exe"
      if %ERRORLEVEL% == 0 (
        echo. Citrix Receiver already installed
      ) else (
        echo. Installing Citrix Receiver
        start /wait msiexec /i %~dp0Receiver\RIInstaller.msi /passive /norestart
        if %ERRORLEVEL% == 0 (
          echo.  SUCCESS
        ) else ( 
          if %ERRORLEVEL% == 3010 (
            echo. SUCCESS, reboot required
            set REBOOT_FLAG=1
          ) else (
            echo.  ERROR = %ERRORLEVEL%
          )
        )
      )
      

      REM Install SSO Plugin if not already installed
      >nul 2>&1 dir /s "c:\Program Files\Citrix\JavaBridge.dll"
      if %ERRORLEVEL% == 0 (
        echo SSO Agent x86 may have the wrong modules, uninstalling
        start /wait msiexec /x {A0C5486E-58A8-48FB-91ED-53881E019700} /passive /norestart
        if %ERRORLEVEL% == 0 (
          echo.  SUCCESS
        ) else ( 
          if %ERRORLEVEL% == 3010 (
            echo. SUCCESS, reboot required
            set REBOOT_FLAG=1
          ) else (
            echo. ERROR = %ERRORLEVEL%
          )
        )
      )

      REM  %~dp0CitrixSSOPlugin32.exe /silent SYNCPOINTTYPE=FileSyncPath SYNCPOINTLOC=\\server\CITRIXSYNC$ DI_SELECT=1 SSPR_SELECT=1 SERVICEURL="https://server/MPMService/"
      REM An argument of "/forcerestart" can be added to the end to automatically restart

      echo Installing Citrix Single Sign-On Plugin 5.0 32 bit
      start /wait msiexec /i %~dp0SSOPlugin32\SFPDSSOPlugin32.msi /passive /norestart
      if %ERRORLEVEL% == 0 (
        echo.  SUCCESS
      ) else ( 
        if %ERRORLEVEL% == 3010 (
          echo. SUCCESS, reboot required
          set REBOOT_FLAG=1
        ) else (
          echo. ERROR = %ERRORLEVEL%
        )
      )
    )


    REM Install if on Windows 64 bit
    if %processor_architecture% == AMD64 (
      echo Installing x64 prerequisites...

      >nul 2>&1 reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{071c9b48-7c32-4621-a0ac-3f809523288f}
      if %ERRORLEVEL% == 0 (
        echo. vc80_vcredist_x64 already installed
      ) else (
        echo. Installing vc80_vcredist_x64
        start /wait %~dp0vc80_vcredist_x64.exe /q
        if %ERRORLEVEL% == 0 (
          echo.  SUCCESS
        ) else ( 
          if %ERRORLEVEL% == 3010 (
            echo. SUCCESS, reboot required
            set REBOOT_FLAG=1
          ) else (
            echo. ERROR = %ERRORLEVEL%
          )
        )
      )

      >nul 2>&1 reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{4B6C7001-C7D6-3710-913E-5BC23FCE91E6}
      if %ERRORLEVEL% == 0 (
        echo. vc90_vcredist_x64 already installed
      ) else (
        echo. Installing vc90_vcredist_x64
        start /wait %~dp0vc90_vcredist_x64.exe /q
        if %ERRORLEVEL% == 0 (
          echo.  SUCCESS
        ) else ( 
          if %ERRORLEVEL% == 3010 (
            echo. SUCCESS, reboot required
            set REBOOT_FLAG=1
          ) else (
            echo. ERROR = %ERRORLEVEL%
          )
        )
      )


      REM Test if Citrix Receiver is installed
      >nul 2>&1 dir /s "C:\Program Files (x86)\Citrix\receiver.exe"
      if %ERRORLEVEL% == 0 (
        echo. Citrix Receiver already installed
      ) else (
        echo. Installing Citrix Receiver
        start /wait msiexec /i %~dp0Reciever\RIInstaller.msi /passive /norestart
        if %ERRORLEVEL% == 0 (
          echo.  SUCCESS
        ) else ( 
          if %ERRORLEVEL% == 3010 (
            echo. SUCCESS, reboot required
            set REBOOT_FLAG=1
          ) else (
            echo.  ERROR = %ERRORLEVEL%
          )
        )
      )
      

      REM Install SSO Plugin if not already installed
      >nul 2>&1 dir /s "c:\Program Files (x86)\Citrix\ssoShell.exe"
      if %ERRORLEVEL% == 0 (
        echo SSO Agent x86 is already installed, uninstalling
        start /wait msiexec /x {FC95142E-AD05-4ECB-9F13-93466D6B5C69} /passive /norestart
      )

      REM  %~dp0CitrixSSOPlugin64.exe /silent SYNCPOINTTYPE=FileSyncPath SYNCPOINTLOC=\\server\CITRIXSYNC$ DI_SELECT=1 SSPR_SELECT=1 SERVICEURL="https://server/MPMService/"
      REM An argument of "/forcerestart" can be added to the end to automatically restart

      echo Installing Citrix Single Sign-On Plugin 5.0 64 bit
      start /wait msiexec /i %~dp0\SSOPlugin64\SFPDSSOPlugin64.msi /passive /norestart
      if %ERRORLEVEL% == 0 (
        echo.  SUCCESS
      ) else ( 
        if %ERRORLEVEL% == 3010 (
          echo. SUCCESS, reboot required
          set REBOOT_FLAG=1
        ) else (
          echo. ERROR = %ERRORLEVEL%
        )
      )
    )


    echo Installation complete
    if %REBOOT_FLAG% == 0 (
      echo You may need to restart the Citrix SSO Plugin manually
      echo Please press any key to end the install routine
      pause
      exit /B
    ) else (
      echo Please press any key to restart your computer
      pause
      shutdown -r -c "Citrix SSO Plugin Install" -t 0
    )


## Credits
Once again, thank you Evan Greene. I used [your UAC script](http://sites.google.com/site/eneerge/home/BatchGotAdmin) as a starting point for this one. 
