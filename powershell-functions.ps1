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
  Install-App `
    -URL "https://www.7-zip.org/a/7z1900-x64.exe" `
    -OutFile "setup-7z.exe" `
    -Arguments @("/S")
}

# install chrome
function Install-Chrome {
  Install-App `
    -URL "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi" `
    -OutFile "setup-chrome.msi" `
    -Arguments @(
      "/passive"
      "/norestart"
      "/l*v ""setup-chrome.log"""
    )
}

# install edge
function Install-Edge {
  Install-App `
    -URL "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeStablePage&Channel=Stable&language=en" `
    -OutFile "setup-edge.exe" `
    -Arguments @()
}

# install firefox
function Install-Firefox {
  Install-App `
    -URL "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" `
    -OutFile "setup-firefox.exe" `
    -Arguments @("-ms")
}

# install vim
function Install-GVim {
  Install-PortableApp `
    -URL "https://github.com/vim/vim-win32-installer/releases/download/v8.2.2467/gvim_8.2.2467_x64.zip" `
    -OutFile "setup-gvim.zip" `
    -DestinationPath "${HOME}\.bin"

  Add-FolderToUserPath -Folder "${HOME}\.bin\vim\vim82"
}

# install git
function Install-Git {
  Install-App `
    -URL "https://github.com/git-for-windows/git/releases/download/v2.30.0.windows.1/Git-2.30.0-64-bit.exe" `
    -OutFile "setup-git.exe" `
    -Arguments @(
      "/SP-"
      "/SILENT"
      "/SUPPRESSMSGBOXES"
      "/COMPONENTS=""gitlfs,autoupdate"""
      "/LOG=""setup-git.log"""
    )
}

# install insomnia
function Install-Insomnia {
  Install-App `
    -URL "https://updates.insomnia.rest/downloads/windows/latest" `
    -OutFile "setup-insomnia.exe" `
    -Arguments @(
      "--silent"
    )
}

# install jabra direct
function Install-JabraDirect {
  Install-App `
    -URL "https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.exe" `
    -OutFile "setup-jabra-direct.exe" `
    -Arguments @(
      "/install"
      "/passive"
      "/norestart"
      "/log setup-jabra-direct.log"
    )
}

# install logitech capture
function Install-LogitechCapture {
  Install-App `
    -URL "https://download01.logi.com/web/ftp/pub/techsupport/capture/Capture_2.04.13.exe" `
    -OutFile "setup-logitech-capture.exe" `
    -Arguments @()
}

# install logitech options
function Install-LogitechOptions {
  Install-App `
    -URL "https://download01.logi.com/web/ftp/pub/techsupport/options/Options_8.36.86.exe" `
    -OutFile "setup-logitech-options.exe" `
    -Arguments @()
}

# install node
function Install-Node {
  Install-App `
    -URL "https://nodejs.org/dist/v13.14.0/node-v13.14.0-x64.msi" `
    -OutFile "setup-node.msi" `
    -Arguments @(
      "/passive"
      "/norestart"
      "/l*v ""setup-node.log"""
    )
}

# install powershell
function Install-PowerShell {
  Install-App `
    -URL "https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/PowerShell-7.1.4-win-x64.msi" `
    -OutFile "setup-powershell.msi" `
    -Arguments @(
      "/passive"
      "/norestart"
      "/l*v ""setup-powershell.log"""
      "ADD_PATH=1"
      "REGISTER_MANIFEST=1"
      "ENABLE_PSREMOTING=0"
      "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1"
    )
}

# install python
function Install-Python {
  Install-App `
    -URL "https://www.python.org/ftp/python/3.9.1/python-3.9.1-amd64.exe" `
    -OutFile "setup-python.exe" `
    -Arguments @(
      "/passive"
      "AssociateFiles=0"
      "Shortcuts=0"
      "PrependPath=1"
    )
}

# install svg explorer extension
function Install-SvgExplorerExtension {
  Install-App `
    -URL "https://github.com/tibold/svg-explorer-extension/releases/download/v1.1.0/svg_see_x64.exe" `
    -OutFile "setup-svg-explorer-extension.exe" `
    -Arguments @(
      "/SP-"
      "/SILENT"
      "/SUPPRESSMSGBOXES"
      "/TASKS="""""
      "/LOG=""setup-svg-explorer-extension.log"""
    )
}

# install visual studio code
function Install-VSCode {
  Install-App `
    -URL "https://aka.ms/win32-x64-user-stable" `
    -OutFile "setup-vscode.exe" `
    -Arguments @(
      "/SP-"
      "/SILENT"
      "/SUPPRESSMSGBOXES"
      "/TASKS=""addcontextmenufiles,addcontextmenufolders,addtopath"""
      "/LOG=""setup-vscode.log"""
    )
}

# install windirstat
function Install-WinDirStat {
  Install-App `
    -URL "https://ufpr.dl.sourceforge.net/project/windirstat/windirstat/1.1.2%20installer%20re-release%20%28more%20languages%21%29/windirstat1_1_2_setup.exe" `
    -OutFile "setup-windirstat.exe" `
    -Arguments @("/S")
}

# install office 365
function Install-Office365 {
  Install-App `
    -URL "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12130-20272.exe" `
    -OutFile "setup-office-deployment-tool.exe" `
    -Arguments @(
      "/extract:office-deployment-tool"
      "/passive"
      "/norestart"
    )

  & office-deployment-tool\setup.exe /download "${HOME}\.dotfiles\office-deployment-tool-office365.xml"
  & office-deployment-tool\setup.exe /configure "${HOME}\.dotfiles\office-deployment-tool-office365.xml"
}

# install typora
function Install-Typora {
  Install-App `
    -URL "https://typora.io/windows/typora-setup-x64.exe" `
    -OutFile "setup-typora.exe" `
    -Arguments @(
      "/SP-"
      "/SILENT"
      "/SUPPRESSMSGBOXES"
      "/TASKS="""""
      "/LOG=""setup-typora.log"""
    )
}

# install visual studio community
function Install-VSCommunity {
  Install-App `
    -URL "https://download.visualstudio.microsoft.com/download/pr/9b3476ff-6d0a-4ff8-956d-270147f21cd4/76e39c746d9e2fc3eadd003b5b11440bcf926f3948fb2df14d5938a1a8b2b32f/vs_Community.exe" `
    -OutFile "setup-vs-community.exe" `
    -Arguments @()
}

# install windows terminal
function Install-WindowsTerminal {
  Invoke-WebRequest `
    -Uri "https://github.com/microsoft/terminal/releases/download/v1.9.1942.0/Microsoft.WindowsTerminal_1.9.1942.0_8wekyb3d8bbwe.msixbundle" `
    -OutFile "setup-windows-terminal.msixbundle"

  if ($PSVersionTable.PSEdition -eq "Core") {
    Import-Module Appx -UseWindowsPowerShell
  } else {
    Import-Module Appx
  }

  Add-AppxPackage -Path "setup-windows-terminal.msixbundle"
}

# install screen to gif
function Install-ScreenToGif {
  Install-PortableApp `
    -URL "https://github.com/NickeManarin/ScreenToGif/releases/download/2.27.3/ScreenToGif.2.27.3.Portable.zip" `
    -OutFile "setup-screentogif.zip" `
    -DestinationPath "${HOME}\.bin"

  Create-Shortcut -Name "Screen To Gif" -Path "${HOME}\.bin\ScreenToGif.exe"
}

# install nuget
function Install-NuGet {
  Install-PortableApp `
    -URL "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" `
    -OutFile "setup-nuget.exe" `
    -DestinationPath "${HOME}\.bin\nuget.exe"
}

# install youtube-dl
function Install-YouTubeDL {
  Install-PortableApp `
    -URL "https://youtube-dl.org/downloads/latest/youtube-dl.exe" `
    -OutFile "setup-youtube-dl.exe" `
    -DestinationPath "${HOME}\.bin\youtube-dl.exe"
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
  & $env:PROGRAMFILES\PowerShell\7\pwsh.exe -Command "PowerShellGet\Install-Module -Name oh-my-posh -Scope CurrentUser -AllowPrerelease -Force -SkipPublisherCheck"
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
    -Path "${HOME}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json" `
    -Value "${DOTFILES_INSTALL_DIR}\win-terminal-profiles.json"
}

# install essential apps
function Install-Apps {
  Install-7Zip
  Install-Chrome
  Install-Firefox
  Install-Office365

  Reload-Path
}

# install portable apps
function Install-PortableApps {
  Install-ScreenToGif
  Install-YouTubeDL
}

# install dev tools
function Install-DevTools {
  Install-PowerShell
  Install-Node
  Install-GVim
  Install-VSCode
  Install-VSCommunity
  Install-WindowsTerminal
  Install-Insomnia
  Install-NuGet

  Reload-Path

  Configure-Git
  Configure-PowerShell
  Configure-GVim
  Configure-VSCode
  Configure-WindowsTerminal
  Configure-AzureDataStudio
}

# remove built-in windows 10 apps
function Remove-BuiltInApps {
  Get-AppxPackage 5A894077.McAfeeSecurity | Remove-AppxPackage
  Get-AppxPackage C27EB4BA.DropboxOEM | Remove-AppxPackage
  Get-AppxPackage DellInc.DellCustomerConnect | Remove-AppxPackage
  Get-AppxPackage DellInc.DellDigitalDelivery | Remove-AppxPackage
  Get-AppxPackage DellInc.PartnerPromo | Remove-AppxPackage
  Get-AppxPackage DolbyLaboratories.DolbyAccess | Remove-AppxPackage
  Get-AppxPackage DolbyLaboratories.DolbyVisionAccess | Remove-AppxPackage
  Get-AppxPackage PortraitDisplays.DellCinemaColor | Remove-AppxPackage
  Get-AppxPackage ScreenovateTechnologies.DellMobileConnect | Remove-AppxPackage
  Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage
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
  Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage
  Get-AppxPackage Microsoft.WindowsCamera | Remove-AppxPackage
  Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
  Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage
  Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage
  Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
  Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage
  Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
  Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage
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
function Install-DevFonts {
  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem -Path "${DOTFILES_INSTALL_DIR}\*" -Include @("*.ttf", "*.ttc") | ForEach-Object { $Fonts.CopyHere($_.FullName) }
}
