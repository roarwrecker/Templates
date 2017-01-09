# PowerShell Templates Module
[![Build status](https://ci.appveyor.com/api/projects/status/a7j3xtney8s86kma?svg=true)](https://ci.appveyor.com/project/roarwrecker/templates)

A PowerShell templates module using Plaster (https://github.com/PowerShell/Plaster) to generate projects and files based on XML templates.

### Dependencies

The Templates module has the following dependencies:
- [Plaster](https://github.com/PowerShell/Plaster)
- [Pester](https://github.com/pester/Pester): Without Pester, you will not be able to run the Pester tests shipped with this module.
- Required minimum PowerShell version: 3.0

### Installation

You can clone the repository and add the modules folder to your PowerShell module path. Or you can install the module from the [PowerShell Gallery](https://www.powershellgallery.com/) using the following command:
```PowerShell
Install-Module -Name Templates -Repository PSGallery
```

### Usage

Please check the PowerShell help written for the Templates functions.

### License

The PowerShell Templates Module is distributed under the [MIT license](https://github.com/roarwrecker/Templates/blob/master/LICENSE).
