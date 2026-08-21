$name ??= 'orange'
$AT ??= 'amber'
$machine ??= 'vanilla'
$system_env ??= 'slateblue'
$PSvar ??= 'periwinkle'
$drv_letter ??= 'brightgreen'
$win32_path ??= 'turquoise'
$win32_Z ??= 'mint'
$vcs_main ??= 'gray'
$vcs_2nd ??= 'lightgray'
$vcs_3rd ??= 'reset'
$colon ??= 'gray'

$OS_Enhancements = $env:OS

if ($OS_Enhancements -eq "Windows_NT") {
	$OS_Enhancements = "$($OS_Enhancements.Substring(0,7))"
}

$enhancements = @(Get-ChildItem -Path "$PSScriptRoot\Enhancements\$OS_Enhancements" -File *".ps1")
$enhancements += @(Get-ChildItem -Path "$PSScriptRoot\Enhancements" -File *".ps1")

foreach ($enhancement in $enhancements) {
	. "$enhancement"
}

$script_location = $($MyInvocation.MyCommand.Path)
$script_location = $script_location.Replace("$env:USERPROFILE", '~')

Write-Host "Loaded PSenhancement Script: $script_location"
function prompt {
	if (-not $global:gitRepoRoot -or -not $PWD.Path.StartsWith($global:gitRepoRoot)) {
		$global:gitRepoRoot = ""
		if ($gitBranch -ne "") {
			$gitBranch = ""
		}
		if ($global:gitHashLength -ne 0) {
			$global:gitHashLength = 0
		}
		$tempPWD = $(Get-Location).Path
		while ($tempPWD) {
			if (Test-Path "$tempPWD\.git") {
				$global:gitRepoRoot = $tempPWD
				break
			}
			$tempPWD = (Get-Item $tempPWD).Parent.FullName
		}
	}
	if ("$global:gitRepoRoot" -ne "") {
		$gitBranch = "$(Get-Content "$($global:gitRepoRoot)\.git\HEAD")"
		if ($gitBranch -match 'ref: refs/heads/(.+)') {
			$gitBranch = $matches[1]
		} else {
			$gitBranch = "$(Get-Content "$($global:gitRepoRoot)\.git\HEAD")"
			if (-not $global:gitHashLength) {
				$gitShortHashId = "$(git rev-parse --short HEAD 2>$null)"
				$global:gitHashLength = $gitShortHashId.Length
			}
			$gitBranch = "HEAD$($ink[$vcs_2nd])@$($ink[$vcs_3rd])$($gitBranch.Substring(0, $global:gitHashLength))$($ink[$vcs_main])"
		}
		if ($gitBranch) {
			$gitBranch = "$($ink[$vcs_main]):${gitBranch}:$($ink.reset) "
		}
	}

	$currentPath = "$($PWD.Path)" # Remove the drive letter and colon (e.g., "C:")

	if ("$currentPath" -eq "$($env:USERPROFILE)" -or $currentPath.StartsWith("$($env:USERPROFILE)")) {
		$currentPath = $currentPath.Replace("$($env:USERPROFILE)", '~')
	}

	if ("$currentPath" -cmatch "^[A-Za-z]:[/\\]") {
		$currentDrive = "$($ink[$drv_letter])$($currentPath.Substring(0,2))" # Highlight the drive a different color if it exists.
		$currentPath = "$($currentPath.Substring(2))" # Shift the path to remove the drive portion from the path.
	}

	"$($ink[$name])$env:USERNAME$($ink[$AT])@$($ink[$machine])$env:COMPUTERNAME$($ink[$colon]):$($ink[$system_env])Windows$($ink[$colon]):$currentDrive$($ink[$win32_path])$currentPath$($ink[$win32_Z])>$($ink.reset) $gitBranch"
}