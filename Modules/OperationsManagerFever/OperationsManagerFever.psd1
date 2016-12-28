@{
    RootModule         = 'OperationsManagerFever.psm1'
    ModuleVersion      = '1.1.0'
    GUID               = '73EA7A8D-F3F2-42D8-8173-BB7DCDC49FA2'
    Author             = 'Claudio Spizzi'
    Copyright          = 'Copyright (c) 2016 by Claudio Spizzi. Licensed under MIT license.'
    Description        = 'PowerShell Module with additional custom functions and cmdlets for System Center Operations Manager.'
    PowerShellVersion  = '3.0'
    RequiredModules    = @(
        'OperationsManager'
    )
    RequiredAssemblies = @()
    ScriptsToProcess   = @()
    TypesToProcess     = @(
        'Resources\OperationsManagerFever.Types.ps1xml'
    )
    FormatsToProcess   = @(
        'Resources\OperationsManagerFever.Formats.ps1xml'
    )
    FunctionsToExport  = @(
        'Export-SCOMManagementPackBundle'
        'Get-SCOMHealthServiceActiveWorkflow'
        'Get-SCOMHealthServiceFailedWorkflow'
        'Reset-SCOMAgentCache'
        'Reset-SCOMAgentConfig'
        'Reset-SCOMMonitor'
        'Get-SCOMAgentManagementGroup'
        'Remove-SCOMAgentManagementGroup'
    )
    CmdletsToExport    = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData             = @{
            Tags               = @('PSModule', 'System', 'Center', 'Operations', 'Manager', 'SCOM', 'OpsMgr')
            LicenseUri         = 'https://raw.githubusercontent.com/claudiospizzi/OperationsManagerFever/master/LICENSE'
            ProjectUri         = 'https://github.com/claudiospizzi/OperationsManagerFever'
            ExternalModuleDependencies = @(
                'OperationsManager'
            )
        }
    }
}
