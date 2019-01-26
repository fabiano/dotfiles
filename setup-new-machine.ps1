#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Configure-EnvVars {
  [Environment]::SetEnvironmentVariable("GIT_SSH", "C:/Windows/System32/OpenSSH/ssh.exe", "User")
}

function Configure-CmdPrompt {
  .\colortool.exe --both colortool-snazzy.ini
}

function Configure-PowerShell {
  if (-Not (Test-Path "${env:PROGRAMFILES}\PowerShell\6\pwsh.exe")) {
    Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x64.msi" -Outfile "f-pwsh.msi" | Out-Null

    .\f-pwsh.msi /qn /norestart /l*v "f-pwsh.log" ADD_PATH=1 REGISTER_MANIFEST=1 ENABLE_PSREMOTING=0 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 | Out-Null

    Remove-Item f-pwsh.exe | Out-Null
  }

  New-SymbolicLink -Path "$HOME\Documents\PowerShell\Profile.ps1" -Value (Get-Item powershell-profile.ps1).FullName

  PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -AllowPrerelease -Force | Out-Null
  PowerShellGet\Install-Module -Name PSColor -Scope CurrentUser -AllowPrerelease -Force | Out-Null
}

function Configure-Git {
  if (-Not (Test-Path "${env:PROGRAMFILES}\Git\bin\git.exe")) {
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.19.0.windows.1/Git-2.19.0-64-bit.exe" -Outfile "f-git.exe" | Out-Null

    .\f-git.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /COMPONENTS="gitlfs,autoupdate" /LOG="f-git.log" | Out-Null

    Remove-Item f-git.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\.gitconfig -Value (Get-Item git-gitconfig).FullName
}

function Configure-Hyper {
  if (-Not (Test-Path "${env:LOCALAPPDATA}\hyper\Hyper.exe")) {
    Invoke-WebRequest -Uri "https://releases.hyper.is/download/win" -Outfile "f-hyper.exe" | Out-Null

    .\f-hyper.exe --silent | Out-Null

    Remove-Item f-hyper.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\.hyper.js -Value (Get-Item hyper.js).FullName

  hyper install hyper-snazzy | Out-Null
}

function Configure-Vim {
  if (-Not (Test-Path "${env:PROGRAMFILES(x86)}\Vim\vim81\vim.exe")) {
    Invoke-WebRequest -Uri "ftp://ftp.vim.org/pub/vim/pc/gvim81.exe" -Outfile "f-gvim.exe" | Out-Null

    .\f-gvim.exe | Out-Null

    Remove-Item f-gvim.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\.vimrc -Value (Get-Item vim-vimrc).FullName

  if (-Not (Test-Path $HOME/.vim/autoload)) {
    New-Item -ItemType Directory -Path $HOME/.vim/autoload | Out-Null
  }

  Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -Outfile $HOME/.vim/autoload/plug.vim | Out-Null

  vim -c "PlugInstall" -c "qa!"
}

function Configure-VsCode {
  if (-Not (Test-Path "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe")) {
    Invoke-WebRequest -Uri "https://aka.ms/win32-x64-user-stable" -Outfile "f-vscode.exe" | Out-Null

    .\f-vscode.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /TASKS="addcontextmenufiles,addcontextmenufolders,addtopath" /LOG="f-vscode.log" | Out-Null

    Remove-Item f-vscode.exe | Out-Null
  }

  New-SymbolicLink -Path $HOME\AppData\Roaming\Code\User\settings.json -Value (Get-Item vscode-settings.json).FullName

  code --install-extension coenraads.bracket-pair-colorizer | Out-Null
  code --install-extension dbaeumer.vscode-eslint | Out-Null
  code --install-extension dotjoshjohnson.xml | Out-Null
  code --install-extension ms-vscode.csharp | Out-Null
  code --install-extension robinbentley.sass-indented | Out-Null
}

function Copy-Fonts {
  New-Item -ItemType Directory -Path fonts | Out-Null

  Invoke-WebRequest -Uri "https://github.com/aosp-mirror/platform_frameworks_base/raw/master/data/fonts/DroidSansMono.ttf" -Outfile fonts\droid-sans-mono.ttf | Out-Null
  Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf" -Outfile fonts\firacode-regular.ttf | Out-Null

  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem fonts\*.ttf | %{ $Fonts.CopyHere($_.FullName) }

  Remove-Item -Recurse fonts | Out-Null
}

function New-SymbolicLink ($Path, $Value) {
  $Parent = Split-Path -Path $Path

  if (-Not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent | Out-Null
  }

  if (Test-Path $Path) {
    Remove-Item $Path | Out-Null
  }

  New-Item -ItemType SymbolicLink -Path $Path -Value $Value | Out-Null
}

Clear-Host

Write-Host "» Configure Environment Variables"

Configure-EnvVars

Write-Host "» Configure Command Prompt"

Configure-CmdPrompt

Write-Host "» Configure PowerShell"

Configure-PowerShell

Write-Host "» Configure Git"

Configure-Git

Write-Host "» Configure Hyper"

Configure-Hyper

Write-Host "» Configure Vim"

Configure-Vim

Write-Host "» Configure Visual Studio Code"

Configure-VsCode

Write-Host "» Copy Fonts"

Copy-Fonts

Write-Host "» Finished"
