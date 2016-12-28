
# Import core SCOM assemblies
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.EnterpriseManagement.Core') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.EnterpriseManagement.Runtime') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.EnterpriseManagement.Packaging') | Out-Null

# Get and dot source all helper functions (private)
Split-Path -Path $PSCommandPath |
    Join-Path -ChildPath 'Helpers' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSCommandPath |
    Join-Path -ChildPath 'Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }
