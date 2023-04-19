# .dotfiles

## Windows 10

- Install Terminal
- Install winget

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-windows.ps1"))
```

## Windows 11

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-windows.ps1"))
```

## Mac OS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-macos.sh)"
```

## Ubuntu (WSL)

```bash
curl -O https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-wsl-ubuntu.sh
chmod +x setup-new-wsl-ubuntu.sh
./setup-new-wsl-ubuntu.sh
```
