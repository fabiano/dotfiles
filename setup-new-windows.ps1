#Requires -RunAsAdministrator

# set to stop on first error
$ErrorActionPreference = "Stop"

# set tls version to 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "${HOME}\.dotfiles"

# import functions module
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/powershell-functions.ps1"))

# install git
if (-Not (Test-Path -Path "${$env:PROGRAMFILES}\Git\bin\git.exe")) {
  winget install `
    --id Git.Git `
    --exact `
    --override "/SP- /SILENT /SUPPRESSMSGBOXES /COMPONENTS=""gitlfs,autoupdate"""

  Reload-Path
}

# set Microsoft OpenSSH to default Git ssh command
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "C:/Windows/System32/OpenSSH/ssh.exe", "User")

# clone repository
if (Test-Path -Path $DOTFILES_INSTALL_DIR) {
  Remove-Item -Path $DOTFILES_INSTALL_DIR -Recurse
}

git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

# create gitconfig symbolic link
New-SymbolicLink -Path "${HOME}\.gitconfig" -Value "${DOTFILES_INSTALL_DIR}\git-gitconfig"

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

# configure command prompt
Remove-ItemProperty -Path HKCU:\Console -Name *

Set-ItemProperty -Path "HKCU:\Console" -Name "FaceName" -Value "IosevkaTerm NF"
Set-ItemProperty -Path "HKCU:\Console" -Name "FontFamily" -Value "54" -Type "DWord"
Set-ItemProperty -Path "HKCU:\Console" -Name "FontSize" -Value "1179648" -Type "DWord"
Set-ItemProperty -Path "HKCU:\Console" -Name "ScreenBufferSize" -Value "589889696" -Type "DWord"
Set-ItemProperty -Path "HKCU:\Console" -Name "WindowSize" -Value "1966240" -Type "DWord"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -Name "000" -Value "IosevkaTerm NF"

& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini

# install essential apps
Install-Apps
