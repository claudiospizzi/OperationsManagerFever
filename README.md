[![AppVeyor - master](https://ci.appveyor.com/api/projects/status/rq09t4u0349upk9e/branch/master?svg=true)](https://ci.appveyor.com/project/claudiospizzi/operationsmanagerfever/branch/master)
[![AppVeyor - dev](https://ci.appveyor.com/api/projects/status/rq09t4u0349upk9e/branch/dev?svg=true)](https://ci.appveyor.com/project/claudiospizzi/operationsmanagerfever/branch/dev)
[![PowerShell Gallery - OperationsManagerFever](https://img.shields.io/badge/PowerShell%20Gallery-OperationsManagerFever-0072C6.svg)](https://www.powershellgallery.com/packages/OperationsManagerFever)


# OperationsManagerFever PowerShell Module

PowerShell Module with additional custom functions and cmdlets for System Center
Operations Manager.


## Introduction

This is a personal PowerShell Module by Claudio Spizzi. I use it to maintain
System Center Operations Manager, e.g. exporting MP bundles and get performance
counters or reset SCOM agent health states by PowerShell.


## Requirenments

The following minimum tested requirenments are necessary to use this module:

- Windows PowerShell 3.0
- Windows Server 2008 R2 / Windows 7
- System Center Operations Manager 2012 R2
- OperationsManager PowerShell Module (part of the SCOM Operations Console)


## Installation

### PowerShell Gallery

Install this module automatically from the [PowerShell Gallery](https://www.powershellgallery.com/packages/OperationsManagerFever)
to your local system with PowerShell 5.0:

```powershell
Install-Module OperationsManagerFever
```

### GitHub Release

To install the module manually, perform the following steps:

1. Download the latest release from [GitHub](https://github.com/claudiospizzi/OperationsManagerFever/releases)
   as a ZIP file
2. Extract the downloaded module into one of your module paths ([TechNet: Installing Modules](https://technet.microsoft.com/en-us/library/dd878350))


## Cmdlets

The module contains the following cmdlets:

| Cmdlet                              | Description                                                     |
| ----------------------------------- | --------------------------------------------------------------- |
| Export-SCOMManagementPackBundle     | Export all artifacts from a SCOM Management Pack Bundle (.mpb). |
| Get-SCOMHealthServiceActiveWorkflow | Show all active workflows on a Health Service (aka SCOM Agent). |
| Get-SCOMHealthServiceFailedWorkflow | Show all failed workflows on a Health Service (aka SCOM Agent). |


## Versions

### tbd

- Initial public release
- Management Pack Bundle extraction function
- Health Service workflow listing function


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open the OperationsManagerFever solution
with Visual Studio 2015. The module can be tested with the 'Scripts\test.ps1'
script.
