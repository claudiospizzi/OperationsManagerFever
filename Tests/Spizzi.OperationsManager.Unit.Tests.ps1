
$ModuleName  = ($PSScriptRoot | Split-Path | Split-Path -Leaf)
$ProjectRoot = ($PSScriptRoot | Split-Path)

Remove-Module -Name $ModuleName -Verbose:$false -ErrorAction SilentlyContinue -Force
Import-Module "$ProjectRoot\$ModuleName" -Verbose:$false -ErrorAction Stop -Force
