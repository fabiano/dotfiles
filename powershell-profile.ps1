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

  $status = git status --short --branch

  if ($?) {
    $changes = @{
      untracked = 0
      added     = 0
      modified  = 0
      deleted   = 0
      unmerged  = 0
    }

    switch -regex ($status) {
      "^## (No commits yet on|Initial commit on) (?<branchName>\S+)$" {
        $branchName = $matches["branchName"]

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
        $branchName = $matches["branchName"]
        $ahead = $matches["ahead"]
        $behind = $matches["behind"]

        continue
      }

      "^(?<index>.*) (?<filename>.*)$" {
        switch ($matches["index"].Trim()) {
          "??" { $changes.untracked += 1; break }
          "A"  { $changes.added     += 1; break }
          "M"  { $changes.modified  += 1; break }
          "R"  { $changes.modified  += 1; break }
          "C"  { $changes.modified  += 1; break }
          "D"  { $changes.deleted   += 1; break }
          "U"  { $changes.unmerged  += 1; break }
        }

        continue
      }
    }

    Write-Host -NoNewLine " $branchName" -ForegroundColor DarkGray

    if ($ahead -And $behind) {
      Write-Host -NoNewLine " $ahead↕$behind" -ForegroundColor DarkGray
    } elseif ($ahead) {
      Write-Host -NoNewLine " ↑$ahead" -ForegroundColor DarkGray
    } elseif ($behind) {
      Write-Host -NoNewLine " ↓$behind" -ForegroundColor DarkGray
    } else {
      Write-Host -NoNewLine " ≡" -ForegroundColor DarkGray
    }

    Write-Host -NoNewLine " ?$($changes.untracked)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " +$($changes.added)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " ~$($changes.modified)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " -$($changes.deleted)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " !$($changes.unmerged)" -ForegroundColor DarkGray
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

function Start-HttpServer ($Port) {
  & python -m http.server $Port
}

# alias
New-Alias -Name "~" -Value Home
New-Alias -Name ".." -Value MoveUp

# https://github.com/lzybkr/PSReadLine
Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
