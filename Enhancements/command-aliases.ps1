Remove-Alias -Name where -Force

Set-Alias -Name nd -Value mkdir -Force
Set-Alias -Name rd -Value rmdir -Force
Set-Alias -Name wo -Value Where-Object -Force
Set-Alias -Name tpa -Value Test-Path -Force
Set-Alias -Name split -Value Split-Path -Force

$llvm_aliases = @{
  llar = "llvm-ar.exe"
  llcov = "llvm-cov.exe"
  llcxxfilt = "llvm-cxxfilt.exe"
  lldlltool = "llvm-dlltool.exe"
  lldwp = "llvm-dwp.exe"
  llib = "llvm-lib.exe"
  llmca = "llvm-mca.exe"
  llml = "llvm-ml.exe"
  llml64 = "llvm-ml64.exe"
  llmt = "llvm-mt.exe"
  llnm = "llvm-nm.exe"
  llobjcopy = "llvm-objcopy.exe"
  llobjdump = "llvm-objdump.exe"
  llpdbutil = "llvm-pdbutil.exe"
  llprofdata = "llvm-profdata.exe"
  llprofgen = "llvm-profgen.exe"
  llranlib = "llvm-ranlib.exe"
  llrc = "llvm-rc.exe"
  llreadobj = "llvm-readobj.exe"
  llsize = "llvm-size.exe"
  llstrings = "llvm-strings.exe"
  llstrip = "llvm-strip.exe"
  llsymbolizer   = "llvm-symbolizer.exe"
}
$clang_aliases = @{
  clcpp = "clang-cpp"
  cldoc = "clang-doc"
  cltidy = "clang-tidy"
  clformat = "clang-format"
  clcheck = "clang-check"
  clmove = "clang-move"
  clquery = "clang-query"
  clapply = "clang-apply-replacements"
}
$mlir_aliases = @{
  mlopt = "mlir-opt"
  mlpdll = "mlir-pdll"
  mlirlsp = "mlir-lsp-server"
  mlquery = "mlir-query"
  mlreduce = "mlir-reduce"
  mlrewrite = "mlir-rewrite"
  mlrunner = "mlir-runner"
  mltblgen = "mlir-tblgen"
  mltranslate = "mlir-translate"
}
$spirv_aliases = @{
  spvas = "spirv-as"
  spvcfg = "spirv-cfg"
  spvdiff = "spirv-diff"
  spvdis = "spirv-dis"
  spvlesspipe = "spirv-lesspipe"
  spvlink = "spirv-link"
  spvlint = "spirv-lint"
  spvobjdump = "spirv-objdump"
  spvopt = "spirv-opt"
  spvval = "spirv-val"
}


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