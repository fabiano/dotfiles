#Requires -RunAsAdministrator

# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "$HOME\.dotfiles"

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

# install chocolatey
Invoke-Expression -Command ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

# install dependencies
choco install 7zip --confirm
choco install docker-desktop --confirm
choco install firefox --confirm
choco install git --confirm --params "/GitOnlyOnPath /WindowsTerminal /NoShellIntegration /NoGuiHereIntegration /NoShellHereIntegration"
choco install github-desktop --confirm
choco install googlechrome --confirm
choco install insomnia-rest-api-client --confirm
choco install microsoft-windows-terminal --confirm
choco install nodejs --confirm
choco install powershell-core --confirm --install-arguments='"ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"'
choco install python --confirm
choco install rdcman --confirm
choco install telegram --confirm
choco install vim --confirm
choco install vscode --confirm --params "/NoDesktopIcon /NoQuicklaunchIcon"

# reload path
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

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
New-SymbolicLink -Path $HOME\.gitconfig -Value $DOTFILES_INSTALL_DIR\git-gitconfig

# configure powershell core
New-SymbolicLink -Path $HOME\Documents\PowerShell\Profile.ps1 -Value $DOTFILES_INSTALL_DIR\powershell-profile.ps1

& $env:PROGRAMFILES\PowerShell\6\pwsh.exe -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"
& $env:PROGRAMFILES\PowerShell\6\pwsh.exe -Command "PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"

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

# configure windows terminal
New-SymbolicLink -Path $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json -Value $DOTFILES_INSTALL_DIR\win-terminal-profiles.json

# install fonts
$SA = New-Object -ComObject Shell.Application
$Fonts = $SA.NameSpace(0x14)

Get-ChildItem -Path $DOTFILES_INSTALL_DIR\font-*.ttf | ForEach-Object { $Fonts.CopyHere($_.FullName) }

# remove windows 10 built-in apps
Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage
Get-AppxPackage Microsoft.People | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsCamera | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage

# disable bing search results from start menu
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# update command prompt
REG DELETE HKEY_CURRENT_USER\Console /f
REG IMPORT $DOTFILES_INSTALL_DIR\command-prompt.reg

& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini
