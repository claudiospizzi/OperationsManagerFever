
# Get and dot source all helper functions (private)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Modules\OperationsManagerFever\Helpers' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Modules\OperationsManagerFever\Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Update format data
Update-FormatData "$PSScriptRoot\..\Modules\OperationsManagerFever\Resources\OperationsManagerFever.Formats.ps1xml"

# Update type data
Update-TypeData "$PSScriptRoot\..\Modules\OperationsManagerFever\Resources\OperationsManagerFever.Types.ps1xml"

# Update assembly
Add-Type -Path "$PSScriptRoot\..\Modules\OperationsManagerFever\OperationsManagerFever.dll"

# Execute deubg
# ToDo...
