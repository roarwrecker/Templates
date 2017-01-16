<# 
    Add key/value pair with passed value, with the default value or without the key/value pair 
    dependent if the parameter and the NoPrompt switch have been specified.
#>
function Add-NonMandatoryParameters {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [Hashtable] 
        $Parameters,

        [Parameter(Mandatory)]
        [bool] 
        $NoPrompt,

        [Parameter(Mandatory)]
        [Hashtable] 
        $NonMandatoryParameters
    )
 
    $NonMandatoryParameters.Keys | ForEach-Object {
        
        $value = $NonMandatoryParameters[$_]
        
        if ($value.Passed) {
            $Parameters.Add($_, $value.Passed)
        }
        elseif ($NoPrompt) {
            $Parameters.Add($_, $value.Default)
        }
    }

    Write-Output $Parameters
}