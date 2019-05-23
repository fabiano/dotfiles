# functions
function Clear-History {
  # https://blogs.msdn.microsoft.com/stevelasker/2016/03/25/clear-history-powershell-doesnt-clear-the-history-3/
  Remove-Item (Get-PSReadlineOption).HistorySavePath
}

function X ($Name) {
  Get-ChildItem -Directory -Recurse -Depth 3 -Filter "$Name" -Path $HOME `
    | Select-Object -ExpandProperty FullName `
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

      "^## (?<branchName>\S+?)(\.\.\.(?<upstream>\S+))?$" {
        $branchName = $matches["branchName"]

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
    Write-Host -NoNewLine " ?$($changes.untracked)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " +$($changes.added)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " ~$($changes.modified)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " -$($changes.deleted)" -ForegroundColor DarkGray
    Write-Host -NoNewLine " !$($changes.unmerged)" -ForegroundColor DarkGray
  }

  Write-Host ""

  if ($env:HYPER -Eq "1") {
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

# alias
New-Alias -Name "~" -Value Home
New-Alias -Name ".." -Value MoveUp

# https://github.com/lzybkr/PSReadLine
Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
