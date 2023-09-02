# reload path function
function Reload-Path {
  $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
}

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

# add folder to user path function
function Add-FolderToUserPath ($Folder) {
  $Path = [Environment]::GetEnvironmentVariable("Path", "User")

  if ($Path -like "*${Folder}*") {
    return
  }

  [Environment]::SetEnvironmentVariable("Path", $Path + ";" + $Folder, "User")
}

# remove built-in windows 10/11 apps
function Remove-BuiltInApps {
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
}

# install fonts
function Install-Fonts {
  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem -Path "${DOTFILES_INSTALL_DIR}\*" -Include @("*.ttf", "*.ttc") | ForEach-Object { $Fonts.CopyHere($_.FullName) }
}

# install essential apps
function Install-Apps {
  winget install --id 7zip.7zip --exact
  winget install --id Google.Chrome --exact
  winget install --id junegunn.fzf --exact
  winget install --id Microsoft.Edge --exact
  winget install --id Microsoft.PowerShell --exact --override "/passive /norestart ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"
  winget install --id Microsoft.VCRedist.2015+.x64 --exact # required for bat
  winget install --id Microsoft.WindowsTerminal --exact
  winget install --id Mozilla.Firefox --exact
  winget install --id sharkdp.bat --exact
  winget install --id Starship.Starship --exact

  Reload-Path

  # create symbolic links
  New-SymbolicLink -Path "${HOME}\Documents\PowerShell\Profile.ps1" ` -Value "${DOTFILES_INSTALL_DIR}\powershell-profile.ps1"
  New-SymbolicLink -Path "${HOME}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Value "${DOTFILES_INSTALL_DIR}\win-terminal-settings.json"
  New-SymbolicLink -Path "${HOME}\starship.toml" -Value "${DOTFILES_INSTALL_DIR}\starship.toml"

  # configure powershell
  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"
  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"
  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "PowerShellGet\Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"
}

# install dev tools
function Install-DevTools {
  winget install --id Microsoft.Office --exact --override "/configure ${DOTFILES_INSTALL_DIR}\office365.xml"
  winget install --id Microsoft.VisualStudioCode --exact --override "/SP- /SILENT /SUPPRESSMSGBOXES /TASKS=""addcontextmenufiles,addcontextmenufolders,addtopath"""
  winget install --id Insomnia.Insomnia --exact
  winget install --id vim.vim --exact
  winget install --id Mozilla.Firefox.DeveloperEdition --exact

  Reload-Path

  # create symbolic links
  New-SymbolicLink -Path "${HOME}\AppData\Roaming\azuredatastudio\User\settings.json" -Value "${DOTFILES_INSTALL_DIR}\azuredatastudio-settings.json"
  New-SymbolicLink -Path "${HOME}\AppData\Roaming\Code\User\settings.json" -Value "${DOTFILES_INSTALL_DIR}\vscode-settings.json"
  New-SymbolicLink -Path "${HOME}\.vimrc" -Value "${DOTFILES_INSTALL_DIR}\vim-vimrc"
  
  # install plug
  New-Item -ItemType Directory -Path "${HOME}\.vim\autoload" -Force
  Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile "${HOME}\.vim\autoload\plug.vim"

  # install vscode extensions
  Get-Content -Path "${DOTFILES_INSTALL_DIR}\vscode-extensions.txt" | ForEach-Object { code --install-extension $_ }
}
