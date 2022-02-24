# Simple program to clear some Chromium browsers' cache;
$host.ui.RawUI.WindowTitle = "Browser/viewer Cache Clear";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the Browser Cache Clearer!";
Write-Host "Use this little program to just clear your cache.";
Write-Host "Every browser/viewer listed below will be closed,";
Write-Host "make sure your ongoing work/game is saved/done!";
Write-Host "";
Write-Host "Supported browsers/viewers:" -ForegroundColor Green;
Write-Host "    - Poi" -ForegroundColor Green;
Write-Host "    - Electronic Observer" -ForegroundColor Green;
Write-Host "    - Chromium" -ForegroundColor Green;
Write-Host "    - Google Chrome" -ForegroundColor Green;
Write-Host "    - Microsoft Edge (Chromium version)" -ForegroundColor Green;
Write-Host "    - Opera (Normal and GX)" -ForegroundColor Green;
Write-Host "    - Brave" -ForegroundColor Green;
Write-Host "    - Vivaldi" -ForegroundColor Green;
Write-Host "    - Yandex" -ForegroundColor Green;
Write-Host "";
Write-Host "Will also restart KCCacheProxy to reload your mods' data if it's already running." -ForegroundColor Green;
Write-Host "Restore your session afterwards by manually restarting your browser/viewer." -ForegroundColor Green;
Write-Host "";
Write-Host "If your browser/viewer doesn't close automatically," -ForegroundColor Yellow;
Write-Host "you will have to clear your browser/viewer's cache manually." -ForegroundColor Yellow;
Write-Host "Contact Oradimi#8947 on Discord to add support to your browser/viewer." -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Close this window to cancel.";
Write-Host "-> Press any key to clear your cache...";
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

# Forcefully kills some Chromium browsers;
taskkill /F /IM "poi.exe"; # Poi;
taskkill /F /IM "ElectronicObserver.exe"; # ElectronicObserver;
taskkill /F /IM "chrome.exe"; # Chromium and Google Chrome;
taskkill /F /IM "msedge.exe"; # Microsoft Edge;
taskkill /F /IM "opera.exe"; # Opera and Opera GX;
taskkill /F /IM "brave.exe"; # Brave;
taskkill /F /IM "vivaldi.exe"; # Vivaldi;
taskkill /F /IM "browser.exe"; # Yandex;

# Forcefully kills KCCacheProxy;
taskkill /F /IM "kccacheproxy.exe";

# Clears browsers cache;
$Items = @('Cache\*');
$CacheDeleted = $false;

$Browsers = @('Chromium', 'Google\Chrome', 'Microsoft\Edge', 'BraveSoftware\Brave-Browser',
	'Vivaldi', 'Yandex\YandexBrowser');
ForEach ($Browser in $Browsers) {
	$Folder = "$($env:LOCALAPPDATA)\$Browser\User Data";
	If (Test-Path "$Folder") {
		$Profiles = Get-ChildItem -Path $Folder | Where-Object {
			$_.Name -Like "Profile*" -or $_.Name -eq "Default"
		}
		ForEach ($Profile in $Profiles) {
			$Profile = $Profile.Name;
			$Items | % { 
				If (Test-Path "$Folder\$Profile\$_") {
					Remove-Item "$Folder\$Profile\$_" -Recurse -Force;
					Write-Host "Found $Browser cache in $Profile folder! Successfully deleted." -ForegroundColor Green;
					$CacheDeleted = $true
				}
			}
		}
	}
};

$OperaBrowsers = @('Opera Software\Opera Stable', 'Opera Software\Opera GX Stable');
ForEach ($OperaBrowser in $OperaBrowsers) {
	$OperaFolder = "$($env:LOCALAPPDATA)\$OperaBrowser";
	If (Test-Path "$OperaFolder") {
		$Items | % { 
			If (Test-Path "$OperaFolder\$_") {
				Remove-Item "$OperaFolder\$_" -Recurse -Force;
				Write-Host "Found $OperaBrowser cache! Successfully deleted." -ForegroundColor Green;
				$CacheDeleted = $true
			}
		}
	}
};

$EOBrowser = 'ElectronicObserver\Webview2\EBWebView';
$EOFolder = "$($env:LOCALAPPDATA)\$EOBrowser";
If (Test-Path "$EOFolder") {
	$EOProfiles = Get-ChildItem -Path $EOFolder | Where-Object {
		$_.Name -Like "Profile*" -or $_.Name -eq "Default"
	}
	ForEach ($EOProfile in $EOProfiles) {
		$EOProfile = $EOProfile.Name;
		$Items | % { 
			If (Test-Path "$EOFolder\$Profile\$_") {
				Remove-Item "$EOFolder\$Profile\$_" -Recurse -Force;
				Write-Host "Found $EOBrowser cache in $Profile folder! Successfully deleted." -ForegroundColor Green;
				$CacheDeleted = $true
			}
		}
	}
};

$PoiBrowser = 'poi';
$PoiFolder = "$($env:APPDATA)\$PoiBrowser";
If (Test-Path "$PoiFolder") {
	$Items | % { 
		If (Test-Path "$PoiFolder\$_") {
			Remove-Item "$PoiFolder\$_" -Recurse -Force;
			Write-Host "Found $PoiBrowser cache! Successfully deleted." -ForegroundColor Green;
			$CacheDeleted = $true
		}
	}
};

# Restarts KCCacheProxy;
Try
{
	& $kccpPath $null *> $null
	Write-Host "KCCacheProxy was successfully relaunched!" -ForegroundColor Green
}
Catch
{
	Write-Host "KCCacheProxy was not launched. Please restart it manually." -ForegroundColor Yellow
};

Write-Host "";
If ($CacheDeleted) {
	Write-Host "Browser/viewer cache cleared!" -ForegroundColor Green
}
Else {
	Write-Host "Failed to locate cache folder, or no cache to delete." -ForegroundColor Yellow
};
Write-Host "Make sure to clear your browser/viewer's cache" -ForegroundColor Yellow;
Write-Host "if you're not using a supported browser/viewer!" -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Press any key to close...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
