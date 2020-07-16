#Requires -RunAsAdministrator

# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "$HOME\.dotfiles"

# stop on first error
$ErrorActionPreference = "Stop"

# set tls version to 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# disable invoke-request progress bar
$ProgressPreference = "SilentlyContinue"

# new symbolic link function
function New-SymbolicLink ($Path, $Value) {
  $Parent = Split-Path -Path $Path

  if (-Not (Test-Path -Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent
  }

  if (Test-Path -Path $Path) {
    Remove-Item -Path $Path
  }

  New-Item -ItemType SymbolicLink -Path $Path -Value $Value
}

# install app function
function Install-App ($URL, $Outfile, $Arguments) {
  if (Test-Path -Path "${Outfile}.skip") {
    return
  }

  if (-Not (Test-Path -Path $Outfile)) {
    Invoke-WebRequest -Uri $URL -Outfile $Outfile
  }

  if ($Arguments.Count -eq 0) {
    $Process = Start-Process -FilePath $Outfile -Wait -PassThru
  }
  else {
    $Process = Start-Process -FilePath $Outfile -ArgumentList $Arguments -Wait -PassThru
  }

  if (-Not ($Process.ExitCode -eq 0)) {
    throw "${Outfile} installation has failed. Exit code is ${Process.ExitCode}."
  }

  Set-Content -Path "${Outfile}.skip" -Value "skip"
}

# install dependencies
Install-App `
  -URL "https://www.7-zip.org/a/7z1900-x64.exe" `
  -OutFile "7z.exe" `
  -Arguments @("/S")

Install-App `
  -URL "https://go.microsoft.com/fwlink/?linkid=2109256" `
  -OutFile "azuredatastudio.exe" `
  -Arguments @(
    "/SP-"
    "/SILENT"
    "/SUPPRESSMSGBOXES"
    "/TASKS=""addtopath"""
    "/LOG=""azuredatastudio.log"""
  )

Install-App `
  -URL "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi" `
  -OutFile "chrome.msi" `
  -Arguments @(
    "/passive"
    "/norestart"
    "/l*v ""chrome.log"""
  )

Install-App `
  -URL "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeInsiderPage&Channel=Beta&language=en&Consent=0" `
  -OutFile "edge-beta.exe" `
  -Arguments @()

Install-App `
  -URL "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeInsiderPage&Channel=Canary&language=en&Consent=0" `
  -OutFile "edge-canary.exe" `
  -Arguments @()

Install-App `
  -URL "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" `
  -OutFile "firefox.exe" `
  -Arguments @("-ms")

Install-App `
  -URL "https://github.com/vim/vim-win32-installer/releases/download/v8.1.2384/gvim_8.1.2384_x86.exe" `
  -OutFile "gvim.exe" `
  -Arguments @()

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
  -URL "https://updates.insomnia.rest/downloads/windows/latest" `
  -OutFile "insomnia.exe" `
  -Arguments @(
    "--silent"
  )

Install-App `
  -URL "https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.exe" `
  -OutFile "jabra-direct.exe" `
  -Arguments @(
    "/install"
    "/passive"
    "/norestart"
    "/log jabra-direct.log"
  )

Install-App `
  -URL "https://www.linqpad.net/GetFile.aspx?LINQPad6Setup.exe" `
  -OutFile "linqpad6.exe" `
  -Arguments @(
    "/SP-"
    "/SILENT"
    "/SUPPRESSMSGBOXES"
    "/TASKS=""lprunpath"""
    "/LOG=""linqpad6.log"""
  )

Install-App `
  -URL "https://download01.logi.com/web/ftp/pub/techsupport/capture/Capture_1.10.110.exe" `
  -OutFile "logi-capture.exe" `
  -Arguments @()

Install-App `
  -URL "https://download01.logi.com/web/ftp/pub/techsupport/options/Options_8.0.863.exe" `
  -OutFile "logi-options.exe" `
  -Arguments @()

Install-App `
  -URL "https://nodejs.org/dist/v12.13.1/node-v12.13.1-x64.msi" `
  -OutFile "node.msi" `
  -Arguments @(
    "/passive"
    "/norestart"
    "/l*v ""node.log"""
  )

Install-App `
  -URL "https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/PowerShell-7.0.3-win-x64.msi" `
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
  -URL "https://www.python.org/ftp/python/3.8.0/python-3.8.0.exe" `
  -OutFile "python38.exe" `
  -Arguments @(
    "/passive"
    "AssociateFiles=0"
    "Shortcuts=0"
    "PrependPath=1"
  )

Install-App `
  -URL "https://github.com/tibold/svg-explorer-extension/releases/download/v1.1.0/svg_see_x64.exe" `
  -OutFile "svg-explorer-extension.exe" `
  -Arguments @(
    "/SP-"
    "/SILENT"
    "/SUPPRESSMSGBOXES"
    "/TASKS="""""
    "/LOG=""svg-explorer-extension.log"""
  )

Install-App `
  -URL "https://telegram.org/dl/desktop/win" `
  -OutFile "telegram.exe" `
  -Arguments @(
    "/SP-"
    "/SILENT"
    "/SUPPRESSMSGBOXES"
    "/TASKS="""""
    "/LOG=""telegram.log"""
  )

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

Install-App `
  -URL "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12130-20272.exe" `
  -OutFile "office-deployment-tool.exe" `
  -Arguments @(
    "/extract:office-deployment-tool"
    "/passive"
    "/norestart"
  )

& office-deployment-tool\setup.exe /download $HOME\.dotfiles\office-deployment-tool-office365.xml
& office-deployment-tool\setup.exe /configure $HOME\.dotfiles\office-deployment-tool-office365.xml

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
& $env:PROGRAMFILES\PowerShell\6\pwsh.exe -Command "PowerShellGet\Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"

# configure vim
New-SymbolicLink -Path $HOME\.vimrc -Value $DOTFILES_INSTALL_DIR\vim-vimrc

if (-Not (Test-Path -Path $HOME/.vim/autoload)) {
  New-Item -ItemType Directory -Path $HOME/.vim/autoload
}

Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -Outfile $HOME/.vim/autoload/plug.vim

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
Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage
Get-AppxPackage Microsoft.People | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsCamera | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage

# disable bing search results from start menu
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# update command prompt
REG DELETE HKEY_CURRENT_USER\Console /f
REG IMPORT $DOTFILES_INSTALL_DIR\command-prompt.reg

& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini

# enable invoke-request progress bar
$ProgressPreference = "Continue"
