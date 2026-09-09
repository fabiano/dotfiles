# .dotfiles

## Fedora

1. Generate an SSH key for the GitHub CLI:

   ```sh
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github
   ```

2. Add an alias for it in `~/.ssh/config`:

   ```
   Host github.com
     HostName github.com
     User fabiano
     IdentityFile ~/.ssh/id_ed25519_github
     IdentitiesOnly yes
   ```

3. Download and run the setup script:

   ```bash
   curl -O https://raw.githubusercontent.com/fabiano/dotfiles/main/setup-new-fedora.sh
   chmod +x setup-new-fedora.sh
   ./setup-new-fedora.sh
   ```

   When the script installs the GitHub CLI, choose to authenticate over SSH and select the key created in step 1.
