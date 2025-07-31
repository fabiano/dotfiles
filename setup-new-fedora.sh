{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install apps
  sudo dnf -y upgrade
  sudo dnf -y copr enable atim/starship
  sudo dnf -y copr enable peterwu/iosevka
  sudo dnf -y install bash-completion
  sudo dnf -y install bat
  sudo dnf -y install eza
  sudo dnf -y install git
  sudo dnf -y install helix
  sudo dnf -y install iosevka-fonts
  sudo dnf -y install iosevka-term-fonts
  sudo dnf -y install kitty
  sudo dnf -y install starship
  sudo dnf -y install util-linux-user
  sudo dnf -y install vim-enhanced
  sudo dnf -y install zsh
  sudo dnf -y install zsh-autosuggestions
  sudo dnf -y install zsh-syntax-highlighting

  # install eza
  curl -L https://github.com/eza-community/eza/releases/download/v0.21.5/eza_x86_64-unknown-linux-gnu.zip -o eza.zip && unzip eza.zip && sudo mv eza /usr/local/bin/ && sudo chmod +x /usr/local/bin/eza && rm eza.zip

  # install visual studio code
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install -y code

  # remove unused apps
  sudo dnf -y remove gnome-boxes
  sudo dnf -y remove gnome-calendar
  sudo dnf -y remove gnome-clocks
  sudo dnf -y remove gnome-connections
  sudo dnf -y remove gnome-contacts
  sudo dnf -y remove gnome-maps
  sudo dnf -y remove gnome-tour
  sudo dnf -y remove gnome-weather
  sudo dnf -y remove mediawriter
  sudo dnf -y remove rhythmbox
  sudo dnf -y remove simple-scan
  sudo dnf -y remove totem
  sudo dnf -y autoremove

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # create dotfiles
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.config/Code
  rm -rf $HOME/.config/helix
  rm -rf $HOME/.config/kitty
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc

  mkdir -p $HOME/.config/Code/User
  mkdir -p $HOME/.config/helix
  mkdir -p $HOME/.config/kitty

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/helix-config.toml $HOME/.config/helix/config.toml
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/.config/Code/User/settings.json
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # install plug
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # install visual studio code extensions
  IFS=$'\r\n'; for line in `cat $DOTFILES_INSTALL_DIR/vscode-extensions.txt`; do code --install-extension ${line}; done

  # install fonts
  mkdir -p $HOME/.local/share/fonts
  cp $DOTFILES_INSTALL_DIR/font-iosevka-nerd-font.ttf $HOME/.local/share/fonts/iosevka-nerd-font.ttf
  cp $DOTFILES_INSTALL_DIR/font-iosevka-term-nerd-font.ttf $HOME/.local/share/fonts/iosevka-term-nerd-font.ttf

  # use roboto and iosevka as gnome default fonts
  gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
  gsettings set org.gnome.desktop.interface font-name 'Roboto 10'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Iosevka 10'
  gsettings set org.gnome.desktop.interface font-hinting 'none'
  gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto 10'

  # change gnome interface settings
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.desktop.interface clock-format '24h'
  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface clock-show-seconds false
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.wm.keybindings switch-applications '[]'
  gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward '[]'
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 1
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.shell app-picker-layout "[]"

  # change power settings
  gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
  gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 30
  gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
  gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'
  gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'suspend'
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'

  # set rpm as preferred format
  gsettings set org.gnome.software packaging-format-preference "['rpm', 'flatpak:fedora-testing', 'flatpak:fedora']"

  # configure login screen scale
  sudo cp $HOME/.config/monitors.xml /var/lib/gdm/.config/
  sudo chown gdm:gdm /var/lib/gdm/.config/monitors.xml
}
