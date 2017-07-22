[![PowerShell Gallery - OperationsManagerFever](https://img.shields.io/badge/PowerShell_Gallery-OperationsManagerFever-0072C6.svg)](https://www.powershellgallery.com/packages/OperationsManagerFever)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/OperationsManagerFever.svg)](https://github.com/claudiospizzi/OperationsManagerFever/releases)
[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/OperationsManagerFever/master.svg)](https://ci.appveyor.com/project/claudiospizzi/OperationsManagerFever/branch/master)
[![AppVeyor - dev](https://img.shields.io/appveyor/ci/claudiospizzi/OperationsManagerFever/master.svg)](https://ci.appveyor.com/project/claudiospizzi/OperationsManagerFever/branch/dev)


# OperationsManagerFever PowerShell Module

PowerShell Module with custom functions and cmdlets for System Center Operations
Manager.


## Introduction

This is a personal PowerShell Module by Claudio Spizzi. It is used to manage
System Center Operations Manager, e.g. exporting MP bundles, get performance
counters or reset SCOM agent health states by PowerShell.


## Features

### Management Pack Bundle

* **Export-SCOMManagementPackBundle**  
  Export all artifacts from a SCOM Management Pack Bundle (.mpb).

### Health Service (SCOM Agent)

* **Get-SCOMAgentManagementGroup**  
  Get all Management Group connections of a SCOM Agent.

* **Remove-SCOMAgentManagementGroup**  
  Remove an existing Management Group connection from a SCOM Agent.

* **Reset-SCOMAgentCache**  
  Reset the SCOM health service cache on target systems.

* **Reset-SCOMAgentConfig**  
  Reset the SCOM health service configuration (!) on target systems.

* **Get-SCOMHealthServiceActiveWorkflow**  
  Show all active workflows on a Health Service.

* **Get-SCOMHealthServiceFailedWorkflow**  
  Show all failed workflows on a Health Service.

### Monitor

* **Reset-SCOMMonitor**  
  Bulk reset one or multiple monitors in the Management Group.


## Versions

Please find all versions in the [GitHub Releases] section and the release notes
in the [CHANGELOG.md] file.


## Installation

Use the following command to install the module from the [PowerShell Gallery],
if the PackageManagement and PowerShellGet modules are available:

```powershell
# Download and install the module
Install-Module -Name 'OperationsManagerFever'
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]


## Requirements

The following minimum requirements are necessary to use this module, or in other
words are used to test this module:

* Windows PowerShell 3.0
* Windows Server 2008 R2 / Windows 7
* System Center Operations Manager 2012 R2 or later
* OperationsManager PowerShell Module (part of the SCOM Operations Console)


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code] with the [PowerShell Extension]
* [Pester], [PSScriptAnalyzer] and [psake] PowerShell Modules

To release a new version in the PowerShell Gallery and the GitHub Releases
section by using the release pipeline on AppVeyor, use the following procedure:

1. Commit all changes in the dev branch
2. Push the commits to GitHub
3. Merge all commits to the master branch
4. Update the version number and release notes in the module manifest and CHANGELOG.md
5. Commit all changes in the master branch (comment: Version x.y.z)
6. Push the commits to GitHub
7. Tag the last commit with the version number
8. Push the tag to GitHub







[PowerShell Gallery]: https://www.powershellgallery.com/packages/OperationsManagerFever
[GitHub Releases]: https://github.com/claudiospizzi/OperationsManagerFever/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[CHANGELOG.md]: CHANGELOG.md

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
[Pester]: https://www.powershellgallery.com/packages/Pester
[PSScriptAnalyzer]: https://www.powershellgallery.com/packages/PSScriptAnalyzer
[psake]: https://www.powershellgallery.com/packages/psake
