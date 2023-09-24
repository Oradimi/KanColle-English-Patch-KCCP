# Checks if there's an update for the English Patch;
$host.ui.RawUI.WindowTitle = "KanColle English Patch Update Checker";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path; 
$pwd = $pwd.replace("\","/") + "/";

# Gets the online path and the file containing diff info;
$gitPath = "https://raw.githubusercontent.com/Oradimi/KanColle-English-Patch-KCCP/master/";
Invoke-WebRequest ($gitPath + "version.json") -O ($pwd + "version.json"); 

# Gets the current version;
$ENpatchContent = Get-Content -Raw -Path .\EN-patch.mod.json | ConvertFrom-Json;
$verCur = $ENpatchContent.version;

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
	Exit
};

Start-Process -FilePath ".\EN-patch-manager\update_notice.bat"