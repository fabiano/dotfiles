{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install dependencies
  sudo dnf -y upgrade
  sudo dnf -y copr enable atim/starship
  sudo dnf -y copr enable peterwu/iosevka
  sudo dnf -y install bash-completion
  sudo dnf -y install bat
  sudo dnf -y install exa
  sudo dnf -y install fzf
  sudo dnf -y install git
  sudo dnf -y install iosevka-fonts
  sudo dnf -y install iosevka-term-fonts
  sudo dnf -y install kitty
  sudo dnf -y install neofetch
  sudo dnf -y install starship
  sudo dnf -y install util-linux-user
  sudo dnf -y install vim-enhanced
  sudo dnf -y install zsh
  sudo dnf -y install zsh-autosuggestions
  sudo dnf -y install zsh-syntax-highlighting

  # install visual studio code
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install -y code

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # configure dot files
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.config/Code
  rm -rf $HOME/.config/kitty
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc

  mkdir -p $HOME/.config/Code/User
  mkdir -p $HOME/.config/kitty

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/.config/Code/User/settings.json
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # install vim plugins
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c 'PlugInstall' -c 'qa!'

  # install visual studio code extensions
  IFS=$'\r\n'; for line in `cat $DOTFILES_INSTALL_DIR/vscode-extensions.txt`; do code --install-extension ${line}; done

  # install sf pro display font
  mkdir -p $HOME/.local/share/fonts
  cp $DOTFILES_INSTALL_DIR/font-sf-pro-display-regular.otf $HOME/.local/share/fonts/sf-pro-display-regular.otf

  # use iosevka as gnome default font
  gsettings set org.gnome.desktop.interface document-font-name 'SF Pro Display 10'
  gsettings set org.gnome.desktop.interface font-name 'SF Pro Display 10'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Iosevka 10'
  gsettings set org.gnome.desktop.interface font-hinting 'none'
  gsettings set org.gnome.desktop.wm.preferences titlebar-font 'SF Pro Display 10'

  # change gnome interface settings
  gsettings set org.gnome.desktop.interface cursor-size 32
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

  # set the locale and keyboard layout
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"

  sudo localectl set-locale LANG=en_US.UTF-8
  sudo localectl set-keymap us-alt-intl

  # configure cedilha in gnome
  rm $HOME/.XCompose
  cat > $HOME/.XCompose << EOF
<dead_acute> <c>     : "ç"
<dead_acute> <C>     : "Ç"
EOF

  # configure login screen scale
  sudo cp $HOME/.config/monitors.xml /var/lib/gdm/.config/
  sudo chown gdm:gdm /var/lib/gdm/.config/monitors.xml
}
