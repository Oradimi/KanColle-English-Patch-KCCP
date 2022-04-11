# Simple program to move the new experimental font in the patch;
$host.ui.RawUI.WindowTitle = "KanColle English Patch New Font Beta Test";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the KanColle English Patch new experimental font installer!";
Write-Host "You can use this installer to test out the new font on which";
Write-Host "the English Patch will base its raw text on in the future.";
Write-Host "";
Write-Host "You can find the font in EN-patch/kcs2/resources/" -ForegroundColor Yellow;
Write-Host "If you don't want to use the font anymore, delete the 'font' folder inside." -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Close this window to cancel.";
Write-Host "-> Press any key to install...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path;
$pwd = $pwd.replace("\","/") + "/";

# Copies the font folder on the root to the correct location;
Copy-Item -Path ($pwd + "font") -Destination ($pwd + "EN-patch/kcs2/resources") -Recurse -Force;

Write-Host "";
Write-Host "Done installing! Please clear your cache to finish the installation process." -ForegroundColor Green;
Write-Host "";
Write-Host "-> Close this window to not proceed to clear your cache.";
Write-Host "-> Press any key to proceed to clear your cache...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Write-Host "";
Write-Host "";
Write-Host "";
Write-Host "";
Write-Host "";
Write-Host "";
