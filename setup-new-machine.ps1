﻿#Requires -RunAsAdministrator

# stop on first error
$ErrorActionPreference = "Stop"

# set tls version to 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# new symbolic link function
function New-SymbolicLink ($Path, $Value) {
  $Parent = Split-Path -Path $Path

  if (-Not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent
  }

  if (Test-Path $Path) {
    Remove-Item -Path $Path
  }

  New-Item -ItemType SymbolicLink -Path $Path -Value $Value
}

# dotfiles folder
$DOTFILES_INSTALL_DIR="$HOME\.dotfiles"

# install dependencies
if (-Not (Test-Path -Path "${env:PROGRAMFILES}\Git\bin\git.exe")) {
  Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.19.0.windows.1/Git-2.19.0-64-bit.exe" -Outfile "f-git.exe"

  .\f-git.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /COMPONENTS="gitlfs,autoupdate" /LOG="f-git.log"

  Remove-Item -Path f-git.exe
}

if (-Not (Test-Path -Path "${env:PROGRAMFILES}\PowerShell\6\pwsh.exe")) {
  Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x64.msi" -Outfile "f-pwsh.msi"

  .\f-pwsh.msi /qn /norestart /l*v "f-pwsh.log" ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1

  Remove-Item -Path f-pwsh.msi
}

if (-Not (Test-Path -Path "${env:LOCALAPPDATA}\hyper\Hyper.exe")) {
  Invoke-WebRequest -Uri "https://releases.hyper.is/download/win" -Outfile "f-hyper.exe"

  .\f-hyper.exe --silent

  Remove-Item -Path f-hyper.exe
}

if (-Not (Test-Path -Path "${env:PROGRAMFILES(x86)}\Vim\vim81\vim.exe")) {
  Invoke-WebRequest -Uri "ftp://ftp.vim.org/pub/vim/pc/gvim81.exe" -Outfile "f-gvim.exe"

  .\f-gvim.exe

  Remove-Item -Path f-gvim.exe
}

if (-Not (Test-Path -Path "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe")) {
  Invoke-WebRequest -Uri "https://aka.ms/win32-x64-user-stable" -Outfile "f-vscode.exe"

  .\f-vscode.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /TASKS="addcontextmenufiles,addcontextmenufolders,addtopath" /LOG="f-vscode.log"

  Remove-Item -Path f-vscode.exe
}

# reload path
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

# set environment variables
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:/Windows/System32/OpenSSH/ssh.exe", "User")

# start ssh-agent service
Set-Service -Name ssh-agent -StartupType Automatic -Status Running

# clone repository
if ((Test-Path -Path $DOTFILES_INSTALL_DIR)) {
  Remove-Item -Path $DOTFILES_INSTALL_DIR -Recurse
}

git clone git@github.com:fabiano/dotfiles.git $DOTFILES_INSTALL_DIR

# update command prompt colors
& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini

# configure git
New-SymbolicLink -Path $HOME\.gitconfig -Value $DOTFILES_INSTALL_DIR\git-gitconfig

# configure powershell core
New-SymbolicLink -Path "$HOME\Documents\PowerShell\Profile.ps1" -Value $DOTFILES_INSTALL_DIR\powershell-profile.ps1

PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -AllowPrerelease -Force
PowerShellGet\Install-Module -Name PSColor -Scope CurrentUser -AllowPrerelease -Force

# configure hyper
New-SymbolicLink -Path $HOME\.hyper.js -Value $DOTFILES_INSTALL_DIR\hyper.js

hyper install hyper-snazzy

# configure vim
New-SymbolicLink -Path $HOME\.vimrc -Value $DOTFILES_INSTALL_DIR\vim-vimrc

if (-Not (Test-Path -Path $HOME/.vim/autoload)) {
  New-Item -ItemType Directory -Path $HOME/.vim/autoload
}

Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -Outfile $HOME/.vim/autoload/plug.vim

vim -c "PlugInstall" -c "qa!"

# configure visual studio code
New-SymbolicLink -Path $HOME\AppData\Roaming\Code\User\settings.json -Value $DOTFILES_INSTALL_DIR\vscode-settings.json

Get-Content -Path $DOTFILES_INSTALL_DIR\vscode-extensions.txt | ForEach-Object { code --install-extension $_ }

# copy fonts
Invoke-WebRequest -Uri "https://github.com/aosp-mirror/platform_frameworks_base/raw/master/data/fonts/DroidSansMono.ttf" -Outfile font-droid-sans-mono.ttf
Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf" -Outfile font-firacode-regular.ttf

$SA = New-Object -ComObject Shell.Application
$Fonts = $SA.NameSpace(0x14)

Get-ChildItem -Path font-*.ttf | ForEach-Object { $Fonts.CopyHere($_.FullName) }

Remove-Item -Path font-*.ttf -Recurse
