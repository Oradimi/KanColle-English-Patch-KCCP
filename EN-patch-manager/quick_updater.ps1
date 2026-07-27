# Simple updater to update the English Patch;
$host.ui.RawUI.WindowTitle = "KanColle English Patch Quick Updater v0.6.1";
$PSversion = $PSVersionTable.PSVersion.Major;
If ($PSversion -lt 5) {
	Write-Host "Welcome to the KanColle English Patch Quick Updater v0.6.1!";
	Write-Host "";
	Write-Host "Your version of PowerShell is not supported." -ForegroundColor Red;
	Write-Host "";
	Write-Host "You can download a supported version here:";
	Write-Host "https://www.microsoft.com/en-us/download/details.aspx?id=54616";
	Write-Host "Click on download, and select either `"Win7-KB3191566-x86.zip`"";
	Write-Host "or `"Win8.1-KB3191564-x86.msu`" depending on your operating system.";
	Write-Host "Then, run the downloaded files.";
	Write-Host "The cache clearer does work on your version,";
	Write-Host "so you may proceed to clear your cache now if you would like.";
	Write-Host "";
	Write-Host "-> Hold the Ctrl key and click on the link to open it.";
	Write-Host "-> Close this window to not proceed to clear your cache.";
	Write-Host "-> Press any key (except Ctrl) to proceed to clear your cache...";
	Do {
		$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
	} Until ($PressedKey -ne 17)
	Write-Host "";
	Write-Host "";
	Exit
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the KanColle English Patch Quick Updater v0.6.1!";
Write-Host "You can use this updater to update your patch from v3.01 or newer to the latest version.";
Write-Host "";
Write-Host "This program may set off some anti-viruses." -ForegroundColor Yellow;
Write-Host "These are false positives and can be disregarded." -ForegroundColor Yellow;
Write-Host "I would recommend whitelisting the English Patch folder in your anti-virus." -ForegroundColor Yellow;
Write-Host "If anything ever happens, a zip containing the necessary files have been provided." -ForegroundColor Yellow;
Write-Host "You can unzip it in place to restore the manager to its original state." -ForegroundColor Yellow;
Write-Host "";
Write-Host "Make sure you're connected to the Internet before updating!" -ForegroundColor Yellow;
Write-Host "This can take a while, be sure to wait until the end!" -ForegroundColor Yellow;
Write-Host "";
Try {
	$previousVersion = Get-Content -Raw -Path .\EN-patch-manager\download_interrupted.txt -ErrorAction Stop; # Load the download_interrupted.txt file as an array of its lines;
	$downloadInterrupted = $true;
	Write-Host "The updater was not closed correctly on its last use." -ForegroundColor Red;
	Write-Host "It will restart the download from v$previousVersion." -ForegroundColor Red;
	Write-Host "";
} Catch {
	$downloadInterrupted = $false
};
Write-Host "-> Close this window to cancel.";
Write-Host "-> Press any key to update...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host "";
Write-Host "Updating version.json...";

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path; 
$pwd = $pwd.replace("\","/") + "/";

# Gets the online path and the file containing diff info;
$gitPath = "https://raw.githubusercontent.com/Oradimi/KanColle-English-Patch-KCCP/master/";
Invoke-WebRequest ($gitPath + "version.json") -O ($pwd + "version.json"); 

Write-Host "";
Write-Host "Parsing contents...";

# Gets the current version;
$ENpatchContent = Get-Content -Raw -Path .\EN-patch.mod.json | ConvertFrom-Json;
If ($downloadInterrupted) {
	$verCur = $previousVersion
} Else {
	$verCur = $ENpatchContent.version
}

# Old version names support;
If ($verCur.length -lt 6) {
	If ($verCur.contains("a")) {
		$verCur = $verCur.substring(0,4);
		$verCur += ".1"
	} ElseIf ($verCur.contains("b")) {
		$verCur = $verCur.substring(0,4);
		$verCur += ".2"
	} Else {
		$verCur += ".0"
	}
};

# Compares current version with available versions;
# Adds deleted files and new/modified files from newer versions in arrays;
$versionContent = Get-Content -Raw -Path version.json | ConvertFrom-Json;
[bool] $verNewFlag = $false;
$delURI = New-Object System.Collections.ArrayList($null);
$addURI = New-Object System.Collections.ArrayList($null);
$i = 0;
$j = 0;
ForEach ($ver in $versionContent.version) {
	If ($verNewFlag) {
		$verNew = $versionContent[$i];
		$delURI += ,@($verNew.del);
        $delURI[$j] = [System.Collections.ArrayList]$delURI[$j];
		$addURI += ,@($verNew.add);
        $addURI[$j] = [System.Collections.ArrayList]$addURI[$j];
        $j += 1
	} ElseIf ($ver -eq $verCur) {
		$verNewFlag = $true
	}
	$i += 1
};
$verSkip = $j - 1;

# If current version is the same as the latest;
If ($j -eq 0) {
	Write-Host "No new version available, or invalid current version." -ForegroundColor Yellow;
	Write-Host "If you are still using v1 or v2 of the English Patch," -ForegroundColor Yellow;
	Write-Host "please get the latest version from GitHub." -ForegroundColor Yellow;
	Write-Host "";
	Write-Host "-> Close this window to not proceed to clear your cache.";
	Write-Host "-> Press any key to proceed to clear your cache...";
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	Write-Host "";
	Write-Host "";
	Exit
};

$downloadInterruptedFile = ".\EN-patch-manager\download_interrupted.txt";
$verCur | Out-File $downloadInterruptedFile -NoNewline;

# Removes any duplicate mention of added/modified files;
For ($i = $verSkip; $i -ge 1; $i--) {
	For ($j = $i - 1; $j -ge 0; $j--) {
		ForEach ($k in $addURI[$i]) {
			If ($addURI[$j] -contains $k) {
				$addURI[$j].Remove($k)
			}
		}
	}
};

Write-Host "";
Write-Host "Updating...";
# Deletes then downloads each mentionned file, version after version;
$sw = [System.Diagnostics.Stopwatch]::StartNew();
$fileHistory = New-Object System.Collections.ArrayList($null);
For ($i = 0; $i -le $verSkip; $i++) {
	$a = $i + 1;
	$b = $verSkip + 1;
	$u = $versionContent[$versionContent.count - $b + $i].version;
	Write-Progress -Activity 'Updating the English Patch...' -Status "Update $a out of $b (v$u)" `
		-PercentComplete ([Math]::Floor($a / $b * 100))
	$j = 0;
    ForEach ($uri in $delURI[$i]) {
		If (Test-Path -Path ($pwd + $uri)) {
			if ($sw.Elapsed.TotalMilliseconds -ge 200) {
				$c = $j + 1;
				$d = $delURI[$i].count;
				Write-Progress -ID 1 -Activity 'Deleting files...' -Status "File $c out of $d" `
					-PercentComplete ([Math]::Floor($c / $d * 100))
				$sw.Restart();
				$fileHistory | Out-Host;
				$fileHistory.clear()
			};
			Remove-Item -Path ($pwd + $uri) -Recurse -Force;
			$fileHistory += "Deleted $uri";
			$j++
		}
    };
	$k = 0;
	ForEach ($uri in $addURI[$i]) {
		if ($sw.Elapsed.TotalMilliseconds -ge 200) {
			$c = $k + 1;
			$d = $addURI[$i].count;
			Write-Progress -ID 1 -Activity 'Downloading files...' -Status "File $c out of $d" `
				-PercentComplete ([Math]::Floor($c / $d * 100))
			$sw.Restart();
			$fileHistory | Out-Host;
			$fileHistory.clear()
		};
		Try {
			$ProgressPreference = 'SilentlyContinue';
			Invoke-WebRequest ($gitPath + $uri) -O (New-Item -Path ($pwd + $uri) -Force);
			$fileHistory += "Downloaded $uri";
			$ProgressPreference = 'Continue'
		} Catch [System.Net.WebException] {
			$fileHistory += "Skipped $uri (File deleted from server)"
			$ProgressPreference = 'Continue';
		};
		$k++
    };
	$fileHistory.clear()
};

Write-Host "";
Write-Host "Done updating! Proceeding to cache clear..." -ForegroundColor Green;
Write-Host "";
Write-Host "";

Remove-Item -Path ($downloadInterruptedFile) -Recurse -Force
