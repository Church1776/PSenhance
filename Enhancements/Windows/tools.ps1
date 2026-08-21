
$Tools ??= [ordered]@{
	"7-Zip" = ""
	"CMake" = "bin"
	"Git" = "cmd"
	"LLVM" = "bin"
	"Lua" = "bin"
	"Ninja" = ""
	"PreMake" = "bin"
	"VCPkg" = "bin"
}
$Paths ??= @(
	"$env:ProgramFiles",
	"${env:ProgramFiles(X86)}",
	"$env:AppData",
	"$env:LocalAppData\Programs"
)

$ToolPaths += $(Get-PSDrive -PSProvider FileSystem).Name | ForEach-Object { "${_}:\Tools" }
$Paths += $ToolPaths

function Evaluate-ToolPath {
	param(
		[Parameter(Mandatory = $true)]
		[string]$FilePath,
		[Parameter(Mandatory = $true)]
		[string]$FolderPath
	)
	if (-not (Test-Path -Path $(Resolve-Path $(Join-Path "$FilePath" "$FolderPath") -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue)) {
		if (-not (Test-Path -Path $(Resolve-Path $(Join-Path "$FilePath" * "$FolderPath") -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue)) {
			if (-not (Test-Path -Path $(Resolve-Path $(Join-Path "$FilePath" * * "$FolderPath") -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue)) {
				if (-not (Test-Path -Path $(Resolve-Path $(Join-Path "$FilePath" * * * "$FolderPath") -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue)) {
					return $null
				} else {
					$FilePath = $(Resolve-Path $(Join-Path "$FilePath" * * * "$FolderPath")).Path
				}
			} else {
				$FilePath = $(Resolve-Path $(Join-Path "$FilePath" * * "$FolderPath")).Path
			}
		} else {
			$FilePath = $(Resolve-Path $(Join-Path "$FilePath" * "$FolderPath")).Path
		}
	} else {
		$FilePath = $(Join-Path "$FilePath" "$FolderPath")
	}
	return $FilePath
}
foreach ($tool in $Tools.Keys) {
	foreach ($path in $Paths) {
		$toolPath = $(Resolve-Path $(Join-Path "$path" "$tool") -ErrorAction SilentlyContinue).Path
		if ( -not (Test-Path -Path "$toolPath" -ErrorAction SilentlyContinue)) {
			continue
		}
		$subFolder = $Tools[$tool]
		if (-not ($null -eq $subFolder -or $subFolder -eq "")) {
			$toolPath = $(Evaluate-ToolPath -FilePath $toolPath -FolderPath $subFolder)
		} elseif (-not (Test-Path -Path $(Join-Path "$toolPath" "*.exe") -ErrorAction SilentlyContinue)) {
			$toolPath = $(Evaluate-ToolPath -FilePath $toolPath -FolderPath "bin")
			if (-not (Test-Path -Path $(Join-Path "$toolPath" "*.exe") -ErrorAction SilentlyContinue)) {
				$toolPath = $null
			}
		} else {
			$toolPath = $(Resolve-Path "$toolPath").Path
		}
		if ($null -eq $toolPath -or $toolPath -eq "") {
			continue
		}
		if (-not ($env:PATH -split ';' | Where-Object { $_ -eq "$toolPath" }) -and (Test-Path "$toolPath")) {
			$env:PATH = "$toolPath;$env:PATH"
			Write-Host "Adding Tool: $($toolPath.Replace($env:USERPROFILE, '~'))"
		}
	}
}