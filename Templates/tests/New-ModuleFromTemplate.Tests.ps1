#Requires -Modules Pester, testing

Import-ModuleFromPath -Parent 
. "${PSScriptRoot}\TestHelper.ps1"
$mut = 'Templates'
$sut = 'New-ModuleFromTemplate'

Describe "'$sut' tests with mandatory parameters only" {

    $destination = "${TestDrive}\mymodule"
    $moduleName = "mymodule"
    $description = 'My description'
    & $sut -DestinationPath $destination -ModuleName $moduleName -Description $description -NoPrompt

    $itemsWhichShouldExist = @(
        @{ path = "${destination}\.gitignore" }
        @{ path = "${destination}\appveyor.yml" }
        @{ path = "${destination}\LICENSE" }
        @{ path = "${destination}\README.md" }
        @{ path = "${destination}\$moduleName" }
        @{ path = "${destination}\${moduleName}\${moduleName}.psd1" }
        @{ path = "${destination}\${moduleName}\${moduleName}.psm1" }
        @{ path = "${destination}\${moduleName}\src" }
        @{ path = "${destination}\${moduleName}\tests" }
    )

    It "should create item '<path>'" -TestCases $itemsWhichShouldExist {
        Param ($path)

        Get-Item -Path $path | Should exist
    }
}

Describe "'$sut' tests with invalid parameters" {

    $destination = "${TestDrive}\mymodule"
    $moduleName = "mymodule"
    $description = "My description"

    $errorThrowingArguments = @(
        @{  arguments = @{ DestinationPath='' } + (Get-ValidModuleName)
            expectedErrorContent = 'DestinationPath'
        }, 
        @{  arguments = @{ DestinationPath=$null } + (Get-ValidModuleName)
            expectedErrorContent = 'DestinationPath'
        }, 
        @{  arguments = (Get-ValidDestination) + @{ ModuleName='' }
            expectedErrorContent = 'ModuleName'
        }, 
        @{  arguments = (Get-ValidDescription) + @{ ModuleName=$null }
            expectedErrorContent = 'ModuleName'
        },
        @{  arguments = (Get-ValidMandatoryArgs) + @{ Author="" }
            expectedErrorContent = 'Author'
        },
        @{  arguments = (Get-ValidMandatoryArgs) + @{ Author=$null }
            expectedErrorContent = 'Author'
        }
    )

    It "should throw an error because of <expectedErrorContent>." -TestCases $errorThrowingArguments {
        Param($arguments, $expectedErrorContent)
        { & $sut @arguments } | Should throw $expectedErrorContent
    }
}

Describe "'$sut' without NoPrompt parameter" {

    Mock -CommandName 'Invoke-Plaster' -ModuleName $mut -MockWith { }

    It "should not auto fill non mandatory parameters" {
        $args = Get-ValidMandatoryArgs
        & $sut @args 

        # The Invoke-Plaster cmdlet should not contain any values for the non mandatory parameters
        # because they should be prompted to input.
        Assert-MockCalled -CommandName 'Invoke-Plaster' -ModuleName $mut -ParameterFilter {
            !$PSBoundParameters.ContainsKey("Author") -and
                !$PSBoundParameters.ContainsKey("Version") -and
                !$PSBoundParameters.ContainsKey("Company") -and
                !$PSBoundParameters.ContainsKey("PowerShellVersion")
        }
    }

    It "should use default values for parameters when passing NoPrompt switch" {
        $args = Get-ValidMandatoryArgs
        & $sut @args -NoPrompt

        Assert-MockCalled -CommandName 'Invoke-Plaster' -ModuleName $mut -ParameterFilter { 
            $Author -eq 'Unknown' -and 
            $Version -eq '0.1.0' -and
            $Company -eq 'Unknown' -and
            $PowerShellVersion -eq 'None'
        }
    }
}

