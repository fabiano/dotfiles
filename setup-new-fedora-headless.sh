{
  # dotfiles settings
  DOTFILES_REPOSITORY="dotfiles"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install apps
  sudo dnf -y upgrade
  sudo dnf -y copr enable atim/starship
  sudo dnf -y install bash-completion
  sudo dnf -y install bat
  sudo dnf -y install emacs
  sudo dnf -y install eza
  sudo dnf -y install git
  sudo dnf -y install gh
  sudo dnf -y install neovim
  sudo dnf -y install starship
  sudo dnf -y install util-linux-user
  sudo dnf -y install vim-enhanced
  sudo dnf -y install zsh
  sudo dnf -y install zsh-autosuggestions
  sudo dnf -y install zsh-syntax-highlighting

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR

  gh auth login
  gh repo clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # create dotfiles
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.emacs.d
  rm -rf $HOME/.config/bat
  rm -rf $HOME/.config/helix
  rm -rf $HOME/.config/nvim
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc

  mkdir -p $HOME/.config/bat
  mkdir -p $HOME/.config/helix
  mkdir -p $HOME/.config/nvim
  mkdir -p $HOME/.emacs.d

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/bat-config $HOME/.config/bat/config
  ln -s $DOTFILES_INSTALL_DIR/emacs-init.el $HOME/.emacs.d/init.el
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/helix-config.toml $HOME/.config/helix/config.toml
  ln -s $DOTFILES_INSTALL_DIR/nvim-init.lua $HOME/.config/nvim/init.lua
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # install plug
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}
