# dotfiles settings
$DOTFILES_REPOSITORY = "git@github.com:fabiano/dotfiles.git"
$DOTFILES_INSTALL_DIR = "$HOME\.dotfiles"

# import helper functions module
Import-Module -Name $DOTFILES_INSTALL_DIR\powershell-functions.ps1

# functions
function Clear-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

function X ($Name) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter "$Name" -Path $HOME `
    | Select-Object -ExpandProperty FullName -First 1 `
    | Set-Location
}

function Prompt {
  Write-Host ""
  Write-Host $PWD -NoNewLine -ForegroundColor DarkBlue

  $Status = git status --short --branch

  if ($?) {
    $Changes = @{
      Untracked = 0
      Added     = 0
      Modified  = 0
      Deleted   = 0
      Unmerged  = 0
    }

    switch -regex ($Status) {
      "^## (No commits yet on|Initial commit on) (?<branchName>\S+)$" {
        $BranchName = $matches["branchName"]

        continue
      }

      <#
        ## master
        ## master...origin/master
        ## master...origin/master [ahead 1]
        ## master...origin/master [behind 1]
        ## master...origin/master [ahead 1, behind 1]
        ## feature/ping
        ## feature/ping...origin/feature/ping
        ## feature/ping...origin/feature/ping [ahead 1]
        ## feature/ping...origin/feature/ping [behind 1]
        ## feature/ping...origin/feature/ping [ahead 1, behind 1]
      #>
      "^##\s(?<branchName>\S+?)(\.{3}(?<upstream>\S+?))?(\s\[(ahead\s(?<ahead>\d*))?((,\s)?behind\s(?<behind>\d*))?\])?$" {
        $BranchName = $matches["branchName"]
        $Ahead = $matches["ahead"]
        $Behind = $matches["behind"]

        continue
      }

      "^(?<index>.*) (?<filename>.*)$" {
        switch ($matches["index"].Trim()) {
          "??" { $Changes.Untracked += 1; break }
          "A"  { $Changes.Added     += 1; break }
          "M"  { $Changes.Modified  += 1; break }
          "R"  { $Changes.Modified  += 1; break }
          "C"  { $Changes.Modified  += 1; break }
          "D"  { $Changes.Deleted   += 1; break }
          "U"  { $Changes.Unmerged  += 1; break }
        }

        continue
      }
    }

    Write-Host -NoNewLine " $BranchName" -ForegroundColor DarkGray

    if ($Ahead -And $Behind) {
      Write-Host -NoNewLine " $Ahead↕$Behind" -ForegroundColor DarkGray
    } elseif ($Ahead) {
      Write-Host -NoNewLine " ↑$Ahead" -ForegroundColor DarkGray
    } elseif ($Behind) {
      Write-Host -NoNewLine " ↓$Behind" -ForegroundColor DarkGray
    } else {
      Write-Host -NoNewLine " ≡" -ForegroundColor DarkGray
    }

    Write-Host -NoNewLine " ?$($Changes.Untracked)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " +$($Changes.Added)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " ~$($Changes.Modified)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " -$($Changes.Deleted)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " !$($Changes.Unmerged)" -ForegroundColor DarkGray
  }

  Write-Host ""

  if ($env:HYPER -Eq "1" -Or $env:WT_SESSION) {
    Write-Host "❯❯" -NoNewLine -ForegroundColor DarkMagenta
  }
  else {
    Write-Host "»" -NoNewLine -ForegroundColor DarkMagenta
  }

  return " "
}

function Home {
  Set-Location -Path $HOME
}

function MoveUp {
  Set-Location -Path ..
}

function MoveTo($Path) {
  Set-Location -Path $Path

  $host.UI.RawUI.WindowTitle = Get-Location
}

function Start-HttpServer ($Port) {
  & npx http-server . -p $Port -c-1 -o
}

# alias
New-Alias -Name "~" -Value Home
New-Alias -Name ".." -Value MoveUp
New-Alias -Name "g" -Value git

Set-Alias -Name "cd" -Value MoveTo -Option AllScope

# https://github.com/lzybkr/PSReadLine
Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
