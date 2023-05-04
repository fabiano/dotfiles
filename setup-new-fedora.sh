{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install dependencies
  sudo dnf upgrade
  sudo dnf -y install bash-completion
  sudo dnf -y install git
  sudo dnf -y install vim-enhanced
  sudo dnf -y install zsh
  sudo dnf -y install zsh-autosuggestions
  sudo dnf -y install zsh-syntax-highlighting
  sudo dnf -y install util-linux-user
  sudo dnf -y install kitty

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # configure bash
  rm -f $HOME/.bashrc
  rm -f $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile

  # configure zsh
  rm -f $HOME/.zshrc
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # configure pure
  rm -rf $HOME/.pure
  git clone https://github.com/sindresorhus/pure.git $HOME/.pure

  # configure git
  rm -f $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig

  # configure vim
  rm -f $HOME/.vimrc
  rm -rf $HOME/.vim
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c 'PlugInstall' -c 'qa!'

  # configure visual studio code
  rm -rf $HOME/.config/Code
  mkdir -p $HOME/.config/Code/User
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/.config/Code/User/settings.json
  IFS=$'\r\n'; for line in `cat $DOTFILES_INSTALL_DIR/vscode-extensions.txt`; do code --install-extension ${line}; done

  # configure kitty
  rm -rf $HOME/.config/kitty
  mkdir -p $HOME/.config/kitty
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf

  # install iosevka font
  sudo dnf copr enable peterwu/iosevka
  sudo dnf -y install iosevka-fonts
  sudo dnf -y install iosevka-term-fonts

  # use iosevka as gnome default font
  gsettings set org.gnome.desktop.interface document-font-name 'Iosevka 10'
  gsettings set org.gnome.desktop.interface font-name 'Iosevka 10'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Iosevka 10'
  gsettings set org.gnome.desktop.interface font-hinting 'none'
  gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Iosevka 10'

  # change gnome interface settings
  gsettings set org.gnome.desktop.interface clock-format '24h'
  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface clock-show-seconds false
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
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
  chown gdm:gdm /var/lib/gdm/.config/monitors.xml
}
