Remove-Alias -Name where -Force

Set-Alias -Name nd -Value mkdir -Force
Set-Alias -Name rd -Value rmdir -Force
Set-Alias -Name wo -Value Where-Object -Force
Set-Alias -Name tpa -Value Test-Path -Force
Set-Alias -Name split -Value Split-Path -Force

function which {
	foreach ($arg in $args) {
		$err = $null
		Get-Command -Syntax $arg -ErrorAction SilentlyContinue -ErrorVariable err | ForEach-Object { $_ -replace '\\{2,}', '\' -replace '//{2,}', '/' }
		if ($err -ne $null) {
			Write-Error $err.Exception.Message
		}
	}
}
function where {
	foreach ($arg in $args) {
		$err = $null
		Get-Command -Syntax -All $arg -ErrorAction SilentlyContinue -ErrorVariable err | ForEach-Object { $_ -replace '\\{2,}', '\' -replace '//{2,}', '/' }
		if ($err -ne $null) {
			Write-Error $err.Exception.Message
		}
	}
}
$llvmCmds = @($(Get-Command llvm-*).Name)
$clangCmds = @($(Get-Command clang-*).Name)
$mlirCmds = @($(Get-Command mlir-*).Name)
$spirvCmds = @($(Get-Command spirv-*).Name)

$llvmHashTable = @{}
$clangHashTable = @{}
$mlirHashTable = @{}
$spirvHashTable = @{}
$PSEnhanceHashTable = @{}

ForEach ($cmd in $llvmCmds) {
	$alias = $($cmd -replace '^llvm-', 'll')
	$alias = $($alias -replace '^lll', 'll')
	$alias = $($alias -replace '.exe', '')
	$llvmHashTable[$alias] = $cmd
	$PSEnhanceHashTable[$alias] = $cmd
}
ForEach ($cmd in $clangCmds) {
	$alias = $($cmd -replace '^clang-', 'cl')
	$alias = $($alias -replace '^cll', 'cl')
	$alias = $($alias -replace '^clcl', 'cl')
	$alias = $($alias -replace '.exe', '')
	$clangHashTable[$alias] = $cmd
	$PSEnhanceHashTable[$alias] = $cmd
}
ForEach ($cmd in $mlirCmds) {
	$alias = $($cmd -replace '^mlir-', 'ml')
	$alias = $($alias -replace '^mll', 'ml')
	$alias = $($alias -replace '.exe', '')
	$mlirHashTable[$alias] = $cmd
	$PSEnhanceHashTable[$alias] = $cmd
}
ForEach ($cmd in $spirvCmds) {
	$alias = $($cmd -replace '^spirv-', 'spv')
	$alias = $($alias -replace '^spvv', 'spv')
	$alias = $($alias -replace '.exe', '')
	$spirvHashTable[$alias] = $cmd
	$PSEnhanceHashTable[$alias] = $cmd
}

function add_utility_aliases {
	param ([hashtable]$table = $null)
	if ($null -eq $table) { return }

	foreach ($entry in $table.GetEnumerator()) {
		$aliasName = $entry.Key
		$cmdName = $entry.Value
		if ($null -eq $cmdName) {
			continue
		}
		$cmdFullName = Get-Command -Name $cmdName -ErrorAction SilentlyContinue
		if ($null -eq $cmdFullName) {
			continue
		}
		if (-not (Get-Alias -Name $aliasName -ErrorAction SilentlyContinue)) {
			Set-Alias -Name $aliasName -Value $cmdFullName.Source -Force -Scope Global
		}
	}
}

add_utility_aliases $llvmHashTable
add_utility_aliases $clangHashTable
add_utility_aliases $mlirHashTable
add_utility_aliases $spirvHashTable