#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function New-SymbolicLink ($Path, $Value) {
  $Parent = Split-Path -Path $Path

  if(-not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent | Out-Null
  }

  if(Test-Path $Path) {
    Remove-Item $Path | Out-Null
  }

  New-Item -ItemType SymbolicLink -Path $Path -Value $Value | Out-Null
}

function Configure-EnvVars() {
  [Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "C:/Windows/System32/OpenSSH/ssh.exe", "User")
}

function Configure-Git {
  New-SymbolicLink -Path $HOME\.gitconfig -Value (Get-Item git-gitconfig).FullName
}

function Configure-Hyper {
  New-SymbolicLink -Path $HOME\.hyper.js -Value (Get-Item hyper.js).FullName

  hyper install hyper-snazzy | Out-Null
}

function Configure-PowerShell {
  New-SymbolicLink -Path $PROFILE -Value (Get-Item powershell-profile.ps1).FullName

  PowerShellGet\Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force | Out-Null
  PowerShellGet\Install-Module PSColor -Scope CurrentUser -AllowPrerelease -Force | Out-Null
}

function Configure-Vim {
  New-SymbolicLink -Path $HOME\.vimrc -Value (Get-Item vim-vimrc).FullName

  if(-not (Test-Path $HOME/.vim/autoload)) {
    New-Item -ItemType Directory -Path $HOME/.vim/autoload | Out-Null
  }

  Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -Outfile $HOME/.vim/autoload/plug.vim | Out-Null
  vim -c "PlugInstall" -c "qa!"
}

function Configure-VsCode {
  New-SymbolicLink -Path $HOME\AppData\Roaming\Code\User\settings.json -Value (Get-Item vscode-settings.json).FullName

  code --install-extension coenraads.bracket-pair-colorizer | Out-Null
  code --install-extension dbaeumer.vscode-eslint | Out-Null
  code --install-extension dotjoshjohnson.xml | Out-Null
  code --install-extension ms-vscode.csharp | Out-Null
  code --install-extension robinbentley.sass-indented | Out-Null
}

function Copy-Fonts {
  Invoke-WebRequest -Uri "https://github.com/aosp-mirror/platform_frameworks_base/raw/master/data/fonts/DroidSansMono.ttf" -Outfile fonts\droid-sans-mono.ttf | Out-Null
  Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf" -Outfile fonts\firacode-regular.ttf | Out-Null

  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem fonts\*.ttf | %{ $Fonts.CopyHere($_.FullName) }

  Remove-Item -Recurse fonts | Out-Null
}

Clear-Host

Write-Host "» Configure Environment Variables"

Configure-EnvVars

Write-Host "» Configure Git"

Configure-Git

Write-Host "» Configure Hyper"

Configure-Hyper

Write-Host "» Configure PowerShell"

Configure-PowerShell

Write-Host "» Configure Vim"

Configure-Vim

Write-Host "» Configure Visual Studio Code"

Configure-VsCode

Write-Host "» Copy Fonts"

Copy-Fonts

Write-Host "» Finished"
