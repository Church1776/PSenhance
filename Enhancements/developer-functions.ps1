function mkclass {
	param (
		[string]$className = "Unnamed",
		[string]$classLocation = "$($PWD.Path)",
		[string]$classNamespace = "",
		[string]$classLanguageType = "cpp",
		[string]$classType = "class"
	)
	
	$classDefinition = @{}
}