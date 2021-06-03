# Simple updater to update the English Patch.
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Welcome to the KanColle English Patch quick updater!";
Write-Host "You can use this updater to update your patch from v3.01.0 to any more recent version.";
Write-Host "Please read the instructions once the update is done!";
Write-Host "Make sure you're connected to the Internet before updating!";
Write-Host "This can take a while (pretty ironic considering the name), be sure to wait until the end!";
Write-Host "Press any key to update...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host "";
Write-Host "Updating version.json...";
$pwd = Get-Location | select -ExpandProperty Path; # Gets current path. Note will only work if the script is ran from the master directory.
$pwd = $pwd.replace("\","/") + "/";
$gitPath = "https://raw.githubusercontent.com/InochiPM/KanColle-English-Patch-KCCP/master/";
Invoke-WebRequest ($gitPath + "version.json") -O ($pwd + "version.json"); # Gets the file containing diff info # Gets the file containing diff info
Write-Host "";
Write-Host "Parsing contents...";
$ENpatchContent = Get-Content -Raw -Path .\EN-patch.mod.json | ConvertFrom-Json;
$verCur = $ENpatchContent.version;

If($verCur.length -lt 6) # Whole block to support old version names
{
	If($verCur.contains("a"))
	{
		$verCur = $verCur.substring(0,4);
		$verCur += ".1";
	}
	ElseIf($verCur.contains("b"))
	{
		$verCur = $verCur.substring(0,4);
		$verCur += ".2";
	}
	Else
	{
		$verCur += ".0";
	}
}

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
        $j += 1;
	}
	ElseIf($ver -eq $verCur)
	{
		$verNewFlag = $true;
	}
	$i += 1;
}
$verSkip = $j - 1

If($j -eq 0)
{
	Write-Host "No new version available, or invalid current version.";
	Write-Host "If you are still using v1 or v2 of the English Patch,";
	Write-Host "please get the latest version from GitHub.";
	Write-Host "Press any key to close...";
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	Exit;
}

For($i = $verSkip; $i -ge 1; $i--)
{
	For($j = $i - 1; $j -ge 0; $j--)
	{
		ForEach($k in $addURI[$i])
		{
			If($addURI[$j] -contains $k)
			{
				$addURI[$j].Remove($k);
			}
		}
	}
}

For($i = 0; $i -le $verSkip; $i++)
{
    ForEach($uri in $delURI[$i])
    {
		If (Test-Path -Path ($pwd + $uri))
		{
			Write-Host "Deleting" $uri"...";
			Remove-Item -Path ($pwd + $uri);
		}
    }
    ForEach($uri in $addURI[$i])
    {
		Try
		{
			Write-Host "Downloading" $uri"...";
			Invoke-WebRequest ($gitPath + $uri) -O (New-Item -Path ($pwd + $uri) -Force);
		}
		Catch [System.Net.WebException]
		{
			Write-Host "File deleted from server, skipping" $uri;
		}
    }
}

Write-Host "";
Write-Host "Done!";
Write-Host "";
Write-Host "To finish the update process, click on reload mod data";
Write-Host "within KCCacheProxy, and clear your browser cache!";
Write-Host "For Chrome, hit Ctrl+Shift+Del in Chrome,";
Write-Host "select 'All time' and only the last box.";
Write-Host "Press any key to close...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
