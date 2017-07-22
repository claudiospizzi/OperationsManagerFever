<# ----------------- DEBUGGING ONLY -- REMOVED DURING BUILD ----------------- #>

# Get and dot source all helper functions (internal)
Split-Path -Path $PSCommandPath |
    Get-ChildItem -Filter 'Helpers' -Directory |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSCommandPath |
    Get-ChildItem -Filter 'Functions' -Directory |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

<# -------------------------------------------------------------------------- #>

# Import core SCOM assemblies
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.EnterpriseManagement.Core') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.EnterpriseManagement.Runtime') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.EnterpriseManagement.Packaging') | Out-Null
