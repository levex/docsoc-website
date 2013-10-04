---
title: Unrolling Citrix Single Sign-On Plugin
author: Matthew Sojourner Newton
date: 2012-07-18 15:05
template: article.jade
---

# The Problem
The Citrix Single Sign-On Plugin (aka Citrix Password Manager) is a decent way to manage user passwords across a typical, fairly homogeneous Windows Enterprise Environment. It is not given as much love by Citrix as I would like, and it has its quirks. But all password management systems do.

Today, though, I found a particulary irksome quirk. There is no way to tell the install routine NOT to install the Java Bridge module, which is used to save and replay passwords in Java applications. Most would not find this a horrible problem, but my client happens to have a Java application that is horribly broken by Citrix's Java Bridge module. So it has to go!

Other modules can be easily installed, or not, using command line switches. See Citrix's documentation:
[To install the Password Manager agent software silently from a command prompt](http://support.citrix.com/proddocs/topic/passwordmanager/pm-install-agent-to-silent-install.html)

You think perhaps there is an install option but it's just not documented? I doubt this. if you comb through the install media, including the XML file (SSOPlugin32Metadata.xml), you will not find any reference at all to the Java module. It appears to be needlessly baked in.

How do we engineer around this deficiency?

## Preparation
First, I grabbed the CitrixSSOPlugin32.exe from the XenApp 6.5 media. It is a self-contained .exe installer. However, like most .exe installers, it can be easily split up into its constituent parts using 7-zip or RAR.

Along with support files and directories, you will find two standard .msi files: one for Citrix Receiver and one for SSO.

# Solution: MSI Administrative Install
Once I had the raw msi files, the rest is easy and well documented by Microsoft. I create an Administrative Install. 

    msiexec /a "Citrix Single Sign-On.msi"

After running the above command, a standard install wizard popped up. I went through it as you would in a manual install until it completed.

Once completed, however, I was left with a new directory containing an Administrative Install, with all of the options and parameters I chose during the wizard baked directly into the installation.

That's all there is to it. I did, however, think of some alternative solutions if that didn't work.

## Alternative Solution #1
You could use [Microsoft Orca](http://msdn.microsoft.com/en-us/library/windows/desktop/aa370557%28v=vs.85%29.aspx) to rip out the offending section. This is a very brute force way of accomplishing our goal. Simply search for Java in the modules section and delete the reference.

## Alternative Solution #2
Lastly, if none of those options worked my last resort was to simply unlink the JavaBridge.dll:

    regsvr32.exe /u "C:\Program Files\Citrix\Password Manager\helper\JavaBridge.dll"

Thankfully, the administrative install worked perfectly for our case.

All of this would be unnecessary, however, if Citrix exposed a transform option to disable that module, just as they do for other modules in the Plugin. Please update your install routines, Citrix! There is a reason MSI files were created and when you gloss over functionality that is baked into the architecture in the first place you hurt yourselves and you hurt your users.

Please let me know if any of this helped you out. Cheers.
