# functions
function Delete-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

function x ($Name) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter "$Name" $HOME | select -ExpandProperty FullName | Set-Location
}

# posh-git
# https://github.com/dahlbyk/posh-git
Import-Module posh-git

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::DarkBlue
$GitPromptSettings.DefaultPromptPrefix.Text = '`n'
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::DarkMagenta

if ($env:HYPER -Eq "1") {
  $GitPromptSettings.DefaultPromptSuffix.Text = '❯❯ '
}
else {
  $GitPromptSettings.DefaultPromptSuffix.Text = '» '
}

# PSColor
# https://github.com/Davlind/PSColor
Import-Module PSColor
