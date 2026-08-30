
$Tools ??= [ordered]@{
	"7-Zip" = "7z"
	"CMake" = "cmake"
	"Git" = "cmd/git"
	"LLVM" = "clang"
	"Lua" = "lua"
	"Ninja" = "ninja"
	"PreMake" = "premake"
	"Python" = "python"
	"VCPkg" = "vcpkg"
}
$Paths ??= @(
	"$env:ProgramFiles",
	"${env:ProgramFiles(X86)}",
	"$env:AppData",
	"$env:LocalAppData\Programs"
)

$ToolPaths += $(Get-PSDrive -PSProvider FileSystem).Name | ForEach-Object { "${_}:\Tools" }
$Paths += $ToolPaths

foreach ($tool in $Tools.Keys) {
	foreach ($path in $Paths) {
		if (($null -eq $path -or $path -eq "") -or ($null -eq $tool -or $tool -eq "")) {
			continue
		}
		if (-not (Test-Path -Path "$path" -ErrorAction SilentlyContinue)) {
			continue
		}

		$toolDirectory = "$(Get-ChildItem -Path "$path" -Filter "$tool" -Directory -Recurse -Depth 1 | Select-Object -First 1)"
		if (-not (Test-Path -Path "$toolDirectory" -ErrorAction SilentlyContinue)) {
			continue
		}

		$toolSubFolder = "$(Split-Path "$($Tools[$tool])" -Parent)"
		$toolExecutable = "$(Split-Path "$($Tools[$tool])" -Leaf).exe"
		
		if ( -not (("$null" -eq "$toolSubFolder") -or ("$toolSubFolder" -eq ""))) {
			$toolDirectory = "$(Get-ChildItem -Path "$toolDirectory" -Filter "$toolSubFolder" -Directory -Recurse | Select-Object -First 1)"
		}
		$toolExecutable = "$(Get-ChildItem -Path "$toolDirectory" -Filter "$toolExecutable" -File -Recurse | Select-Object -First 1)"
		
		if (-not (Test-Path -Path "$toolExecutable" -ErrorAction SilentlyContinue)) {
			continue
		}
		$toolPath = "$(Split-Path -Path "$($toolExecutable)" -Parent)"
		
		if (-not ($env:PATH -split ';' | Where-Object { $_ -eq "$toolPath" }) -and (Test-Path "$toolPath")) {
			$env:PATH = "$toolPath;$env:PATH"
			Write-Host "Adding ToolPath: $($toolPath.Replace($env:USERPROFILE, '~'))"
		}
	}
}