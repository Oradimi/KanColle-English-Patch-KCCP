# Simple program to clear some Chromium browsers' cache;
$Host.UI.RawUI.WindowTitle = "Browser/Viewer Cache Clear";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the Browser Cache Clearer!";
Write-Host "Use this little program to just clear your cache.";
Write-Host "It will also restart KCCacheProxy to reload your mods' data if running.";
Write-Host "";
Write-Host "Every browser/viewer selected by you will be closed," -ForegroundColor Yellow;
Write-Host "make sure your ongoing work/game is saved/done!" -ForegroundColor Yellow;
Write-Host "You can restore your session afterwards by manually restarting your browser/viewer." -ForegroundColor Yellow;
Write-Host "If you don't want to close your browser, please clear your cache manually." -ForegroundColor Yellow;
Write-Host "";
Write-Host "When manually clearing your cache, make sure to set the Time range to All time," -ForegroundColor Yellow;
Write-Host "and select only Cached images and files." -ForegroundColor Yellow;
Write-Host "";
Write-Host "If your browser/viewer isn't in the list,";
Write-Host "you will have to clear your browser/viewer's cache manually.";
Write-Host "Contact Oradimi#8947 on Discord to add support to your browser/viewer.";
Write-Host "";
Try {
	$loadFile = Get-Content -Raw -Path .\EN-patch-manager\browserprefs.json -ErrorAction Stop | ConvertFrom-Json; # Load the version.json file and convert as a readonly powershell object
	[System.Collections.ArrayList] $TaskkillList += $loadFile;
	ForEach ($k in $TaskkillList) {
		Switch ($k) {
			69 {$currentBrowsers += "Poi, "} # Poi;
			82 {$currentBrowsers += "Electronic Observer, "} # ElectronicObserver;
			84 {$currentBrowsers += "Chromium/Google Chrome, "} # Chromium and Google Chrome;
			89 {$currentBrowsers += "Microsoft Edge, "} # Microsoft Edge;
			85 {$currentBrowsers += "Opera/GX, "} # Opera and Opera GX;
			73 {$currentBrowsers += "Brave, "} # Brave;
			79 {$currentBrowsers += "Vivaldi, "} # Vivaldi;
			80 {$currentBrowsers += "Yandex, "} # Yandex;
		};
	};
	$currentBrowsers = $currentBrowsers.TrimEnd(", ") + ".";
} Catch {
	Write-Host "Preference File Not Found!";
	Write-Host "";
	$TaskkillList = New-Object System.Collections.ArrayList($null);
};

If ($TaskkillList.Count -eq 0) {
	Write-Host "-> Close this window to cancel.";
	Write-Host "-> Press any key to proceed to the selection...";
	$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
} Else {
	Write-Host "Currently Selected Browsers:" $currentBrowsers;
	Write-Host "-> Press Escape to modify saved browsers.";
	Write-Host "-> Close this window to cancel.";
	Write-Host "-> Press Enter to clear selected browsers' cache.";
	Do {
		$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
		If ($PressedKey -eq 13) {
			Write-Host "";
		}
	} Until ($PressedKey -eq 27 -or $PressedKey -eq 13)
};



If ($PressedKey -eq 27 -or $TaskkillList.Count -eq 0) {
	# Asks for the browsers the user wants to clear the cache from;
	$FullList = @(69,82,84,89,85,73,79,80);
	$Notice = "";
	Write-Host "";
	Write-Host "[E] Poi        [R] EO     [T] Chrome/Chromium  [Y] Microsoft Edge";
	Write-Host "[U] Opera(GX)  [I] Brave  [O] Vivaldi          [P] Yandex";
	Write-Host "";
	Do {
		If ($TaskkillList.Count -eq 0) {
			Write-Host "-> Use the keys above to add/remove a browser in the clear list.";
			Write-Host "-> Press Enter to clear everything (No Preferences Saved)."
		} Else {
			$currentBrowsers = "";
			ForEach ($k in $TaskkillList) {
				Switch ($k) {
					69 {$currentBrowsers += "Poi, "} # Poi;
					82 {$currentBrowsers += "Electronic Observer, "} # ElectronicObserver;
					84 {$currentBrowsers += "Chromium/Google Chrome, "} # Chromium and Google Chrome;
					89 {$currentBrowsers += "Microsoft Edge, "} # Microsoft Edge;
					85 {$currentBrowsers += "Opera/GX, "} # Opera and Opera GX;
					73 {$currentBrowsers += "Brave, "} # Brave;
					79 {$currentBrowsers += "Vivaldi, "} # Vivaldi;
					80 {$currentBrowsers += "Yandex, "} # Yandex;
				}
			};
			$currentBrowsers = $currentBrowsers.TrimEnd(", ") + ".";
			Write-Host "Currently Selected Browsers:" $currentBrowsers;
			Write-Host "-> Use the keys above to add/remove a browser in the clear list.";
			Write-Host "-> Press Enter to clear the selected browsers.";
		};
		Do {
			$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
		} Until ($FullList -contains $PressedKey -or $PressedKey -eq 13)
		If ((-not ($TaskkillList -contains $PressedKey)) -and ($FullList -contains $PressedKey)) {
			[System.Collections.ArrayList] $TaskkillList += $PressedKey;
			$Notice1 = "Added"
			$Notice2 = "to remove"
		} ElseIf ($TaskkillList -contains $PressedKey) {
		[System.Collections.ArrayList] $TaskkillList.Remove($PressedKey);
		$Notice1 = "Removed"
		$Notice2 = "to add again"
		}
		Write-Host "";
		Switch ($PressedKey) {
			69 {Write-Host "$Notice1 Poi. Press [E] $Notice2."}
			82 {Write-Host "$Notice1 ElectronicObserver. Press [R] $Notice2."}
			84 {Write-Host "$Notice1 Chrome/Chromium. Press [T] $Notice2."}
			89 {Write-Host "$Notice1 Microsoft Edge. Press [Y] $Notice2."}
			85 {Write-Host "$Notice1 Opera (Normal and GX). Press [U] $Notice2."}
			73 {Write-Host "$Notice1 Brave. Press [I] $Notice2."}
			79 {Write-Host "$Notice1 Vivaldi. Press [O] $Notice2."}
			80 {Write-Host "$Notice1 Yandex. Press [P] $Notice2."}
		}
	} Until ($PressedKey -eq 13);
};

If ($TaskkillList.Count -eq 0) {
	$TaskkillList = $FullList;
} Else {
	$output = "[" + $($TaskkillList -join ",") + "]"
	$output | Out-File .\EN-patch-manager\browserprefs.json;
};

# Forcefully kills selected Chromium browsers after adding them to another list;
$Browsers = @();
$OperaBrowsers = @();
$EOBrowser = '';
$EOFolder = "\_null";
$PoiBrowser = '';
$PoiFolder = "\_null";
ForEach ($k in $TaskkillList) {
	Switch ($k) {
		69 {
			taskkill /F /IM "poi.exe";
			$PoiBrowser = 'poi';
			$PoiFolder = "$($env:APPDATA)\$PoiBrowser"
		} # Poi;
		82 {
			taskkill /F /IM "ElectronicObserver.exe";
			$EOBrowser = 'ElectronicObserver\Webview2\EBWebView';
			$EOFolder = "$($env:LOCALAPPDATA)\$EOBrowser"
		} # ElectronicObserver;
		84 {
			taskkill /F /IM "chrome.exe";
			$Browsers += 'Chromium';
			$Browsers += 'Google\Chrome'
		} # Chromium and Google Chrome;
		89 {
			taskkill /F /IM "msedge.exe";
			$Browsers += 'Microsoft\Edge'
		} # Microsoft Edge;
		85 {
			taskkill /F /IM "opera.exe";
			$OperaBrowsers = @('Opera Software\Opera Stable', 'Opera Software\Opera GX Stable')
		} # Opera and Opera GX;
		73 {
			taskkill /F /IM "brave.exe";
			$Browsers += 'BraveSoftware\Brave-Browser'
		} # Brave;
		79 {
			taskkill /F /IM "vivaldi.exe";
			$Browsers += 'Vivaldi'
		} # Vivaldi;
		80 {
			taskkill /F /IM "browser.exe";
			$Browsers += 'Yandex\YandexBrowser'
		} # Yandex;
	}
};

# Gets currently running KCCacheProxy instance path;
$running = Get-Process | ForEach-Object {$_.Path};
ForEach ($_ in $running) {
	If ($_ -ne $null) {
		If ($_.contains("KCCacheProxy.exe")) {
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
Write-Host "";
Try {
	& $kccpPath $null *> $null
	Write-Host "KCCacheProxy was successfully relaunched!" -ForegroundColor Green
} Catch {
	Write-Host "KCCacheProxy was not launched. Please restart it manually." -ForegroundColor Yellow
};

If ($CacheDeleted) {
	Write-Host "Browser/viewer cache cleared!" -ForegroundColor Green
} Else {
	Write-Host "Failed to locate any cache folder, or no cache to delete." -ForegroundColor Yellow
};
