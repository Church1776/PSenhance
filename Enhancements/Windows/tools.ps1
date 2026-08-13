
$Tools ??= @(
	"CMake",
	"Git",
	"LLVM",
	"Lua",
	"Ninja",
	"PreMake",
	"VCPkg"
)
$Paths ??= @(
	"$env:ProgramFiles",
	"${env:ProgramFiles(X86)}",
	"$env:AppData",
	"$env:LocalAppData\Programs"
)

$ToolPaths += $(Get-PSDrive -PSProvider FileSystem).Name | ForEach-Object { "${_}:\Tools" }

$Paths += $ToolPaths

foreach ($tool in $Tools) {
	foreach ($path in $Paths) {
		$toolPath = Join-Path "$path" "$tool"
		if ( -not (Test-Path "$toolPath")) {
			continue
		}
		if (Test-Path $(Join-Path "$toolPath" "bin")) {
			$toolPath = $(Join-Path "$toolPath" "bin")
		}
		if (-not ($env:PATH -split ';' | Where-Object { $_ -eq "$toolPath" }) -and (Test-Path "$toolPath")) {
			$env:PATH = "$toolPath;$env:PATH"
			Write-Host "Adding Tool: $($toolPath.Replace($env:USERPROFILE, '~'))"
		}
	}
}