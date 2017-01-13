
# dot source all scripts located in the src folder
Get-ChildItem -LiteralPath $PSScriptRoot -Filter 'src/*.ps1' -File `
    | Select-Object -ExpandProperty FullName `
    | ForEach-Object { . $_ }
