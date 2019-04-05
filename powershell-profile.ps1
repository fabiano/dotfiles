# functions
function Clear-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

function x ($Name) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter "$Name" $HOME `
    | Select-Object -ExpandProperty FullName `
    | Set-Location
}

function Prompt {
  Write-Host ""
  Write-Host $PWD -ForegroundColor DarkBlue

  if ($env:HYPER -Eq "1") {
    Write-Host "❯❯" -NoNewLine -ForegroundColor DarkMagenta
  }
  else {
    Write-Host "»" -NoNewLine -ForegroundColor DarkMagenta
  }

  return " "
}
