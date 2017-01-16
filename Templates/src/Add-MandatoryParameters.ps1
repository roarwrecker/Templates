

function Add-MandatoryParameters {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [System.Management.Automation.InvocationInfo] 
        $InvocationInfo,
        
        [Parameter(Mandatory)]
        [Hashtable]
        $Parameters
    )

    $boundedParametersFromCaller = $InvocationInfo.BoundParameters
    $parametersFromCallingFunction = $InvocationInfo.MyCommand.Parameters 

    # Add ParameterName/ParameterValue pairs for all mandatory parameters to hashtable
    $parametersFromCallingFunction.Keys `
        | Where-Object { Test-MandatoryParameter $parametersFromCallingFunction[$_] } `
        | Foreach-Object { 
            $Parameters.Add($_, $boundedParametersFromCaller[$_]) 
        }
    
    Write-Output $Parameters
}