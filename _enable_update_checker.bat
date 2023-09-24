@echo off

set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\kc_en_patch_update_checker.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%~dp0\launch_bat.vbs" >> %SCRIPT%
echo oLink.WorkingDirectory = "%~dp0" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%

echo Update checker enabled!
echo A hidden Visual Basic file will now be run each time you launch your system.
echo It will only check if the current version is lower than the latest.
echo If it's not, it closes itself immediately.
echo If it is, it will prompt you to download the latest version.
echo If you ever move your English Patch folder or rename it,
echo you must disable the update checker and enable it again.
echo ~
echo This program may set off some anti-viruses.
echo These are false positives and can be disregarded.
echo I would recommend whitelisting the English Patch folder in your anti-virus.
echo If anything ever happens, a zip containing the necessary files have been provided.
echo You can unzip it in place to restore the manager to its original state.
echo ~
echo You can now close this window.
pause