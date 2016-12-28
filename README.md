[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/OperationsManagerFever/master.svg)](https://ci.appveyor.com/project/claudiospizzi/OperationsManagerFever/branch/master)
[![AppVeyor - dev](https://img.shields.io/appveyor/ci/claudiospizzi/OperationsManagerFever/dev.svg)](https://ci.appveyor.com/project/claudiospizzi/OperationsManagerFever/branch/dev)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/OperationsManagerFever.svg)](https://github.com/claudiospizzi/OperationsManagerFever/releases)
[![PowerShell Gallery - OperationsManagerFever](https://img.shields.io/badge/PowerShell_Gallery-OperationsManagerFever-0072C6.svg)](https://www.powershellgallery.com/packages/OperationsManagerFever)


# OperationsManagerFever PowerShell Module

PowerShell Module with additional custom functions and cmdlets for System Center
Operations Manager.


## Introduction

This is a personal PowerShell Module by Claudio Spizzi. I use it to manage
System Center Operations Manager, e.g. exporting MP bundles and get performance
counters or reset SCOM agent health states by PowerShell.


## Requirements

The following minimum requirements are necessary to use this module:

* Windows PowerShell 3.0
* Windows Server 2008 R2 / Windows 7
- System Center Operations Manager 2012 R2 or later
- OperationsManager PowerShell Module (part of the SCOM Operations Console)


## Installation

With PowerShell 5.0, the new [PowerShell Gallery] was introduced. Additionally,
the new module [PowerShellGet] was added to the default WMF 5.0 installation.
With the cmdlet `Install-Module`, a published module from the PowerShell Gallery
can be downloaded and installed directly within the PowerShell host, optionally
with the scope definition:

```powershell
Install-Module OperationsManagerFever [-Scope {CurrentUser | AllUsers}]
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]


## Features

* **Export-SCOMManagementPackBundle**  
  Export all artifacts from a SCOM Management Pack Bundle (.mpb).

* **Get-SCOMHealthServiceActiveWorkflow**  
  Show all active workflows on a Health Service (aka SCOM Agent).

* **Get-SCOMHealthServiceFailedWorkflow**  
  Show all failed workflows on a Health Service (aka SCOM Agent).

* **Reset-SCOMAgentCache**  
  Reset the SCOM health service cache on target systems.

* **Reset-SCOMAgentConfig**  
  Reset the SCOM health service configuration (!) on target systems.

* **Reset-SCOMMonitor**  
  Bulk reset one or multiple monitors in the Management Group.


## Versions

### tbd

- Add cmdlet for reseting monitors
- Add cmdlet for reseting agents

### 1.0.0

- Initial public release
- Management Pack Bundle extraction function
- Health Service workflow listing function


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code]
* [PowerShell Extension]

This module is tested with the PowerShell testing framework Pester. To run all
tests, just start the included test script `.\Scripts\test.ps1` or invoke Pester
directly with the `Invoke-Pester` cmdlet. The tests will automatically download
the latest meta test from the claudiospizzi/PowerShellModuleBase repository.

To debug the module, just copy the existing `.\Scripts\debug.default.ps1` file
to `.\Scripts\debug.ps1`, which is ignored by git. Now add the command to the
debug file and start it.



[PowerShell Gallery]: https://www.powershellgallery.com/packages/OperationsManagerFever
[PowerShellGet]: https://technet.microsoft.com/en-us/library/dn807169.aspx

[GitHub Releases]: https://github.com/claudiospizzi/OperationsManagerFever/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
