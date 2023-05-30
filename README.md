# .dotfiles

## Windows 10/11

- Generate a new SSH key and add to the GitHub account
- Install winget

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-windows.ps1"))
```

## Ubuntu

- Generate a new SSH key and add to the GitHub account

```bash
curl -O https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-ubuntu.sh
chmod +x setup-new-ubuntu.sh
./setup-new-ubuntu.sh
```

## Fedora

- Generate a new SSH key and add to the GitHub account

```bash
curl -O https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-fedora.sh
chmod +x setup-new-fedora.sh
./setup-new-fedora.sh
```
