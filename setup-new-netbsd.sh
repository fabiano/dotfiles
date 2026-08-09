{
  # dotfiles settings
  DOTFILES_REPOSITORY="https://github.com/fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install apps
  su root -c "pkgin -y update"
  su root -c "pkgin -y upgrade"
  su root -c "pkgin -y install bash"
  su root -c "pkgin -y install bash-completion"
  su root -c "pkgin -y install bat"
  su root -c "pkgin -y install emacs"
  su root -c "pkgin -y install eza"
  su root -c "pkgin -y install git"
  su root -c "pkgin -y install neovim"
  su root -c "pkgin -y install starship"
  su root -c "pkgin -y install vim"
  su root -c "pkgin -y install zsh"
  su root -c "pkgin -y install zsh-autosuggestions"
  su root -c "pkgin -y install zsh-syntax-highlighting"

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # create dotfiles
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.ctwmrc
  rm -rf $HOME/.emacs.d
  rm -rf $HOME/.config/bat
  rm -rf $HOME/.config/helix
  rm -rf $HOME/.config/kitty
  rm -rf $HOME/.config/nvim
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.Xresources
  rm -rf $HOME/.zshrc

  mkdir -p $HOME/.config/bat
  mkdir -p $HOME/.config/helix
  mkdir -p $HOME/.config/kitty
  mkdir -p $HOME/.config/nvim
  mkdir -p $HOME/.emacs.d

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/bat-config $HOME/.config/bat/config
  ln -s $DOTFILES_INSTALL_DIR/ctwmrc $HOME/.ctwmrc
  ln -s $DOTFILES_INSTALL_DIR/emacs-init.el $HOME/.emacs.d/init.el
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/helix-config.toml $HOME/.config/helix/config.toml
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf
  ln -s $DOTFILES_INSTALL_DIR/nvim-init.lua $HOME/.config/nvim/init.lua
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/Xresources $HOME/.Xresources
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/pkg/bin/zsh

  # install fonts
  mkdir -p $HOME/.local/share/fonts
  cp $DOTFILES_INSTALL_DIR/font-iosevka-nerd-font-regular.ttf $HOME/.local/share/fonts/iosevka-nerd-font-regular.ttf
  cp $DOTFILES_INSTALL_DIR/font-iosevka-term-nerd-font-regular.ttf $HOME/.local/share/fonts/iosevka-term-nerd-font-regular.ttf
  cp $DOTFILES_INSTALL_DIR/font-symbols-nerd-font-regular.ttf $HOME/.local/share/fonts/symbols-nerd-font-regular.ttf
  cp $DOTFILES_INSTALL_DIR/font-maple-mono-regular.ttf $HOME/.local/share/fonts/maple-mono-regular.ttf
  cp $DOTFILES_INSTALL_DIR/font-maple-mono-nerd-font-regular.ttf $HOME/.local/share/fonts/maple-mono-nerd-font-regular.ttf

  # install plug
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}
