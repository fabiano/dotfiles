{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install homebrew
  if test ! "$(which brew)";
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # install dependencies
  brew tap homebrew/cask-fonts
  brew tap homebrew/cask-versions
  brew update
  brew upgrade
  brew install bash
  brew install bash-completion@2
  brew install git
  brew install node
  brew install rust
  brew install vim
  brew install youtube-dl
  brew install zsh
  brew install zsh-syntax-highlighting
  brew cask install 1password
  brew cask install android-file-transfer
  brew cask install caffeine
  brew cask install firefox
  brew cask install font-fira-code
  brew cask install google-chrome
  brew cask install sublime-text
  brew cask install the-unarchiver
  brew cask install transmission
  brew cask install tuxera-ntfs
  brew cask install visual-studio-code
  brew cleanup

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # configure bash
  rm -f $HOME/.bashrc
  rm -f $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile

  if ! grep -q /usr/local/bin/bash /etc/shells; then
    echo /usr/local/bin/bash | sudo tee -a /etc/shells
  fi

  # configure zsh
  rm -f $HOME/.zshrc
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  if ! grep -q /usr/local/bin/zsh /etc/shells; then
    echo /usr/local/bin/zsh | sudo tee -a /etc/shells
  fi

  # set zsh as default shell
  chsh -s /usr/local/bin/zsh

  # configure pure
  rm -rf $HOME/.pure
  git clone https://github.com/sindresorhus/pure.git $HOME/.pure
  ln -s $HOME/.pure/pure.zsh $HOME/.pure/prompt_pure_setup
  ln -s $HOME/.pure/async.zsh $HOME/.pure/async

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
  rm -rf $HOME/Library/Application\ Support/Code
  mkdir -p $HOME/Library/Application\ Support/Code/User
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  IFS=$'\r\n'; for line in `cat $DOTFILES_INSTALL_DIR/vscode-extensions.txt`; do code --install-extension ${line}; done

  # configure sublime text
  rm -rf $HOME/Library/Application\ Support/Sublime\ Text\ 3
  mkdir -p $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  ln -s $DOTFILES_INSTALL_DIR/sublime-preferences.sublime-settings $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
  ln -s $DOTFILES_INSTALL_DIR/sublime-package-control.sublime-settings $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Package\ Control.sublime-settings
  curl -fLo $HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package --create-dirs https://packagecontrol.io/Package%20Control.sublime-package

  # π
  mkdir -p $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/π
  ln -s $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/π $HOME/π
}
