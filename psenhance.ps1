Write-Host "**********************************************************************
** PowerShell Enhance Module v0.1.0
** Owner: brassmajor@gmail.com
**********************************************************************"

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

$vcsRoot = ""
$vcsData = ""
$vcsBranch = ""
$vcsHashLength = ""
$vcsCmdRerun = ""
$cachedVCS = "git"
$cachedDirectory = ""

function Set-VCS {
	param (
		[Parameter(Mandatory = $true)]
		[string]$VCS
	)

	if (-not ($VCS -in @("git", "fossil", "svn"))) {
		Write-Host "Invalid VCS specified. Supported values are: git, fossil, svn."
	}
	$global:cachedVCS = $VCS
}

function prompt {
	if (($(Get-History -Count 1).CommandLine -match '(?m)(?:^|[;|&({])\s*git(?:\s|$)') -and ( -not ("$global:vcsRoot" -like ""))) {
		#write-host "Setting vcsCmdRerun..."
		$global:vcsCmdRerun = 1
	}
	if ($PWD -ne $cachedDirectory) {
		#write-host "Checking directory..."
		if ((("$PWD\" -like "$global:vcsRoot\*") -and $(Test-Path "$PWD\.git") -and ( -not ("$PWD\.git" -like "$global:vcsRoot\.git"))) -or ( -not ("$PWD\" -like "$global:vcsRoot\*"))) {
			#write-host "Looking for repository..."
			$global:vcsRoot = ""
			$global:vcsData = ""
			$global:vcsBranch = ""
			$global:vcsHashLength = ""
			$tempPWD = (Get-Item $PWD)
			while ($tempPWD) {
				if (-not (Test-Path "$($tempPWD.FullName)\.git")) {
					$tempPWD = $tempPWD.Parent
					continue
				}
				$global:vcsRoot = $tempPWD.FullName
				break
			}
		}
		if ($global:vcsData -eq "" -and $global:vcsRoot -ne "") {
			#write-host "Entering repository..."
			if (Test-Path -Type Leaf "$($global:vcsRoot)\.git") {
				#write-host "Locating repo metadata..."
				$global:vcsData = $(Get-Content "$($global:vcsRoot)\.git")
				$global:vcsData = $global:vcsData.Trim("gitdir: ")
			} else {
				#write-host "Caching metadata Location..."
				$global:vcsData = "$($global:vcsRoot)\.git"
			}
			$global:vcsHashLength = $((git rev-parse --short HEAD 2>$null).Length)
			if ($global:vcsCmdRerun -eq "") {
				$global:vcsCmdRerun = 1
			}
		}
	}
	if ("$global:vcsData" -ne "" -and "$global:vcsCmdRerun" -eq 1) {
		#write-host "Reading repo metadata..."
		$global:vcsCmdRerun = ""
		$global:vcsBranch = "$(Get-Content "$($global:vcsData)\HEAD")"
		if (-not ($global:vcsBranch -match 'ref: refs/heads/(.+)')) {
			#write-host "Finding detached HEAD..."
			$global:vcsBranch = "HEAD$($ink[$vcs_2nd])@$($ink[$vcs_3rd])$($global:vcsBranch.Substring(0, $global:vcsHashLength))$($ink[$vcs_main])"
		} else {
			#write-host "Resolving branch name..."
			$global:vcsBranch = $global:vcsBranch -replace 'ref: refs/heads/', ''
		}
		$global:vcsBranch = "$($ink[$vcs_main]):${global:vcsBranch}:$($ink.reset) "
	}

	$currentPath = "$($PWD.Path)" # Remove the drive letter and colon (e.g., "C:")

	if ("$currentPath" -eq "$($env:USERPROFILE)" -or $currentPath.StartsWith("$($env:USERPROFILE)")) {
		$currentPath = $currentPath.Replace("$($env:USERPROFILE)", '~')
	}

	if ("$currentPath" -cmatch "^[A-Za-z]:[/\\]") {
		$currentDrive = "$($ink[$drv_letter])$($currentPath.Substring(0,2))" # Highlight the drive a different color if it exists.
		$currentPath = "$($currentPath.Substring(2))" # Shift the path to remove the drive portion from the path.
	}
	$global:cachedDirectory = $PWD
	"$($ink[$name])$env:USERNAME$($ink[$AT])@$($ink[$machine])$env:COMPUTERNAME$($ink[$colon]):$($ink[$system_env])Windows$($ink[$colon]):$currentDrive$($ink[$win32_path])$currentPath$($ink[$win32_Z])>$($ink.reset) $vcsBranch"
}