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

  # install iosevka font
  sudo dnf copr enable peterwu/iosevka
  sudo dnf -y install iosevka-fonts
  sudo dnf -y install iosevka-term-fonts

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
