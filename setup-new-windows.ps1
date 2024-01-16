#Requires -RunAsAdministrator

# set to stop on first error
$ErrorActionPreference = "Stop"

# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "${HOME}\.dotfiles"

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

# remove bloatware
Get-AppxPackage 5A894077.McAfeeSecurity | Remove-AppxPackage
Get-AppxPackage C27EB4BA.DropboxOEM | Remove-AppxPackage
Get-AppxPackage Clipchamp.Clipchamp | Remove-AppxPackage
Get-AppxPackage DellInc.DellCustomerConnect | Remove-AppxPackage
Get-AppxPackage DellInc.DellDigitalDelivery | Remove-AppxPackage
Get-AppxPackage DellInc.PartnerPromo | Remove-AppxPackage
Get-AppxPackage Disney.37853FC22B2CE | Remove-AppxPackage
Get-AppxPackage DolbyLaboratories.DolbyAccess | Remove-AppxPackage
Get-AppxPackage DolbyLaboratories.DolbyVisionAccess | Remove-AppxPackage
Get-AppxPackage FACEBOOK.FACEBOOK | Remove-AppxPackage
Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage
Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage
Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage Microsoft.Todos | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsCamera | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage
Get-AppxPackage MicrosoftCorporationII.MicrosoftFamily | Remove-AppxPackage
Get-AppxPackage MicrosoftCorporationII.QuickAssist | Remove-AppxPackage
Get-AppxPackage MicrosoftTeams | Remove-AppxPackage
Get-AppxPackage PortraitDisplays.DellCinemaColor | Remove-AppxPackage
Get-AppxPackage ScreenovateTechnologies.DellMobileConnect | Remove-AppxPackage
Get-AppxPackage SpotifyAB.SpotifyMusic | Remove-AppxPackage

# install git
winget update --accept-package-agreements --accept-source-agreements
winget install --exact --id Git.Git --override "/SP- /SILENT /SUPPRESSMSGBOXES /COMPONENTS=""gitlfs,autoupdate"""

# reload path
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

# configure Microsoft OpenSSH as default Git ssh command
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "C:/Windows/System32/OpenSSH/ssh.exe", "User")

# clone repository
if (Test-Path -Path $DOTFILES_INSTALL_DIR) {
  Remove-Item -Path $DOTFILES_INSTALL_DIR -Recurse
}

git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

# install apps
winget install --exact --id Git.Git --override "/SP- /SILENT /SUPPRESSMSGBOXES /COMPONENTS=""gitlfs,autoupdate"""
winget install --exact --id Helix.Helix
winget install --exact --id Microsoft.Office --override "/configure ${DOTFILES_INSTALL_DIR}\office-pro-plus.xml"
winget install --exact --id Microsoft.PowerShell --override "/passive /norestart ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"
winget install --exact --id Microsoft.PowerToys
winget install --exact --id Microsoft.VisualStudioCode --override "/SP- /SILENT /SUPPRESSMSGBOXES /TASKS=""addcontextmenufiles,addcontextmenufolders,addtopath"""
winget install --exact --id Mozilla.Firefox
winget install --exact --id Starship.Starship

# reload path
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

# create dotfiles
New-SymbolicLink -Path "${HOME}\.gitconfig" -Value "${DOTFILES_INSTALL_DIR}\git-gitconfig"
New-SymbolicLink -Path "${HOME}\.vimrc" -Value "${DOTFILES_INSTALL_DIR}\vim-vimrc"
New-SymbolicLink -Path "${HOME}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Value "${DOTFILES_INSTALL_DIR}\win-terminal-settings.json"
New-SymbolicLink -Path "${HOME}\AppData\Roaming\Code\User\settings.json" -Value "${DOTFILES_INSTALL_DIR}\vscode-settings.json"
New-SymbolicLink -Path "${HOME}\AppData\Roaming\helix\config.toml" -Value "${DOTFILES_INSTALL_DIR}\helix-config.toml"
New-SymbolicLink -Path "${HOME}\Documents\PowerShell\Profile.ps1" ` -Value "${DOTFILES_INSTALL_DIR}\powershell-profile.ps1"
New-SymbolicLink -Path "${HOME}\starship.toml" -Value "${DOTFILES_INSTALL_DIR}\starship.toml"

# configure powershell
& $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"
& $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"

# install plug
New-Item -ItemType Directory -Path "${HOME}\.vim\autoload" -Force
Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile "${HOME}\.vim\autoload\plug.vim"

# install visual studio code extensions
Get-Content -Path "${DOTFILES_INSTALL_DIR}\vscode-extensions.txt" | ForEach-Object { code --install-extension $_ }

# install fonts
Get-ChildItem -Path "${DOTFILES_INSTALL_DIR}" -Filter "*.ttf" | ForEach-Object { (New-Object -ComObject Shell.Application).NameSpace(0x14).CopyHere($_.FullName) }

# configure command prompt
# https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/cc978575(v=technet.10)
# https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/cc978583(v=technet.10)
# https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/cc978585(v=technet.10)
Remove-Item -Path HKCU:\Console\* -Recurse

Set-ItemProperty -Path "HKCU:\Console" -Name "FaceName" -Value "Iosevka Term"
Set-ItemProperty -Path "HKCU:\Console" -Name "FontFamily" -Value "54" -Type "DWord"
Set-ItemProperty -Path "HKCU:\Console" -Name "FontSize" -Value "1114112" -Type "DWord" # 11 = 0011 0000 = 1114112
Set-ItemProperty -Path "HKCU:\Console" -Name "ScreenBufferSize" -Value "589889696" -Type "DWord" # 9001x160 = 2329 00A0 = 589889696
Set-ItemProperty -Path "HKCU:\Console" -Name "WindowSize" -Value "1966240" -Type "DWord" # 30x160 = 001E 00A0 = 1966240
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -Name "000" -Value "Iosevka Term"

& $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini

# disable stop on first error
$ErrorActionPreference = "Continue"
