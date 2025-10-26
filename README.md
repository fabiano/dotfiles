# .dotfiles

## Windows 10/11

- Disable the SSH agent service: `Get-Service ssh-agent | Set-Service -StartupType Disabled -PassThru | Stop-Service`
- Install 1Password and enable the SSH agent
- Install winget

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-windows.ps1"))
```

## Fedora

- Install 1Password and enable the SSH agent

```bash
curl -O https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-fedora.sh
chmod +x setup-new-fedora.sh
./setup-new-fedora.sh
```
