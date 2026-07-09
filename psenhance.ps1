$enhancements = @(Get-ChildItem -Path "$(Split-Path -Parent $PROFILE)\Scripts\PSenhance\Enhancements" -Recurse -Name *".ps1")

foreach ($enhancement in $enhancements) {
    . "$(Split-Path -Parent $PROFILE)\Scripts\PSenhance\Enhancements\$enhancement"
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
            $gitBranch = "HEAD$($ink.lightgray)@$($ink.reset)$($gitBranch.Substring(0, $global:gitHashLength))$($ink.gray)"
        }
        if ($gitBranch) {
            $gitBranch = "$($ink.gray):${gitBranch}:$($ink.reset) "
        }
    }
    
    #########################  Keeping if I decide to fallback to the below method of getting the git branch name.  #########################
    #
    #if ( ($gitBranch = "$(git rev-parse --abbrev-ref HEAD 2>$null)")) {
    #    $gitBranch = "$($ink.gray):${gitBranch}:$($ink.reset) "
    #}
    #

    $currentPath = "$($PWD.Path.Substring(2))" # Remove the drive letter and colon (e.g., "C:")

    if ("$currentPath" -eq "$($env:USERPROFILE.Substring(2))" -or $currentPath.StartsWith("$($env:USERPROFILE.Substring(2))")) {
        $currentPath = $currentPath.Replace("$($env:USERPROFILE.Substring(2))", '~')
    }
    "$($ink.cerulean)$env:USERNAME$($ink.brightblue)@$($ink.skybluebright)$env:COMPUTERNAME$($ink.gray):$($ink.gold)Windows$($ink.gray):$($ink.periwinkle)PS$($ink.gray):$($ink.amber)$($PWD.Drive.Name)$($ink.amber):$($ink.coral)$currentPath$($ink.brightred)>$($ink.reset) $gitBranch"
}