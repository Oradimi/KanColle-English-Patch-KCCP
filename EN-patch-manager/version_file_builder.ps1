$loadFile = Get-Content -Raw -Path version.json | ConvertFrom-Json; # Load the version.json file and convert as a readonly powershell object
$JSON = @(); # Designate a powershell object that is writable
$JSON += $loadFile; # Add the loaded file into this powershell object
$new = "" | Select version, del, add; # Create a new powershell object with these values
$i = $JSON.Count - 1; # Find the last element in the array
Write-Host "The current version is"$JSON[$i].version; # Print out the last version found
$new.version = Read-Host "Please enter new version"; # User enters the new version
[string[]]$arrayFromFile = Get-Content -Path '.\diff.txt'; # Grab the diff file and convert into a string array. If you just grab it, it will convert into a PS object but that's not necessary
$listDel = @(); # Creates an array for deleted files
$listAdd = @(); # Creates an array for added files
ForEach($path in $arrayFromFile)
{
	If($path.substring(0,1) -eq "D")
	{
		$listDel += @($path.substring(2));
	}
	ElseIf($path.substring(0,1) -eq "A" -or $path.substring(0,1) -eq "M")
	{
		$listAdd += @($path.substring(2));
	}
}
$new.del = $listDel; # Add it into the new entry's del field
$new.add = $listAdd; # Add it into the new entry's add field
$JSON += $new; # Add the new entry to the end
$JSON | ConvertTo-Json | Out-File version.json; # Export the PS Object as a JSON file