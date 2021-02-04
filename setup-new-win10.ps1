#Requires -RunAsAdministrator

# set to stop on first error
$ErrorActionPreference = "Stop"

# set tls version to 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "$HOME\.dotfiles"

# import functions module
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/powershell-functions.ps1"))

# install git
Install-Git

# reload path
Reload-Path

# set environment variables
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:\Windows\System32\OpenSSH\ssh.exe", "User")

# start ssh-agent service
Set-Service -Name ssh-agent -StartupType Automatic -Status Running

# add private key to the ssh-agent
ssh-add $HOME\.ssh\id_rsa

# clone repository
if (Test-Path -Path $DOTFILES_INSTALL_DIR) {
  Remove-Item -Path $DOTFILES_INSTALL_DIR -Recurse
}

git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

# configure git
Configure-Git

# disable stop on first error
$ErrorActionPreference = "Continue"

# install fonts
$SA = New-Object -ComObject Shell.Application
$Fonts = $SA.NameSpace(0x14)

Get-ChildItem -Path $DOTFILES_INSTALL_DIR\font-*.ttf | ForEach-Object { $Fonts.CopyHere($_.FullName) }

# remove windows 10 built-in apps
Remove-BuiltInApps

# disable bing search results from start menu
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# update command prompt
REG DELETE HKEY_CURRENT_USER\Console /f
REG IMPORT $DOTFILES_INSTALL_DIR\command-prompt.reg

& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini

# install essential apps
Install-Apps
