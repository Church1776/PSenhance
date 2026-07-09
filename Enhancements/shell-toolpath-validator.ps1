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