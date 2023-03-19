#Requires -RunAsAdministrator

# set to stop on first error
$ErrorActionPreference = "Stop"

# set tls version to 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_REPOSITORY_HTTP = "https://github.com/fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "${HOME}\.dotfiles"

# import functions module
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/powershell-functions.ps1"))

# install git
if (-Not (Test-Path -Path "${$env:PROGRAMFILES}\Git\bin\git.exe")) {
  Install-Git
}

# reload path
# Reload-Path

# set Microsoft OpenSSH to default Git ssh command
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "C:/Windows/System32/OpenSSH/ssh.exe", "User")

# clone repository
if (Test-Path -Path $DOTFILES_INSTALL_DIR) {
  Remove-Item -Path $DOTFILES_INSTALL_DIR -Recurse
}

if (Test-Path -Path $PrivateKeyFileName) {
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR
} else {
  git clone $DOTFILES_REPOSITORY_HTTP $DOTFILES_INSTALL_DIR
}

# configure git
Configure-Git

# disable stop on first error
$ErrorActionPreference = "Continue"

# add .bin folder to user path
Add-FolderToUserPath -Folder "${HOME}\.bin"

# remove windows built-in apps
Remove-BuiltInApps

# disable bing search results from start menu
Set-ItemProperty `
  -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
  -Name "BingSearchEnabled" -Type DWord -Value 0

# install fonts
Install-Fonts

# install powershell
Install-PowerShell
Install-OhMyPosh

# configure powershell and windows terminal
Configure-PowerShell
Configure-WindowsTerminal

# update command prompt
Update-CommandPrompt
