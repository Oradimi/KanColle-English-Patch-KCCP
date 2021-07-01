# Simple program to move the new experimental font in the patch;
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the KanColle English Patch new experimental font installer!" -ForegroundColor Blue;
Write-Host "";
Write-Host "You can use this installer to test out the new font on which" -ForegroundColor Green;
Write-Host "the English Patch will base its raw text on in the future." -ForegroundColor Green;
Write-Host "This program will force Chrome to shut down and clear its cache." -ForegroundColor Green;
Write-Host "You can restore your session afterwards by manually restarting Chrome." -ForegroundColor Green;
Write-Host "It will also restart KCCacheProxy to reload the mod's data if it's already running." -ForegroundColor Green;
Write-Host "";
Write-Host "If you're not using Chrome, you will have to clear your browser's cache manually." -ForegroundColor Yellow;
Write-Host "You can find the font in EN-patch/kcs2/resources/" -ForegroundColor Yellow;
Write-Host "If you don't want to use the font anymore, delete the 'font' folder." -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Close this window to cancel.";
Write-Host "-> Press any key to install...";
Write-Host "";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# Gets currently running KCCacheProxy instance path;
$running = Get-Process | ForEach-Object {$_.Path};
ForEach($_ in $running) 
{
	If($_ -ne $null)
	{
		If($_.contains("KCCacheProxy.exe"))
		{
			$kccpPath = $_
		}
	}
};

# Forcefully kills Chrome and KCCacheProxy;
taskkill /F /IM "chrome.exe";
taskkill /F /IM "kccacheproxy.exe";

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path;
$pwd = $pwd.replace("\","/") + "/";

# Copies the font folder on the root to the correct location;
Copy-Item -Path ($pwd + "font") -Destination ($pwd + "EN-patch/kcs2/resources") -Recurse -Force

# Clears Chrome's cache;
$Items = @('Cache\*') ;
$Folder = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default";
$Items | % { 
    if (Test-Path "$Folder\$_") {
        Remove-Item "$Folder\$_" 
    }
};

# Restarts KCCacheProxy;
Try
{
	& $kccpPath $null *> $null
}
Catch
{
	Write-Host "KCCacheProxy was not launched. Please restart it manually." -ForegroundColor Yellow
};

Write-Host "";
Write-Host "Done installing!" -ForegroundColor Yellow;
Write-Host "Make sure to clear your browser/viewer's cache if you're not using Chrome!" -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Press any key to close...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')