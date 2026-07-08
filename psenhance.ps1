

Remove-Alias -Name where -Force

Set-Alias -Name wo -Value Where-Object -Force
Set-Alias -Name tp -Value Test-Path -Force
$Programs = "${env:ProgramFiles}"
$LocalUserPrograms = "${env:LOCALAPPDATA}\Programs"

$LLVM_Path = "$Programs\LLVM\bin"
$LLVM_Local_Path = "$LocalUserPrograms\LLVM\bin"

$CMake_Path = "$Programs\CMake\bin"
$CMake_Local_Path = "$LocalUserPrograms\CMake\bin"

$Git_Path = "$Programs\Git\cmd"
$Git_Local_Path = "$LocalUserPrograms\Git\cmd"

$Ninja_Path = "$Programs\Ninja"
$Ninja_Local_Path = "$LocalUserPrograms\Ninja"

$vcpkg_Path = "$Programs\vcpkg"
$vcpkg_Local_Path = "$LocalUserPrograms\vcpkg"

if (-not ($env:Path -split ';' | Where-Object { $_ -eq "$LLVM_Path" })) {
    if (Test-Path "$LLVM_Path") {
        Write-Host "Adding LLVM directory to PATH..."
        $env:Path += ";$LLVM_Path"
    } elseif (Test-Path "$LLVM_Local_Path") {
        $LLVM_Path = "$LLVM_Local_Path"
        Write-Host "Adding LLVM local directory to PATH..."
        $env:Path += ";$LLVM_Path"
    } else {
        Write-Host "LLVM directory not found."
    }
}
if (-not ($env:Path -split ';' | Where-Object { $_ -eq "$CMake_Path" })) {
    if (Test-Path "$CMake_Path") {
        Write-Host "Adding CMake directory to PATH..."
        $env:Path += ";$CMake_Path"
    } elseif (Test-Path "$CMake_Local_Path") {
        $CMake_Path = "$CMake_Local_Path"
        Write-Host "Adding CMake local directory to PATH..."
        $env:Path += ";$CMake_Path"
    } else {
        Write-Host "CMake directory not found."
    }
}
if (-not ($env:Path -split ';' | Where-Object { $_ -eq "$Git_Path" })) {
    if (Test-Path "$Git_Path") {
        Write-Host "Adding Git directory to PATH..."
        $env:Path += ";$Git_Path"
    } elseif (Test-Path "$Git_Local_Path") {
        $Git_Path = "$Git_Local_Path"
        Write-Host "Adding Git local directory to PATH..."
        $env:Path += ";$Git_Path"
    } else {
        Write-Host "Git directory not found."
    }
}
if (-not ($env:Path -split ';' | Where-Object { $_ -eq "$Ninja_Path" })) {
    if (Test-Path "$Ninja_Path") {
        Write-Host "Adding Ninja directory to PATH..."
        $env:Path += ";$Ninja_Path"
    } elseif (Test-Path "$Ninja_Local_Path") {
        $Ninja_Path = "$Ninja_Local_Path"
        Write-Host "Adding Ninja local directory to PATH..."
        $env:Path += ";$Ninja_Path"
    } else {
        Write-Host "Ninja directory not found."
    }
}

if (-not ($env:Path -split ';' | Where-Object { $_ -eq "$vcpkg_Path" })) {
    if (Test-Path "$vcpkg_Path") {
        Write-Host "Adding vcpkg directory to PATH..."
        $env:Path += ";$vcpkg_Path"
    } elseif (Test-Path "$vcpkg_Local_Path") {
        $vcpkg_Path = "$vcpkg_Local_Path"
        Write-Host "Adding vcpkg local directory to PATH..."
        $env:Path += ";$vcpkg_Path"
    } else {
        Write-Host "vcpkg directory not found."
    }
}



$ink = @{
  black           = "`e[30m"
  red             = "`e[31m"
  green           = "`e[32m"
  yellow          = "`e[33m"
  blue            = "`e[34m"
  magenta         = "`e[35m"
  cyan            = "`e[36m"
  white           = "`e[37m"
  brightblack     = "`e[90m"
  brightred       = "`e[91m"
  brightgreen     = "`e[92m"
  brightyellow    = "`e[93m"
  brightblue      = "`e[94m"
  brightmagenta   = "`e[95m"
  brightcyan      = "`e[96m"
  brightwhite     = "`e[97m"
  gray            = "`e[38;5;244m"
  coral           = "`e[38;5;203m"
  forest          = "`e[38;5;34m"
  gold            = "`e[38;5;220m"
  cerulean        = "`e[38;5;39m"
  periwinkle      = "`e[38;5;141m"
  lightgray       = "`e[38;5;250m"
  darkgray        = "`e[38;5;240m"
  orange          = "`e[38;5;208m"
  purple          = "`e[38;5;135m"
  lightorange     = "`e[38;5;228m"
  pink            = "`e[38;5;205m"
  brown           = "`e[38;5;94m"
  brightgold      = "`e[38;5;227m"
  brightergold    = "`e[38;5;228m"
  cyanblue        = "`e[38;5;38m"
  teal            = "`e[38;5;30m"
  tealblue        = "`e[38;5;37m"
  turquoise       = "`e[38;5;35m"
  mint            = "`e[38;5;121m"
  olive           = "`e[38;5;142m"
  navy            = "`e[38;5;17m"
  maroon          = "`e[38;5;124m"
  lavender        = "`e[38;5;225m"
  beige           = "`e[38;5;230m"
  salmon          = "`e[38;5;209m"
  skyblue         = "`e[38;5;117m"
  rose            = "`e[38;5;213m"
  peach           = "`e[38;5;216m"
  burgundy        = "`e[38;5;131m"
  amber           = "`e[38;5;214m"
  sepia           = "`e[38;5;130m"
  slateblue       = "`e[38;5;62m"
  olivegreen      = "`e[38;5;100m"
  rosepink        = "`e[38;5;218m"
  brightrosepink  = "`e[38;5;219m"
  skybluebright   = "`e[38;5;123m"
  brighterskyblue = "`e[38;5;159m"
  reset           = "`e[0m"
}

function shcolors {
  if (-not $ink) {
    Write-Host ":[info]: No colors found."
    return
  }
  Write-Host "Colors loaded:"
  foreach ($color in $ink.Keys) {
    Write-Host "$($ink['gray']): $($ink[$color])$color$($ink['reset'])"
  }
}

$script_location = $($MyInvocation.MyCommand.Path)
$script_location = $script_location.Replace("$env:USERPROFILE", '~')

Write-Host "Loaded PowerShell profile Script: $script_location"
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