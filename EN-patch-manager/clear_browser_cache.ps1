# Simple program to clear some Chromium browsers' cache;
$Host.UI.RawUI.WindowTitle = "Browser/Viewer Cache Clear";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the Browser Cache Clearer!";
Write-Host "Use this little program to just clear your cache.";
Write-Host "Every browser/viewer selected by you will be closed,";
Write-Host "make sure your ongoing work/game is saved/done!";
Write-Host "";
Write-Host "Will also restart KCCacheProxy to reload your mods' data if it's already running." -ForegroundColor Green;
Write-Host "Restore your session afterwards by manually restarting your browser/viewer." -ForegroundColor Green;
Write-Host "";
Write-Host "If your browser/viewer isn't in the list," -ForegroundColor Yellow;
Write-Host "you will have to clear your browser/viewer's cache manually." -ForegroundColor Yellow;
Write-Host "Contact Oradimi#8947 on Discord to add support to your browser/viewer." -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Close this window to cancel.";
Write-Host "-> Press any key to proceed to the selection...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# Asks for the browsers the user wants to clear the cache from;
$TaskkillList = New-Object System.Collections.ArrayList($null);
$FullList = @(69,82,84,89,85,73,79,80);
$Notice = "";
Write-Host "";
Write-Host "[E] Poi        [R] EO     [T] Chrome/Chromium  [Y] Microsoft Edge";
Write-Host "[U] Opera(GX)  [I] Brave  [O] Vivaldi          [P] Yandex";
Write-Host "";
Write-Host "-> Use the keys above to add/remove a browser in the clear list.";
Do
{
	If($TaskkillList.Count -eq 0)
	{
		Write-Host "-> Press Enter to clear everything (default)."
	}
	Else
	{
		Write-Host "-> Press Enter to clear the selected browsers."
	}
	Do
	{
		$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
	}
	Until ($FullList -contains $PressedKey -or $PressedKey -eq 13)
	If((-not ($TaskkillList -contains $PressedKey)) -and ($FullList -contains $PressedKey))
	{
		[System.Collections.ArrayList] $TaskkillList += $PressedKey;
		$Notice1 = "Added"
		$Notice2 = "to remove"
	}
	ElseIf($TaskkillList -contains $PressedKey)
	{
		[System.Collections.ArrayList] $TaskkillList.Remove($PressedKey);
		$Notice1 = "Removed"
		$Notice2 = "to add again"
	}
	Write-Host "";
	Switch ($PressedKey)
	{
		69 {Write-Host "$Notice1 Poi. Press [E] $Notice2."}
		82 {Write-Host "$Notice1 ElectronicObserver. Press [R] $Notice2."}
		84 {Write-Host "$Notice1 Chrome/Chromium. Press [T] $Notice2."}
		89 {Write-Host "$Notice1 Microsoft Edge. Press [Y] $Notice2."}
		85 {Write-Host "$Notice1 Opera (Normal and GX). Press [U] $Notice2."}
		73 {Write-Host "$Notice1 Brave. Press [I] $Notice2."}
		79 {Write-Host "$Notice1 Vivaldi. Press [O] $Notice2."}
		80 {Write-Host "$Notice1 Yandex. Press [P] $Notice2."}
	}
}
Until ($PressedKey -eq 13);

If($TaskkillList.Count -eq 0)
{
	$TaskkillList = $FullList;
};

# Forcefully kills selected Chromium browsers after adding them to another list;
$Browsers = @();
$OperaBrowsers = @();
$EOBrowser = '';
$EOFolder = "\_null";
$PoiBrowser = '';
$PoiFolder = "\_null";
ForEach($k in $TaskkillList)
{
	Switch ($k)
	{
		69 
		{
			taskkill /F /IM "poi.exe";
			$PoiBrowser = 'poi';
			$PoiFolder = "$($env:APPDATA)\$PoiBrowser"
		} # Poi;
		82
		{
			taskkill /F /IM "ElectronicObserver.exe";
			$EOBrowser = 'ElectronicObserver\Webview2\EBWebView';
			$EOFolder = "$($env:LOCALAPPDATA)\$EOBrowser"
		} # ElectronicObserver;
		84
		{
			taskkill /F /IM "chrome.exe";
			$Browsers += 'Chromium';
			$Browsers += 'Google\Chrome'
		} # Chromium and Google Chrome;
		89
		{
			taskkill /F /IM "msedge.exe";
			$Browsers += 'Microsoft\Edge'
		} # Microsoft Edge;
		85
		{
			taskkill /F /IM "opera.exe";
			$OperaBrowsers = @('Opera Software\Opera Stable', 'Opera Software\Opera GX Stable')
		} # Opera and Opera GX;
		73
		{
			taskkill /F /IM "brave.exe";
			$Browsers += 'BraveSoftware\Brave-Browser'
		} # Brave;
		79
		{
			taskkill /F /IM "vivaldi.exe";
			$Browsers += 'Vivaldi'
		} # Vivaldi;
		80
		{
			taskkill /F /IM "browser.exe";
			$Browsers += 'Yandex\YandexBrowser'
		} # Yandex;
	}
};

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

# Forcefully kills KCCacheProxy;
taskkill /F /IM "kccacheproxy.exe";

# Attempts to clear browsers cache;
$Items = @('Cache\*');
$CacheDeleted = $false;
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
	Write-Host "Failed to locate any cache folder, or no cache to delete." -ForegroundColor Yellow
};
Write-Host "Make sure to clear your browser/viewer's cache" -ForegroundColor Yellow;
Write-Host "if you're not using a supported browser/viewer!" -ForegroundColor Yellow;
