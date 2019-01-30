#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Set-EnvVars {
  [Environment]::SetEnvironmentVariable("GIT_SSH", "C:/Windows/System32/OpenSSH/ssh.exe", "User")
}

function Start-SshAgentService {
  Set-Service -Name ssh-agent -StartupType Automatic -Status Running
}

function Set-CmdPrompt {
  .\colortool.exe --both colortool-snazzy.ini
}

function Install-PowerShell {
  if (-Not (Test-Path -Path "${env:PROGRAMFILES}\PowerShell\6\pwsh.exe")) {
    Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x64.msi" -Outfile "f-pwsh.msi" | Out-Null

    .\f-pwsh.msi /qn /norestart /l*v "f-pwsh.log" ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 | Out-Null

    Remove-Item -Path f-pwsh.exe | Out-Null
  }

  New-SymbolicLink -Path "$HOME\Documents\PowerShell\Profile.ps1" -Value (Get-Item powershell-profile.ps1).FullName

  PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -AllowPrerelease -Force | Out-Null
  PowerShellGet\Install-Module -Name PSColor -Scope CurrentUser -AllowPrerelease -Force | Out-Null
}

function Install-Git {
  if (-Not (Test-Path -Path "${env:PROGRAMFILES}\Git\bin\git.exe")) {
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.19.0.windows.1/Git-2.19.0-64-bit.exe" -Outfile "f-git.exe" | Out-Null

    .\f-git.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /COMPONENTS="gitlfs,autoupdate" /LOG="f-git.log" | Out-Null

    Remove-Item -Path f-git.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\.gitconfig -Value (Get-Item git-gitconfig).FullName
}

function Install-Hyper {
  if (-Not (Test-Path -Path "${env:LOCALAPPDATA}\hyper\Hyper.exe")) {
    Invoke-WebRequest -Uri "https://releases.hyper.is/download/win" -Outfile "f-hyper.exe" | Out-Null

    .\f-hyper.exe --silent | Out-Null

    Remove-Item -Path f-hyper.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\.hyper.js -Value (Get-Item hyper.js).FullName

  hyper install hyper-snazzy | Out-Null
}

function Install-Vim {
  if (-Not (Test-Path -Path "${env:PROGRAMFILES(x86)}\Vim\vim81\vim.exe")) {
    Invoke-WebRequest -Uri "ftp://ftp.vim.org/pub/vim/pc/gvim81.exe" -Outfile "f-gvim.exe" | Out-Null

    .\f-gvim.exe | Out-Null

    Remove-Item -Path f-gvim.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\.vimrc -Value (Get-Item vim-vimrc).FullName

  if (-Not (Test-Path $HOME/.vim/autoload)) {
    New-Item -ItemType Directory -Path $HOME/.vim/autoload | Out-Null
  }

  Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -Outfile $HOME/.vim/autoload/plug.vim | Out-Null

  vim -c "PlugInstall" -c "qa!"
}

function Install-VsCode {
  if (-Not (Test-Path -Path "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe")) {
    Invoke-WebRequest -Uri "https://aka.ms/win32-x64-user-stable" -Outfile "f-vscode.exe" | Out-Null

    .\f-vscode.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /TASKS="addcontextmenufiles,addcontextmenufolders,addtopath" /LOG="f-vscode.log" | Out-Null

    Remove-Item -Path f-vscode.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\AppData\Roaming\Code\User\settings.json -Value (Get-Item vscode-settings.json).FullName

  Get-Content -Path "vscode-extensions.txt" | ForEach-Object { code --install-extension $_ }
}

function Copy-Fonts {
  New-Item -ItemType Directory -Path fonts | Out-Null

  Invoke-WebRequest -Uri "https://github.com/aosp-mirror/platform_frameworks_base/raw/master/data/fonts/DroidSansMono.ttf" -Outfile fonts\droid-sans-mono.ttf | Out-Null
  Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf" -Outfile fonts\firacode-regular.ttf | Out-Null

  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem -Path fonts\*.ttf | ForEach-Object { $Fonts.CopyHere($_.FullName) }

  Remove-Item -Path fonts -Recurse | Out-Null
}

function New-SymbolicLink ($Path, $Value) {
  $Parent = Split-Path -Path $Path

  if (-Not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent | Out-Null
  }

  if (Test-Path $Path) {
    Remove-Item -Path $Path | Out-Null
  }

  New-Item -ItemType SymbolicLink -Path $Path -Value $Value | Out-Null
}

Clear-Host

Write-Host "» Set Environment Variables"

Set-EnvVars

Write-Host "» Start SSH Agent service"

Start-SshAgentService

Write-Host "» Set Command Prompt"

Set-CmdPrompt

Write-Host "» Install PowerShell"

Install-PowerShell

Write-Host "» Install Git"

Install-Git

Write-Host "» Install Hyper"

Install-Hyper

Write-Host "» Install Vim"

Install-Vim

Write-Host "» Install Visual Studio Code"

Install-VsCode

Write-Host "» Copy Fonts"

Copy-Fonts

Write-Host "» Finished"
