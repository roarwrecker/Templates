
function Test-MandatoryParameter {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [System.Management.Automation.ParameterMetadata]
        $Metadata
    )

    $Metadata.Attributes `
        | Where-Object {
            ($_.GetType() -eq [System.Management.Automation.ParameterAttribute])
        } `
        | Select-Object -ExpandProperty Mandatory -First 1
}