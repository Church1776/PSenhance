
$UneededAliases = @(
	"cat"
	"cd"
	"cp"
	"echo"
	"kill"
	"ls"
	"mv"
	"ps"
	"pwd"
	"rm"
	"type"

	"chdir"
	"cls"
	"del"
	"diff"
	"dir"

	"copy"
	"cvpa"
	"erase"
	"h"
	"popd"
	"pushd"
	"r"
	"rvpa"
)

$RestructuredAliases = @{
	nd = "mkdir"
	rd = "rmdir"
	wh = "Write-Host"
	ral = "Remove-Alias"
	popl = "Pop-Location"
	pushl = "Push-Location"
	get = "Get-Process"
	out = "Out-Default"
	read = "Read-Host"
	convert = "Convert-Path"
	join = "Join-Path"
	resolve = "Resolve-Path"
	split = "Split-Path"
	stop = "Stop-Process"
	test = "Test-Path"
}

ForEach ($a in $UneededAliases) {
	Remove-Alias -Name $a  -Force
}

ForEach ($entry in $RestructuredAliases.GetEnumerator()) {
	$aliasName = $entry.Key
	$cmdName = $entry.Value
	if ($null -eq $cmdName) {
		continue
	}
	if (-not (Get-Alias -Name $aliasName -ErrorAction SilentlyContinue)) {
		Set-Alias -Name $aliasName -Value $cmdName -Force -Scope Global -ErrorAction SilentlyContinue
	}
}

function locate {
	$longUnixFormFlag = 0

	$helpMessage = 
	"Usage: locate [options] <command>
	Options:
	  --help    Display this help message"
	$versionMessage = 
	"Locate Utility - Version 0.1.0"
	foreach ($arg in $args) {
		if ( $arg -like "-*" -or $arg -like "/*") {
			$chars = $arg.ToCharArray()
			foreach ($c in $chars) {
				if ($c -eq '-') {
					if ($longUnixFormFlag -eq 2) {
						Write-Error "Unknown option passed."
						Write-Error "Usage: locate [options] <command>"
						return
					}
					$longUnixFormFlag = $longUnixFormFlag + 1
					continue
				}
				if ($longUnixFormFlag -eq 2) {
					break
				}
				switch ($c) {
					{ $c -eq 'h'} { "$helpMessage"; return }
					{ $c -eq 'v'} { "$versionMessage"; return }
					default      { break }
				}
			}
			switch ($arg.Substring(2)) {
				{ $_ -like "help"} { "$helpMessage"; return }
				{ $_ -like "version"} { "$versionMessage"; return }
				default      { break }
			}
		}

		$err = $null
		Get-Command -Syntax $arg -ErrorAction SilentlyContinue -ErrorVariable err
		| ForEach-Object { $_ -replace '\\{2,}', '\' -replace '//{2,}', '/' }
		if ($err -ne $null) {
			Write-Error $err.Exception.Message
		}
	}
}
function lookup {
	$longUnixFormFlag = 0
	$nonUnixFormFlag = 0

	$helpUnixStyleMessage = 
	"Usage: lookup [options] <command>
	Options:
	  -h, --help    	Display this help message
	  -v, --version 	Display the version information"
	$helpNonUnixStyleMessage = 
	"Usage: lookup [options] <command>
	Options:
	  /?, /h, /help 	Display this help message"
	$versionMessage = 
	"Lookup Utility - Version 0.1.0"
	foreach ($arg in $args) {
		if ( $arg -like "-*" -or $arg -like "/*") {
			$chars = $arg.ToCharArray()
			foreach ($c in $chars) {
				if ($c -eq '/' -and $FormFlag -eq 0) {
					if ($nonUnixFormFlag -eq 1) {
						Write-Error "Unknown option '$arg' passed."
						Write-Host "$helpNonUnixStyleMessage"
						return
					}
					$nonUnixFormFlag = 1
					continue
				} elseif ($c -eq '-' -and $longUnixFormFlag -eq 0) {
					if ($longUnixFormFlag -eq 2) {
						Write-Error "Unknown option '$arg' passed."
						Write-Host "$helpNonUnixStyleMessage"
						return
					}
					$longUnixFormFlag = $longUnixFormFlag + 1
					continue
				}
				if ($longUnixFormFlag -eq 2) {
					break
				}
				switch ($c) {
					{ $c -eq 'h'} { "$helpUnixStyleMessage"; return }
					{ $c -eq 'v'} { "$versionMessage"; return }
					default      { break }
				}
			}
			switch ($arg.Substring(2)) {
				{ $_ -like "help"} { "$helpUnixStyleMessage"; return }
				{ $_ -like "version"} { "$versionMessage"; return }
				default      { break }
			}
		}

		$err = $null
		Get-Command -Syntax -All $arg -ErrorAction SilentlyContinue -ErrorVariable err
		| ForEach-Object { $_ -replace '\\{2,}', '\' -replace '//{2,}', '/' }
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

return
add_utility_aliases $llvmHashTable
add_utility_aliases $clangHashTable
add_utility_aliases $mlirHashTable
add_utility_aliases $spirvHashTable