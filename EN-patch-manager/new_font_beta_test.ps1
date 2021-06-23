# Simple program to move the new experimental font in the patch.
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the KanColle English Patch new experimental font installer!";
Write-Host "You can use this installer to test out the new font on which";
Write-Host "the English Patch will base its raw text on in the future.";
Write-Host "You can find the font in EN-patch/kcs2/resources/";
Write-Host "If you don't want to use the font anymore, delete the 'font' folder.";
Write-Host "Close the window to cancel.";
Write-Host "Press any key to install...";

$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
$pwd = Get-Location | select -ExpandProperty Path; # Gets current path. Note will only work if the script is ran from the master directory.
$pwd = $pwd.replace("\","/") + "/";
Copy-Item -Path ($pwd + "font") -Destination ($pwd + "EN-patch/kcs2/resources") -Recurse

Write-Host "";
Write-Host "Done!";
Write-Host "";
Write-Host "To finish the installation process, click on reload mod data";
Write-Host "within KCCacheProxy, and clear your browser cache!";
Write-Host "For Chrome, hit Ctrl+Shift+Del in Chrome,";
Write-Host "select 'All time' and only the last box.";
Write-Host "Press any key to close...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');