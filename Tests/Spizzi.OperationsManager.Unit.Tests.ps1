
$ModuleName  = ($PSScriptRoot | Split-Path | Split-Path -Leaf)
$ProjectRoot = ($PSScriptRoot | Split-Path)

Remove-Module -Name $ModuleName -ErrorAction SilentlyContinue -Force
Import-Module "$ProjectRoot\$ModuleName" -ErrorAction Stop -Force
