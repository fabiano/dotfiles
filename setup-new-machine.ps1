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

# install app function
function Install-App ($URL, $Outfile, $Arguments) {
  if (-Not (Test-Path $Outfile)) {
    $ProgressPreference = "SilentlyContinue"

    Invoke-WebRequest -Uri $URL -Outfile $Outfile

    $ProgressPreference = "Continue"
  }

  if ($Arguments.Count -eq 0) {
    $Process = Start-Process -FilePath $Outfile -Wait -PassThru
  }
  else {
    $Process = Start-Process -FilePath $Outfile -ArgumentList $Arguments -Wait -PassThru
  }

  if (-Not ($Process.ExitCode -eq 0)) {
    throw "${URL} installation has failed"
  }
}

# install dependencies
Install-App `
  -URL "https://www.7-zip.org/a/7z1900-x64.exe" `
  -OutFile "7z.exe" `
  -Arguments @("/S")

Install-App `
  -URL "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" `
  -OutFile "firefox.exe" `
  -Arguments @("-ms")

Install-App `
  -URL "https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe" `
  -OutFile "git.exe" `
  -Arguments @(
    "/SP-"
    "/SILENT"
    "/SUPPRESSMSGBOXES"
    "/COMPONENTS=""gitlfs,autoupdate"""
    "/LOG=""git.log"""
  )

Install-App `
  -URL "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi" `
  -OutFile "chrome.msi" `
  -Arguments @("/passive", "/norestart", "/l*v ""chrome.log""")

Install-App `
  -URL "https://nodejs.org/dist/v12.13.1/node-v12.13.1-x64.msi" `
  -OutFile "node.msi" `
  -Arguments @("/passive", "/norestart", "/l*v ""node.log""")

Install-App `
  -URL "https://github.com/PowerShell/PowerShell/releases/download/v6.2.3/PowerShell-6.2.3-win-x64.msi" `
  -OutFile "pwsh.msi" `
  -Arguments @(
    "/passive"
    "/norestart"
    "/l*v ""pwsh.log"""
    "ADD_PATH=1"
    "REGISTER_MANIFEST=1"
    "ENABLE_PSREMOTING=0"
    "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"
  )

Install-App `
  -URL "https://github.com/vim/vim-win32-installer/releases/download/v8.1.2384/gvim_8.1.2384_x86.exe" `
  -OutFile "gvim.exe" `
  -Arguments @()

Install-App `
  -URL "https://aka.ms/win32-x64-user-stable" `
  -OutFile "vscode.exe" `
  -Arguments @(
    "/SP-"
    "/SILENT"
    "/SUPPRESSMSGBOXES"
    "/TASKS=""addcontextmenufiles,addcontextmenufolders,addtopath"""
    "/LOG=""vscode.log"""
  )

Install-App `
  -URL "https://ufpr.dl.sourceforge.net/project/windirstat/windirstat/1.1.2%20installer%20re-release%20%28more%20languages%21%29/windirstat1_1_2_setup.exe" `
  -OutFile "windirstat.exe" `
  -Arguments @("/S")

# reload path
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

# set environment variables
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:\Windows\System32\OpenSSH\ssh.exe", "User")

# start ssh-agent service
Set-Service -Name ssh-agent -StartupType Automatic -Status Running

# add private key to the ssh-agent
& $env:PROGRAMFILES\Git\usr\bin\ssh-add.exe $HOME\.ssh\id_rsa

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
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage

# disable bing search results from start menu
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# update command prompt
REG DELETE HKEY_CURRENT_USER\Console /f
REG IMPORT $DOTFILES_INSTALL_DIR\command-prompt.reg

& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini
