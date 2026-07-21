
$name ??= 'cerulean'
$AT ??= 'brightblue'
$machine ??= 'skybluebright'
$system_env ??= 'gold'
$PSvar ??= 'periwinkle'
$drv_letter ??= 'amber'
$win32_path ??= 'coral'
$win32_Z ??= 'brightred'
$vcs_main ??= 'gray'
$vcs_2nd ??= 'lightgray'
$vcs_3rd ??= 'reset'
$colon ??= 'gray'

$enhancements = @(Get-ChildItem -Path "$(Split-Path -Parent $PROFILE)\Scripts\PSenhance\Enhancements" -Recurse -Name *".ps1")

foreach ($enhancement in $enhancements) {
    . "$(Split-Path -Parent $PROFILE.CurrentUserAllHosts)\Scripts\PSenhance\Enhancements\$enhancement"
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
    
    #########################  Keeping if I decide to fallback to the below method of getting the git branch name.  #########################
    #
    #if ( ($gitBranch = "$(git rev-parse --abbrev-ref HEAD 2>$null)")) {
    #    $gitBranch = "$($ink.gray):${gitBranch}:$($ink.reset) "
    #}
    #
    $currentPath = "$($PWD.Path)" # Remove the drive letter and colon (e.g., "C:")

    if ("$currentPath" -eq "$($env:USERPROFILE)" -or $currentPath.StartsWith("$($env:USERPROFILE)")) {
        $currentPath = $currentPath.Replace("$($env:USERPROFILE)", '~')
    }

    if ("$currentPath" -cmatch "^[A-Za-z]:[/\\]") {
        $currentDrive = "$($ink[$drv_letter])$($currentPath.Substring(0,2))" # Highlight the drive a different color if it exists.
        $currentPath = "$($currentPath.Substring(2))" # Shift the path to remove the drive portion from the path.
    }

    "$($ink[$name])$env:USERNAME$($ink[$AT])@$($ink[$machine])$env:COMPUTERNAME$($ink[$colon]):$($ink[$system_env])Windows$($ink[$colon]):$currentDrive$($ink[$win32_path])$currentPath$($ink[$win32_Z])>$($ink.reset) $gitBranch"
    #"$($ink.cerulean)$env:USERNAME$($ink.brightblue)@$($ink.skybluebright)$env:COMPUTERNAME$($ink.gray):$($ink.gold)Windows$($ink.gray):$($ink.periwinkle)PS$($ink.gray):$($ink.amber)$($PWD.Drive.Name)$($ink.amber):$($ink.coral)$currentPath$($ink.brightred)>$($ink.reset) $gitBranch"
}