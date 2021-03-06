﻿# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "${HOME}\.dotfiles"

# import helper functions module
Import-Module -Name "${DOTFILES_INSTALL_DIR}\powershell-functions.ps1"

# clear history
function Clear-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

# move to folder
function X ($Name) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter $Name -Path $HOME `
    | Select-Object -ExpandProperty FullName -First 1 `
    | Set-Location
}

# move to home folder
function Home {
  Set-Location -Path $HOME
}

# move to parent folder
function MoveUp {
  Set-Location -Path ..
}

# start http server on the current folder
function Start-HttpServer ($Port) {
  & npx http-server . -p $Port -c-1 -o
}

# reload profile
function Reload-Profile {
  . "${DOTFILES_INSTALL_DIR}\powershell-profile.ps1"
}

# alias
New-Alias -Name "~" -Value Home -Force
New-Alias -Name ".." -Value MoveUp -Force
New-Alias -Name "g" -Value git -Force
New-Alias -Name "d" -Value dotnet -Force

# enable psreadline
# https://github.com/lzybkr/PSReadLine
Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# set oh my posh theme
# https://ohmyposh.dev
Set-PoshPrompt -Theme "${DOTFILES_INSTALL_DIR}\ohmyposh-theme.json"

# enable terminal icons
# https://github.com/devblackops/Terminal-Icons
Import-Module -Name Terminal-Icons
