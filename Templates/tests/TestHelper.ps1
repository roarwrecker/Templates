
function Get-ValidDestination
{
    Write-Output @{ DestinationPath = "${TestDrive}\mymodule" }
}

function Get-ValidModuleName
{
    Write-Output @{ ModuleName = "mymodule" }
}

function Get-ValidDescription
{
    Write-Output @{ Description = "My description!" }
}

function Get-ValidMandatoryArgs
{
    Write-Output ((Get-ValidDestination) `
        + (Get-ValidModuleName) `
        + (Get-ValidDescription))
}