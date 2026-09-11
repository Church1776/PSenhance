<### Translate 'rmdir' alias into a function.
now an alias can point to 'rmdir' and be implicitly understood to be used for directories.
example: rd -> rmdir
#>
Get-Alias | ForEach-Object {Remove-Alias -Name $_.Name -Force -ErrorAction SilentlyContinue}

function rmdir {
	<#
	.FORWARDHELPTARGETNAME Remove-Item
	.FORWARDHELPCATEGORY Cmdlet
	#>
	
	[CmdletBinding(DefaultParameterSetName='pathSet',
		SupportsShouldProcess=$true,
		SupportsTransactions=$true,
		ConfirmImpact='Medium')]
		[OutputType([System.IO.DirectoryInfo])]
	param(
		[Parameter(ParameterSetName='pathSet', Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[ValidateScript({foreach ($item in $_) {
				if (-not (Test-Path -LiteralPath $item -PathType Container)) {
					throw "'$item' must be an existing directory."
				}
			}
			$true
		})]
		[System.String[]]
		${Path},
	
		[Switch]
		${Force},

		[Switch]
		${Recurse},
	
		[Parameter(ValueFromPipelineByPropertyName=$true)]
		[System.Management.Automation.PSCredential]
		${Credential}
	)
	
	begin {
		$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Remove-Item', [System.Management.Automation.CommandTypes]::Cmdlet)
		$scriptCmd = {& $wrappedCmd @PSBoundParameters }
	
		$steppablePipeline = $scriptCmd.GetSteppablePipeline()
		$steppablePipeline.Begin($PSCmdlet)
	}
	
	process {
		$steppablePipeline.Process($_)
	}
	
	end {
		$steppablePipeline.End()
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

$RevisedAliases = [ordered]@{
	'?'		= "Where-Object"
	'%'		= "ForEach-Object"
	ac		= "Add-Content"
	clc		= "Clear-Content"
	clear 	= "Clear-Host"
	clhy 	= "Clear-History"
	cli		= "Clear-Item"
	clp		= "Clear-ItemProperty"
	clh		= "Clear-Host"
	clv		= "Clear-Variable"
	cnsn 	= "Connect-PSSession"
	cmp		= "Compare-Object"
	compare = "Compare-Object"
	cpi		= "Copy-Item"
	cpp		= "Copy-ItemProperty"
	convert	= "Convert-Path"
	cvpa 	= "Convert-Path"
	dbp		= "Disable-PSBreakpoint"
	dnsn 	= "Disconnect-PSSession"
	ebp		= "Enable-PSBreakpoint"
	edosi	= "Expand-OsImage"
	edwini	= "Expand-WindowsImage"
	xwini	= "Export-WindowsImage"
	epal 	= "Export-Alias"
	epcert	= "Export-Certificate"
	epcsv 	= "Export-Csv"
	eposi	= "Export-OsImage"
	ethp 	= "Enter-PSHostProcess"
	etsn 	= "Enter-PSSession"
	etvsdev	= "Enter-VsDevShell"
	exhp	= "Exit-PSHostProcess"
	exsn 	= "Exit-PSSession"
	fc		= "Format-Custom"
	feo		= "ForEach-Object"
	fhx		= "Format-Hex"
	fl		= "Format-List"
	foreach = "ForEach-Object"
	ft		= "Format-Table"
	fw		= "Format-Wide"
	gal		= "Get-Alias"
	gbp		= "Get-PSBreakpoint"
	gc		= "Get-Content"
	gcb		= "Get-Clipboard"
	gci		= "Get-ChildItem"
	gcimc	= "Get-CimClass"
	gcimi	= "Get-CimInstance"
	gcima	= "Get-CimAssociatedInstance"
	gcimsn	= "Get-CimSession"
	gcm		= "Get-Command"
	gcs		= "Get-PSCallStack"
	gdr		= "Get-PSDrive"
	gerr 	= "Get-Error"
	ghy		= "Get-History"
	gi		= "Get-Item"
	gin		= "Get-ComputerInfo"
	gjb		= "Get-Job"
	gl		= "Get-Location"
	gm		= "Get-Member"
	gmo		= "Get-Module"
	gp		= "Get-ItemProperty"
	gps		= "Get-Process"
	gpv		= "Get-ItemPropertyValue"
	grp		= "Group-Object"
	group 	= "Group-Object"
	gsn		= "Get-PSSession"
	gsv		= "Get-Service"
	gtz		= "Get-TimeZone"
	gu		= "Get-Unique"
	gv		= "Get-Variable"
	gwmi	= "Get-WmiObject"
	hy		= "Get-History"
	history = "Get-History"
	icim	= "Invoke-CimMethod"
	icm		= "Invoke-Command"
	iex		= "Invoke-Expression"
	ihy		= "Invoke-History"
	ii		= "Invoke-Item"
	ipal 	= "Import-Alias"
	ipcsv 	= "Import-Csv"
	ipmo 	= "Import-Module"
	irm		= "Invoke-RestMethod"
	iwr		= "Invoke-WebRequest"
	join	= "Join-Path"
	jpa		= "Join-Path"
	msr		= "Measure-Object"
	measure	= "Measure-Object"
	mi		= "Move-Item"
	mp		= "Move-ItemProperty"
	nal		= "New-Alias"
	ncimi	= "New-CimInstance"
	ncimsn	= "New-CimSession"
	nd		= "mkdir"
	ndr		= "New-PSDrive"
	ni		= "New-Item"
	nmo		= "New-Module"
	nsn		= "New-PSSession"
	nv		= "New-Variable"
	ogv		= "Out-GridView"
	oh		= "Out-Host"
	out		= "Out-Default"
	popl 	= "Pop-Location"
	psedit 	= "Open-EditorFile"
	pushl 	= "Push-Location"
	rbp		= "Remove-PSBreakpoint"
	rcimi	= "Remove-CimInstance"
	rcimsn	= "Remove-CimSession"
	rcjb 	= "Receive-Job"
	rcsn 	= "Receive-PSSession"
	rd		= "Remove-Item"
	rdr		= "Remove-PSDrive"
	rgcim	= "Register-CimIndicationEvent"
	rgwmi	= "Register-WmiEvent"
	ri		= "Remove-Item"
	rjb		= "Remove-Job"
	rmo		= "Remove-Module"
	rni		= "Rename-Item"
	rnp		= "Rename-ItemProperty"
	rp		= "Remove-ItemProperty"
	rsn		= "Remove-PSSession"
	rv		= "Remove-Variable"
	resolve	= "Resolve-Path"
	rvpa 	= "Resolve-Path"
	rwmi	= "Remove-WmiObject"
	sajb 	= "Start-Job"
	sal		= "Set-Alias"
	saps 	= "Start-Process"
	sasv 	= "Start-Service"
	sasl	= "Start-Sleep"
	sbp		= "Set-PSBreakpoint"
	scb		= "Set-Clipboard"
	scim  = "Set-CimInstance"
	scimi	= "Set-CimInstance"
	sel		= "Select-Object"
	select 	= "Select-Object"
	shcm 	= "Show-Command"
	si		= "Set-Item"
	sl		= "Set-Location"
	sleep 	= "Start-Sleep"
	sls		= "Select-String"
	slx		= "Select-Xml"
	sort 	= "Sort-Object"
	sp		= "Set-ItemProperty"
	spjb 	= "Stop-Job"
	split	= "Split-Path"
	splpa	= "Split-Path"
	spliso	= "Split-WindowsImage"
	spps 	= "Stop-Process"
	spsv 	= "Stop-Service"
	start 	= "Start-Process"
	stop	= "Stop-Process"
	stz		= "Set-TimeZone"
	sv		= "Set-Variable"
	swmi	= "Set-WmiInstance"
	tee		= "Tee-Object"
	test	= "Test-Path"
	tpa		= "Test-Path"
	wait	= "Wait-Job"
	where 	= "Where-Object"
	whr		= "Where-Object"
	wjb		= "Wait-Job"
	write 	= "Write-Output"
}

ForEach ($entry in $RevisedAliases.GetEnumerator()) {
	$aliasName = $entry.Key
	$cmdName = $entry.Value
	if ($null -eq $cmdName) {
		continue
	}
	if (-not (Get-Alias -Name $aliasName -ErrorAction SilentlyContinue)) {
		Set-Alias -Name $aliasName -Value $cmdName -Force -Scope Global -ErrorAction SilentlyContinue
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