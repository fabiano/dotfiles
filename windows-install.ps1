#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Host "» Download files"

Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.19.0.windows.1/Git-2.19.0-64-bit.exe" -Outfile "f-git.exe" | Out-Null
Invoke-WebRequest -Uri "https://releases.hyper.is/download/win" -Outfile "f-hyper.exe" | Out-Null
Invoke-WebRequest -Uri "ftp://ftp.vim.org/pub/vim/pc/gvim81.exe" -Outfile "f-gvim.exe" | Out-Null
Invoke-WebRequest -Uri "https://aka.ms/win32-x64-user-stable" -Outfile "f-vscode.exe" | Out-Null

Write-Host "» Install Git"

.\f-git.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /COMPONENTS="gitlfs,autoupdate" /LOG="f-git.log" | Out-Null

Remove-Item f-git.exe | Out-Null

Write-Host "» Install Vim"

.\f-gvim.exe | Out-Null

Remove-Item f-gvim.exe | Out-Null

Write-Host "» Install Hyper"

.\f-hyper.exe --silent | Out-Null

Remove-Item f-hyper.exe | Out-Null

Write-Host "» Install Visual Studio Code"

.\f-vscode.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /TASKS="addcontextmenufiles,addcontextmenufolders,addtopath" /LOG="f-vscode.log" | Out-Null

Remove-Item f-vscode.exe | Out-Null

Write-Host "» Finished"
