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
    if ($cmdName -eq $null) {
      continue
    }
    $cmdFullName = Get-Command -Name $cmdName -ErrorAction SilentlyContinue
    if ($cmdFullName -eq $null) {
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
# Functions to add aliases
#function add_utility_aliases {
#  local -A r_arr=(${(@Pkv)1})
#  for tool in ${(@k)r_arr}; do
#    local toolcmd="${r_arr[$tool]}"
#    (( $+commands[$toolcmd] )) || continue
#    local toolalias="$tool"
#    [[ "$toolalias" != "$toolcmd" ]] || continue
#    [[ -z "$(alias "$toolalias")" ]] || continue
#    if ! alias "$toolalias"="$toolcmd" 2>/dev/null; then
#      echo "Failed to create alias: $toolalias -> $toolcmd."
#    fi
#  done
#}

#function add_qualifier_aliases {
#  local -A r_arr=(${(@Pkv)1})
#  for tool in ${(@k)r_arr}; do
#    local toolcmd="${r_arr[$tool]}"
#    local toolalias="$tool"
#    [[ "$toolalias" != "$toolcmd" ]] || continue
#    [[ -z "$(alias "$toolalias")" ]] || continue
#    if ! alias "$toolalias"="$toolcmd" &>/dev/null; then
#      echo "Failed to create alias: $toolalias -> $toolcmd."
#    fi
#  done
#}

# Function to load aliases
#function load_shell_aliases {
#  add_utility_aliases llvm_aliases
#  add_utility_aliases clang_aliases
#  add_utility_aliases mlir_aliases
#  add_utility_aliases spirv_aliases
#  add_qualifier_aliases coreutil_aliases
#  add_qualifier_aliases builtin_aliases
#  add_qualifier_aliases custom_aliases
#}
#load_shell_aliases

# Cleanup all values to keep the shell environment clean
#unset -f add_utility_aliases
#unset -f add_qualifier_aliases
#unset -f load_shell_aliases

#unset llvm_aliases
#unset clang_aliases
#unset mlir_aliases
#unset spirv_aliases
#unset coreutil_aliases
#unset builtin_aliases
#unset custom_aliases