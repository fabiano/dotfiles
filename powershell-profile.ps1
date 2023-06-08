# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "${HOME}\.dotfiles"

# import helper functions module
Import-Module -Name "${DOTFILES_INSTALL_DIR}\powershell-functions.ps1"

# clear history
function Clear-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

# move to folder
function X ($Name) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter $Name -Path $HOME `
    | Select-Object -ExpandProperty FullName -First 1 `
    | Set-Location
}

# move to home folder
function Home {
  Set-Location -Path $HOME
}

# move to parent folder
function Move-Up {
  Set-Location -Path ..
}

# start http server on the current folder
function Start-HttpServer ($Port) {
  & npx http-server . -p $Port -c-1 -o
}

# reload profile
function Reload-Profile {
  . "${DOTFILES_INSTALL_DIR}\powershell-profile.ps1"
}

# caffeine
function Start-Caffeine {
  Add-Type -AssemblyName System.Windows.Forms

  while (1 -eq 1 ) {
    $message = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

    Write-Host ${message}: Pressing F16

    [System.Windows.Forms.SendKeys]::SendWait("{F16}")

    Start-Sleep -Seconds 59
  }
}

# kill process
function Kill-Process ($Name) {
  taskkill /IM $Name /F
}

# remove us keyboard
function Remove-UsKeyboard {
  $List = Get-WinUserLanguageList

  $List `
    | Where-Object -Property LanguageTag -eq "en-US" `
    | ForEach-Object { $_.InputMethodTips.Add("0409:00000409") }

  Set-WinUserLanguageList $List -Force

  $List `
    | Where-Object -Property LanguageTag -eq "en-US" `
    | ForEach-Object { $_.InputMethodTips.Remove("0409:00000409") }

  Set-WinUserLanguageList $List -Force
}

# fzf
function Run-Fzf {
  fzf.exe --preview "bat --number --color=always {}" $args
}

# bat
function Run-Bat {
  bat.exe --color=always --decorations=always $args
}

# alias
New-Alias -Name "~" -Value Home -Force
New-Alias -Name ".." -Value Move-Up -Force
New-Alias -Name "g" -Value git -Force
New-Alias -Name "d" -Value dotnet -Force
New-Alias -Name "fzf" -Value Run-Fzf -Force
New-Alias -Name "f" -Value Run-Fzf -Force
New-Alias -Name "bat" -Value Run-Bat -Force
New-Alias -Name "cat" -Value Run-Bat -Force

# set directory background color
$PSStyle.FileInfo.Directory = $PSStyle.Foreground.Blue

# enable psreadline
# https://github.com/lzybkr/PSReadLine
Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# start starship
$ENV:STARSHIP_CONFIG = "${HOME}\starship.toml"

function Invoke-Starship-PreCommand {
  $Path = $PWD.path.replace($HOME, "~")

  $Host.UI.Write("`e]0;${Path}`a")
}

Invoke-Expression (&starship init powershell)
