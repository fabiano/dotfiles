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
  . "${PROFILE}"
}

# kill process
function Kill-Process ($Name) {
  taskkill /IM $Name /F
}

# alias
New-Alias -Name "~" -Value Home -Force
New-Alias -Name ".." -Value Move-Up -Force
New-Alias -Name "g" -Value git -Force
New-Alias -Name "d" -Value dotnet -Force

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
