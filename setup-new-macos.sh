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
  brew tap homebrew/cask-drivers
  brew tap homebrew/cask-fonts
  brew tap homebrew/cask-versions
  brew update
  brew upgrade
  brew install bash
  brew install bash-completion@2
  brew install git
  brew install node
  brew install vim
  brew install youtube-dl
  brew install zsh
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install --cask 1password
  brew install --cask caffeine
  brew install --cask firefox
  brew install --cask font-fira-code
  brew install --cask font-iosevka
  brew install --cask forklift
  brew install --cask google-chrome
  brew install --cask iterm2
  brew install --cask jabra-direct
  brew install --cask microsoft-edge
  brew install --cask the-unarchiver
  brew install --cask tuxera-ntfs
  brew install --cask visual-studio-code
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
}
