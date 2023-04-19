{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install dependencies
  sudo apt-get update
  sudo apt-get -y install bash-completion
  sudo apt-get -y install git
  sudo apt-get -y install vim
  sudo apt-get -y install zsh
  sudo apt-get -y install socat

  # configure ssh forwarding
  SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
  ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)

  if [[ $ALREADY_RUNNING != "0" ]]; then
      if [[ -S $SSH_AUTH_SOCK ]]; then
          rm $SSH_AUTH_SOCK
      fi

      (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
  fi

  ssh -T git@github.com

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
}
