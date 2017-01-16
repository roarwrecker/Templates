#Requires -Modules Pester, testing

Import-ModuleFromPath -Parent 
$mut = 'Templates'
$sut = 'New-CmdletFromTemplate'

Describe "'$sut' tests with default values" {

    $destination = "${TestDrive}\DummyModule"
    Copy-Item -Path "${PSScriptRoot}\DummyModule" -Destination $destination -Recurse -Force
    $cmdletName = "New-Cmdlet"
    
    & $sut -DestinationPath $destination -CmdletName $cmdletName

    $itemsWhichShouldExist = @(
        @{ path = "${destination}\DummyModule.psd1" }
        @{ path = "${destination}\DummyModule.psm1" }
        @{ path = "${destination}\src\${cmdletName}.ps1" }
        @{ path = "${destination}\tests\${cmdletName}.Tests.ps1" }
    )

    It "should exist item '<path>'" -TestCases $itemsWhichShouldExist {
        Param ($path)

        Get-Item -Path $path | Should exist
    }
}

Describe "'$sut' tests with mocked Invoke-Plaster call" {

    Mock -CommandName Invoke-Plaster -ModuleName $mut -MockWith { }
    
    $destination = "${TestDrive}\DummyModule"
    Copy-Item -Path "${PSScriptRoot}\DummyModule" -Destination $destination -Recurse -Force
    $cmdletName = "New-Cmdlet"

    & $sut -DestinationPath $destination -CmdletName $cmdletName

    It "should determine the right module name" {
        Assert-MockCalled -CommandName Invoke-Plaster -ModuleName $mut -ParameterFilter {
            $ModuleName -eq 'DummyModule'
        }
    }

    It "should determine the right cmdlet name" {
        Assert-MockCalled -CommandName Invoke-Plaster -ModuleName $mut -ParameterFilter {
            $CmdletName -eq 'New-Cmdlet'
        }
    }

}