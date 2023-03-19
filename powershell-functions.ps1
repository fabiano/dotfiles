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

# install app function
function Install-App ($URL, $Outfile, $Arguments) {
  if (Test-Path -Path "${Outfile}.skip") {
    return
  }

  if (-Not (Test-Path -Path $Outfile)) {
    # disable invoke-webrequest progress bar
    $ProgressPreference = "SilentlyContinue"

    Invoke-WebRequest -Uri $URL -OutFile $Outfile

    # enable invoke-webrequest progress bar
    $ProgressPreference = "Continue"
  }

  if ($Arguments.Count -eq 0) {
    $Process = Start-Process -FilePath $Outfile -Wait -PassThru
  } else {
    $Process = Start-Process -FilePath $Outfile -ArgumentList $Arguments -Wait -PassThru
  }

  if (-Not ($Process.ExitCode -eq 0)) {
    Write-Error "${Outfile} installation has failed. Exit code is ${Process.ExitCode}."

    return
  }

  Set-Content -Path "${Outfile}.skip" -Value "skip"
}

# install portable app function
function Install-PortableApp ($URL, $Outfile, $DestinationPath) {
  if (Test-Path -Path "${Outfile}.skip") {
    return
  }

  if (-Not (Test-Path -Path $Outfile)) {
    # disable invoke-webrequest progress bar
    $ProgressPreference = "SilentlyContinue"

    Invoke-WebRequest -Uri $URL -OutFile $Outfile

    # enable invoke-webrequest progress bar
    $ProgressPreference = "Continue"
  }

  if ($Outfile -like "*.zip") {
    Expand-Archive -LiteralPath $Outfile -DestinationPath $DestinationPath -Force
  } else {
    Copy-Item -Path $Outfile -Destination $DestinationPath -Force
  }

  Set-Content -Path "${Outfile}.skip" -Value "skip"
}

# create shortcut function
function Create-Shortcut ($Name, $Path) {
  $Shell = New-Object -ComObject "WScript.Shell"
  $Shortcut = $Shell.CreateShortcut("${env:USERPROFILE}\Start Menu\Programs\${Name}.lnk")
  $Shortcut.TargetPath = $Path
  $Shortcut.Save()
}

# install 7-zip
function Install-7Zip {
  winget install  `
    --id 7zip.7zip `
    --exact
}

# install chrome
function Install-Chrome {
  winget install  `
    --id Google.Chrome `
    --exact
}

# install firefox
function Install-Firefox {
  winget install `
    --id Mozilla.Firefox `
    --exact
}

# install vim
function Install-GVim {
  Install-PortableApp `
    -URL "https://github.com/vim/vim-win32-installer/releases/download/v8.2.4868/gvim_8.2.4868_x64.zip" `
    -OutFile "setup-gvim.zip" `
    -DestinationPath "${HOME}\.bin"

  Add-FolderToUserPath -Folder "${HOME}\.bin\vim\vim82"
}

# install git
function Install-Git {
  winget install `
    --id Git.Git `
    --exact `
    --override "/SP- /SILENT /SUPPRESSMSGBOXES /COMPONENTS=""gitlfs,autoupdate"""
}

# install insomnia
function Install-Insomnia {
  winget install `
    --id Insomnia.Insomnia `
    --exact
}

# install jabra direct
function Install-JabraDirect {
   winget install `
    --id Jabra.Direct `
    --exact
}

# install logitech capture
function Install-LogitechCapture {
  Install-App `
    -URL "https://download01.logi.com/web/ftp/pub/techsupport/capture/Capture_2.00.226.exe" `
    -OutFile "setup-logitech-capture.exe" `
    -Arguments @()
}

# install logitech options
function Install-LogitechOptions {
  winget install `
    --id Logitech.Options `
    --exact
}

# install node
function Install-Node {
  winget install `
    --id OpenJS.NodeJS `
    --exact
}

# install powershell
function Install-PowerShell {
  winget install `
    --id Microsoft.PowerShell `
    --exact `
    --override "/passive /norestart ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"
}

# install svg explorer extension
function Install-SvgExplorerExtension {
  winget install `
    --id SVGExplorerExtension.SVGExplorerExtension `
    --exact `
    --override "/SP- /SILENT /SUPPRESSMSGBOXES /TASKS="""""
}

# install visual studio code
function Install-VSCode {
  winget install `
    --id Microsoft.VisualStudioCode `
    --exact `
    --override "/SP- /SILENT /SUPPRESSMSGBOXES /TASKS=""addcontextmenufiles,addcontextmenufolders,addtopath"""
}

# install office 365
function Install-Office365 {
  winget install `
    --id Microsoft.OfficeDeploymentTool `
    --exact

  & "C:\Program Files\OfficeDeploymentTool\setup.exe" /download "${HOME}\.dotfiles\office-deployment-tool-office365.xml"
  & "C:\Program Files\OfficeDeploymentTool\setup.exe" /configure "${HOME}\.dotfiles\office-deployment-tool-office365.xml"
}

# install typora
function Install-Typora {
  winget install `
    --id Typora.Typora `
    --exact `
    --override "/SP- /SILENT /SUPPRESSMSGBOXES /TASKS="""""
}

# install visual studio community
function Install-VSCommunity {
  winget install `
    --id Microsoft.VisualStudio.2022.Community `
    --exact
}

# install oh my posh
function Install-OhMyPosh {
  winget install `
    --id JanDeDobbeleer.OhMyPosh `
    --exact
}

# install screen to gif
function Install-ScreenToGif {
  winget install `
    --id NickeManarin.ScreenToGif `
    --exact
}

# install npiperelay
function Install-npiperelay {
  Install-PortableApp `
    -URL "https://github.com/jstarks/npiperelay/releases/download/v0.1.0/npiperelay_windows_amd64.zip" `
    -OutFile "setup-npiperelay.zip" `
    -DestinationPath "${HOME}\.bin"
}

# install nuget
function Install-NuGet {
  Install-PortableApp `
    -URL "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" `
    -OutFile "setup-nuget.exe" `
    -DestinationPath "${HOME}\.bin\nuget.exe"
}

# install bombardier
function Install-Bombardier {
  Install-PortableApp `
    -URL "https://github.com/codesenberg/bombardier/releases/download/v1.2.5/bombardier-windows-amd64.exe" `
    -OutFile "setup-bombardier.exe" `
    -DestinationPath "${HOME}\.bin\bombardier.exe"
}

# install youtube-dl
function Install-YouTubeDL {
  Install-PortableApp `
    -URL "https://youtube-dl.org/downloads/latest/youtube-dl.exe" `
    -OutFile "setup-youtube-dl.exe" `
    -DestinationPath "${HOME}\.bin\youtube-dl.exe"
}

# install sublime text
function Install-SublimeText {
  winget install `
    --id SublimeHQ.SublimeText.4 `
    --exact `
    --override "/SP- /SILENT /SUPPRESSMSGBOXES /TASKS=""contextentry"""
}

# install sql server management studio
function Install-SQLServerManagementStudio {
  winget install `
    --id Microsoft.SQLServerManagementStudio `
    --exact
}

# install azure data studio
function Install-AzureDataStudio {
  winget install `
    --id Microsoft.AzureDataStudio `
    --exact `
}

# configure git
function Configure-Git {
  New-SymbolicLink `
    -Path "${HOME}\.gitconfig" `
    -Value "${DOTFILES_INSTALL_DIR}\git-gitconfig"
}

# configure powershell
function Configure-PowerShell {
  New-SymbolicLink `
    -Path "${HOME}\Documents\PowerShell\Profile.ps1" `
    -Value "${DOTFILES_INSTALL_DIR}\powershell-profile.ps1"

  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"
  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"
  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "PowerShellGet\Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"
}

# configure vim
function Configure-Vim {
  New-SymbolicLink `
    -Path "${HOME}\.vimrc" `
    -Value "${DOTFILES_INSTALL_DIR}\vim-vimrc"

  if (-Not (Test-Path -Path "${HOME}/.vim/autoload")) {
    New-Item -ItemType Directory -Path "${HOME}\.vim\autoload"
  }

  Invoke-WebRequest `
    -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim `
    -OutFile "${HOME}\.vim\autoload\plug.vim"
}

# configure visual studio code
function Configure-VSCode {
  New-SymbolicLink `
    -Path "${HOME}\AppData\Roaming\Code\User\settings.json" `
    -Value "${DOTFILES_INSTALL_DIR}\vscode-settings.json"

  Get-Content -Path "${DOTFILES_INSTALL_DIR}\vscode-extensions.txt" | ForEach-Object { code --install-extension $_ }
}

# configure azure data studio
function Configure-AzureDataStudio {
  New-SymbolicLink `
    -Path "${HOME}\AppData\Roaming\azuredatastudio\User\settings.json" `
    -Value "${DOTFILES_INSTALL_DIR}\azuredatastudio-settings.json"
}

# configure windows terminal
function Configure-WindowsTerminal {
  New-SymbolicLink `
    -Path "${HOME}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
    -Value "${DOTFILES_INSTALL_DIR}\win-terminal-settings.json"
}

# configure sublime text
function Configure-SublimeText {
  New-SymbolicLink `
    -Path "${HOME}\AppData\Roaming\Sublime Text\Packages\User\Preferences.sublime-settings" `
    -Value "${DOTFILES_INSTALL_DIR}\sublime-preferences.sublime-settings"

  New-SymbolicLink `
    -Path "${HOME}\AppData\Roaming\Sublime Text\Packages\User\Package Control.sublime-settings" `
    -Value "${DOTFILES_INSTALL_DIR}\sublime-package-control.sublime-settings"

  if (-Not (Test-Path -Path "${HOME}\AppData\Roaming\Sublime Text\Installed Packages")) {
    New-Item -ItemType Directory -Path "${HOME}\AppData\Roaming\Sublime Text\Installed Packages"
  }

  Invoke-WebRequest `
    -Uri "https://packagecontrol.io/Package%20Control.sublime-package" `
    -Outfile "${HOME}\AppData\Roaming\Sublime Text\Installed Packages\Package Control.sublime-package"
}

# install essential apps
function Install-Apps {
  Install-7Zip
  Install-Chrome
  Install-Firefox
  Install-Office365

  Reload-Path
}

# install dev tools
function Install-DevTools {
  Install-GVim
  Install-Insomnia
  Install-VSCode

  Reload-Path

  Configure-Vim
  Configure-VSCode
}

# install work dev tools
function Install-WorkDevTools {
  Install-Node
  Install-NuGet
  Install-ScreenToGif
  Install-SQLServerManagementStudio
  Install-VSCommunity

  Reload-Path

  Configure-AzureDataStudio
}

# remove built-in windows 10/11 apps
function Remove-BuiltInApps {
  Get-AppxPackage 5A894077.McAfeeSecurity | Remove-AppxPackage
  Get-AppxPackage C27EB4BA.DropboxOEM | Remove-AppxPackage
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
  Get-AppxPackage PortraitDisplays.DellCinemaColor | Remove-AppxPackage
  Get-AppxPackage ScreenovateTechnologies.DellMobileConnect | Remove-AppxPackage
  Get-AppxPackage SpotifyAB.SpotifyMusic | Remove-AppxPackage
}

# update command prompt
function Update-CommandPrompt {
  Remove-ItemProperty -Path HKCU:\Console -Name *

  Set-ItemProperty -Path "HKCU:\Console" -Name "FaceName" -Value "Iosevka NF"
  Set-ItemProperty -Path "HKCU:\Console" -Name "FontFamily" -Value "54" -Type "DWord"
  Set-ItemProperty -Path "HKCU:\Console" -Name "FontSize" -Value "1179648" -Type "DWord"
  Set-ItemProperty -Path "HKCU:\Console" -Name "ScreenBufferSize" -Value "589889696" -Type "DWord"
  Set-ItemProperty -Path "HKCU:\Console" -Name "WindowSize" -Value "1966240" -Type "DWord"
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -Name "000" -Value "Iosevka NF"

  & $DOTFILES_INSTALL_DIR\colortool.exe --both $DOTFILES_INSTALL_DIR\colortool-snazzy.ini
}

# install fonts
function Install-Fonts {
  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem -Path "${DOTFILES_INSTALL_DIR}\*" -Include @("*.ttf", "*.ttc") | ForEach-Object { $Fonts.CopyHere($_.FullName) }
}
