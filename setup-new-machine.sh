# curl -o- https://raw.githubusercontent.com/fabiano/dotfiles/master/setup-new-machine.sh | bash
{
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
  brew install bash-completion
  brew install git
  brew install go
  brew install vim
  brew install youtube-dl
  brew install zsh
  brew install zsh-syntax-highlighting
  brew cask install caffeine
  brew cask install dotnet-sdk-preview
  brew cask install firefox
  brew cask install font-fira-code
  brew cask install google-chrome
  brew cask install the-unarchiver
  brew cask install tuxera-ntfs
  brew cask install visual-studio-code
  brew cleanup

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone git@github.com:fabiano/dotfiles.git $DOTFILES_INSTALL_DIR

  # configure zsh
  rm $HOME/.zshrc
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  if ! grep -q /usr/local/bin/zsh /etc/shells; then
    echo /usr/local/bin/zsh | sudo tee -a /etc/shells
  fi

  chsh -s /usr/local/bin/zsh

  # configure pure
  rm -rf $HOME/.pure
  git clone https://github.com/sindresorhus/pure.git $HOME/.pure
  ln -s $HOME/.pure/pure.zsh $HOME/.pure/prompt_pure_setup
  ln -s $HOME/.pure/async.zsh $HOME/.pure/async

  # configure git
  rm $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig

  # configure vim
  rm $HOME/.vimrc
  rm -rf $HOME/.vim
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c 'PlugInstall' -c 'qa!'

  # configure visual studio code
  rm ~/Library/Application\ Support/Code/User/settings.json
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  IFS=$'\r\n'; for line in `cat vscode-extensions.txt`; do code --install-extension ${line}; done
}
