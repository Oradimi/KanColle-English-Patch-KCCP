# Simple updater to update the English Patch;
$host.ui.RawUI.WindowTitle = "KanColle English Patch Quick Updater";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Welcome to the KanColle English Patch Quick Updater!";
Write-Host "You can use this updater to update your patch from v3.01 or newer to the latest version.";
Write-Host "";
Write-Host "Make sure you're connected to the Internet before updating!" -ForegroundColor Yellow;
Write-Host "This can take a while, be sure to wait until the end!" -ForegroundColor Yellow;
Write-Host "";
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
$verCur = $ENpatchContent.version;

# Old version names support;
If($verCur.length -lt 6)
{
	If($verCur.contains("a"))
	{
		$verCur = $verCur.substring(0,4);
		$verCur += ".1"
	}
	ElseIf($verCur.contains("b"))
	{
		$verCur = $verCur.substring(0,4);
		$verCur += ".2"
	}
	Else
	{
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
ForEach($ver in $versionContent.version)
{
	If($verNewFlag)
	{
		$verNew = $versionContent[$i];
		$delURI += ,@($verNew.del);
        $delURI[$j] = [System.Collections.ArrayList]$delURI[$j];
		$addURI += ,@($verNew.add);
        $addURI[$j] = [System.Collections.ArrayList]$addURI[$j];
        $j += 1
	}
	ElseIf($ver -eq $verCur)
	{
		$verNewFlag = $true
	}
	$i += 1
};
$verSkip = $j - 1;

# If current version is the same as the latest;
If($j -eq 0)
{
	Write-Host "No new version available, or invalid current version." -ForegroundColor Yellow;
	Write-Host "If you are still using v1 or v2 of the English Patch," -ForegroundColor Yellow;
	Write-Host "please get the latest version from GitHub." -ForegroundColor Yellow;
	Write-Host "";
	Write-Host "-> Close this window to not proceed to clear your cache.";
	Write-Host "-> Press any key to proceed to clear your cache...";
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	Write-Host "";
	Write-Host "";
	Write-Host "";
	Write-Host "";
	Write-Host "";
	Write-Host "";
	Exit
};

# Removes any duplicate mention of added/modified files;
For($i = $verSkip; $i -ge 1; $i--)
{
	For($j = $i - 1; $j -ge 0; $j--)
	{
		ForEach($k in $addURI[$i])
		{
			If($addURI[$j] -contains $k)
			{
				$addURI[$j].Remove($k)
			}
		}
	}
};

# Deletes then downloads each mentionned file, version after version;
For($i = 0; $i -le $verSkip; $i++)
{
    ForEach($uri in $delURI[$i])
    {
		If (Test-Path -Path ($pwd + $uri))
		{
			Write-Host "Deleting" $uri"...";
			Remove-Item -Path ($pwd + $uri) -Recurse -Force
		}
    }
    ForEach($uri in $addURI[$i])
    {
		Try
		{
			Write-Host "Downloading" $uri"...";
			Invoke-WebRequest ($gitPath + $uri) -O (New-Item -Path ($pwd + $uri) -Force)
		}
		Catch [System.Net.WebException]
		{
			Write-Host "File deleted from server, skipping" $uri
		}
    }
};

Write-Host "";
Write-Host "Done updating! Please clear your cache to finish the update process." -ForegroundColor Green;
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
