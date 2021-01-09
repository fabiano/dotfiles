# .dotfiles

## Windows 10

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-win10.ps1"))
```

## Mac OS

```bash
curl -o- https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-macos.sh | bash
```
