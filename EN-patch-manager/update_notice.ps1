# Notifies the user of an update to the English Patch;
$host.ui.RawUI.WindowTitle = "KanColle English Patch Update Notice";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path; 
$pwd = $pwd.replace("\","/") + "/";

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
$verLat = $versionContent.version[$versionContent.count - 1];

Write-Host "An update to the KanColle English Patch is available (v$verLat).";
Write-Host "(You are currently using v$verCur)";
Write-Host "Would you like to download it now?";
Write-Host "-> Close this window to cancel. (No)";
Write-Host "-> Press any key to launcher the updater... (Yes)";

$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode;

Write-Host "";
Write-Host "";