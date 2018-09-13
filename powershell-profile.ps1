﻿# environment variables
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "C:/Windows/System32/OpenSSH/ssh.exe", "User")

# functions
function Delete-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

function Open ($ProjectName) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter "$ProjectName" $HOME | select -ExpandProperty FullName | Set-Location
}

# posh-git
Import-Module posh-git

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::DarkBlue
$GitPromptSettings.DefaultPromptPrefix.Text = '`n'
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::DarkMagenta
$GitPromptSettings.DefaultPromptSuffix.Text = '❯ '
