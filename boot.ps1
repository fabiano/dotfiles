function New-SymbolicLink ($Path, $Value) {
  $Parent = Split-Path -Path $Path

  if(-not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent
  }

  if(Test-Path $Path) {
    Remove-Item $Path
  }

  New-Item -ItemType SymbolicLink -Path $Path -Value $Value
}

function Configure-Git {
  New-SymbolicLink -Path $HOME\.gitconfig -Value (Get-Item git-gitconfig).FullName
}

function Configure-Hyper {
  New-SymbolicLink -Path $HOME\.hyper.js -Value (Get-Item hyper.js).FullName

  hyper install hyper-snazzy
}

function Configure-PowerShell {
  PowerShellGet\Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force

  New-SymbolicLink -Path $PROFILE -Value (Get-Item powershell-profile.ps1).FullName
}

function Configure-Vim {
  New-SymbolicLink -Path $HOME\.vimrc -Value (Get-Item vim-vimrc).FullName

  if(-not (Test-Path $HOME/.vim/autoload)) {
    New-Item -ItemType Directory -Path $HOME/.vim/autoload
  }

  Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -Outfile $HOME/.vim/autoload/plug.vim
  vim -c "PlugInstall" -c "qa!"
}

function Configure-VsCode {
  New-SymbolicLink -Path $HOME\AppData\Roaming\Code\User\settings.json -Value (Get-Item vscode-settings.json).FullName

  code --install-extension coenraads.bracket-pair-colorizer
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension dotjoshjohnson.xml
  code --install-extension ms-vscode.csharp
  code --install-extension robinbentley.sass-indented
}

function Copy-Fonts {
  $SA = New-Object -ComObject Shell.Application
  $Fonts = $SA.NameSpace(0x14)

  Get-ChildItem "fonts\*.ttf" | %{ $Fonts.CopyHere($_.FullName) }
}

Configure-Git
Configure-Hyper
Configure-PowerShell
Configure-Vim
Configure-VsCode
Copy-Fonts
