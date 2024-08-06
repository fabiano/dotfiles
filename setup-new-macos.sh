{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install homebrew
  if test ! "$(which brew)";
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # install dependencies
  brew update
  brew upgrade
  brew install bat
  brew install bash
  brew install bash-completion@2
  brew install eza
  brew install git
  brew install helix
  brew install kitty
  brew install starship
  brew install vim
  brew install zsh
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install --cask font-iosevka
  brew install --cask font-iosevka-nerd-font
  brew install --cask font-iosevka-term-nerd-font
  brew install --cask visual-studio-code
  brew cleanup

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # add bash and zsh to shells file
  if ! grep -q /usr/local/bin/bash /etc/shells; then
    echo /usr/local/bin/bash | sudo tee -a /etc/shells
  fi

  if ! grep -q /usr/local/bin/zsh /etc/shells; then
    echo /usr/local/bin/zsh | sudo tee -a /etc/shells
  fi

  # set zsh as default shell
  chsh -s /usr/local/bin/zsh

  # create dotfiles
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.config/helix
  rm -rf $HOME/.config/kitty
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc
  rm -rf $HOME/Library/Application\ Support/Code

  mkdir -p $HOME/.config/helix
  mkdir -p $HOME/.config/kitty
  mkdir -p $HOME/Library/Application\ Support/Code/User

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/helix-config.toml $HOME/.config/helix/config.toml
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # install plug
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # install visual studio code extensions
  IFS=$'\r\n'; for line in `cat $DOTFILES_INSTALL_DIR/vscode-extensions.txt`; do code --install-extension ${line}; done
}
