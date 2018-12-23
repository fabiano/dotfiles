#!/bin/sh

# install homebrew
if test ! "$(which brew)";
then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install dependencies
brew tap homebrew/cask-fonts
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
brew cask install firefox
brew cask install font-fira-code
brew cask install google-chrome
brew cask install visual-studio-code
brew cleanup

# configure zsh
rm $HOME/.zshrc
ln -s $PWD/zsh-zshrc $HOME/.zshrc

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
ln -s $PWD/git-gitconfig $HOME/.gitconfig

# configure vim
rm $HOME/.vimrc
rm -rf $HOME/.vim
ln -s $PWD/vim-vimrc $HOME/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c 'PlugInstall' -c 'qa!'

# configure visual studio code
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s $PWD/vscode-settings.json $HOME/Library/Application\ Support/Code/User/settings.json
code --install-extension coenraads.bracket-pair-colorizer
code --install-extension dbaeumer.vscode-eslint
code --install-extension dotjoshjohnson.xml
code --install-extension ms-vscode.csharp
code --install-extension robinbentley.sass-indented

exit 0
