<#
.Synopsis
   Creates a new Cmdlet for the specified module
.DESCRIPTION
      
.EXAMPLE

#>
function New-CmdletFromTemplate {

    [CmdletBinding()]
    Param(
        # Specifies the path to the module folder
        [Parameter(Mandatory)]
        [string]
        $DestinationPath,

        # Specifies the name for the new cmdlet
        [Parameter(Mandatory)]
        [string]
        $CmdletName
    )
    
    # Adds all passed mandatory parameters to the parameter hashtable
    $PlasterParameters = Add-MandatoryParameters $MyInvocation @{
        TemplatePath = "${PSScriptRoot}\NewCmdletTemplate\"
        ModuleName = Split-Path -Path $DestinationPath -Leaf
        SourcesPath = 'src'
        TestsPath = 'tests'
        ImportModuleArguments = '-Parent'
    }

    # todo: check if destination path is location of module. Otherwise the ModuleName determination will not work
    # todo: check if src and tests folder exist. If not, the user might want to specify another location for the ps1 files.

    Invoke-Plaster @PlasterParameters -NoLogo -Force
}