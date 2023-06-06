{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install dependencies
  sudo apt-get update
  sudo apt-get -y install bash-completion
  sudo apt-get -y install bat
  sudo apt-get -y install exa
  sudo apt-get -y install fzf
  sudo apt-get -y install git
  sudo apt-get -y install neofetch
  sudo apt-get -y install vim
  sudo apt-get -y install zsh
  sudo apt-get -y install zsh-autosuggestions
  sudo apt-get -y install zsh-syntax-highlighting
  curl -sS https://starship.rs/install.sh | sh

  # configure wls ssh forwarding
  if [[ $(grep -i Microsoft /proc/version) ]]; then
    sudo apt-get -y install socat

    export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

    ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)

    if [[ $ALREADY_RUNNING != "0" ]]; then
        if [[ -S $SSH_AUTH_SOCK ]]; then
            rm -rf $SSH_AUTH_SOCK
        fi

        (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
    fi
  fi

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # configure dot files
  mkdir -p $HOME/.config
  
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # install vim plugins
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c 'PlugInstall' -c 'qa!'
}
