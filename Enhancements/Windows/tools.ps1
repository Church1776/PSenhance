if (-not ($Programs -or $LocalUserPrograms)) {
    . "$PSScriptRoot\environment\paths.ps1"
}

$LLVM = "$Programs\LLVM"
$LLVM_Local = "$LocalUserPrograms\LLVM"
$CMake = "$Programs\CMake"
$CMake_Local = "$LocalUserPrograms\CMake"
$Git = "$Programs\Git"
$Git_Local = "$LocalUserPrograms\Git"
$Ninja = "$Programs\Ninja"
$Ninja_Local = "$LocalUserPrograms\Ninja"
$vcpkg = "$Programs\vcpkg"
$vcpkg_Local = "$LocalUserPrograms\vcpkg"

$Paths = @(
    "$LLVM\bin",
    "$LLVM_Local\bin",
    "$CMake\bin",
    "$CMake_Local\bin", 
    "$Git\cmd",
    "$Git_Local\cmd",
    "$Ninja\bin",
    "$Ninja_Local\bin",
    "$vcpkg\bin",
    "$vcpkg_Local\bin"
)

foreach ($path in $Paths) {
    if (-not ($env:PATH -split ';' | Where-Object { $_ -eq "$path" }) -and (Test-Path "$path")) {
        $env:PATH += ";$path"
        Write-Host "Adding Tool: $($path.Replace($env:USERPROFILE, '~'))"
    }
}