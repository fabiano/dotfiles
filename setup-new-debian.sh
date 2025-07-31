{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install apps
  sudo apt update
  sudo apt -y install bash-completion
  sudo apt -y install bat
  sudo apt -y install eza
  sudo apt -y install fonts-roboto
  sudo apt -y install git
  sudo apt -y install kitty
  sudo apt -y install vim
  sudo apt -y install zsh
  sudo apt -y install zsh-autosuggestions
  sudo apt -y install zsh-syntax-highlighting
  curl -sS https://starship.rs/install.sh | sh

  # remove unused apps
  sudo apt -y remove atril
  sudo apt -y remove cheese
  sudo apt -y remove evolution
  sudo apt -y remove exfalso
  sudo apt -y remove gnome-boxes
  sudo apt -y remove gnome-calendar
  sudo apt -y remove gnome-clocks
  sudo apt -y remove gnome-connections
  sudo apt -y remove gnome-contacts
  sudo apt -y remove gnome-games
  sudo apt -y remove gnome-maps
  sudo apt -y remove gnome-music
  sudo apt -y remove gnome-sound-recorder
  sudo apt -y remove gnome-tour
  sudo apt -y remove gnome-weather
  sudo apt -y remove mediawriter
  sudo apt -y remove mousepad
  sudo apt -y remove parole
  sudo apt -y remove quodlibet
  sudo apt -y remove rhythmbox
  sudo apt -y remove shotwell
  sudo apt -y remove simple-scan
  sudo apt -y remove totem
  sudo apt -y remove transmission-gtk
  sudo apt -y remove "libreoffice-*"
  sudo apt -y remove xsane
  sudo apt -y autoremove

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # create dotfiles
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.config/Code
  rm -rf $HOME/.config/helix
  rm -rf $HOME/.config/kitty
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc

  mkdir -p $HOME/.config/Code/User
  mkdir -p $HOME/.config/helix
  mkdir -p $HOME/.config/kitty

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/helix-config.toml $HOME/.config/helix/config.toml
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/.config/Code/User/settings.json
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # install plug
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # install fonts
  mkdir -p $HOME/.local/share/fonts
  cp $DOTFILES_INSTALL_DIR/font-iosevka-nerd-font.ttf $HOME/.local/share/fonts/iosevka-nerd-font.ttf
  cp $DOTFILES_INSTALL_DIR/font-iosevka-regular.ttf $HOME/.local/share/fonts/iosevka-regular.ttf
  cp $DOTFILES_INSTALL_DIR/font-iosevka-term-nerd-font.ttf $HOME/.local/share/fonts/iosevka-term-nerd-font.ttf
  cp $DOTFILES_INSTALL_DIR/font-iosevka-term-regular.ttf $HOME/.local/share/fonts/iosevka-term-regular.ttf

  # use roboto and iosevka as gnome default fonts
  gsettings set org.gnome.desktop.interface document-font-name 'Roboto 9'
  gsettings set org.gnome.desktop.interface font-name 'Roboto 9'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Iosevka 9'
  gsettings set org.gnome.desktop.interface font-hinting 'none'
  gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto 9'

  # change gnome interface settings
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.desktop.interface clock-format '24h'
  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface clock-show-seconds false
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.wm.keybindings switch-applications '[]'
  gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward '[]'
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 1
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.shell app-picker-layout "[]"

  # change power settings
  gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
  gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 30
  gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
  gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'
  gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'suspend'
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'

  # configure cedilha in gnome
  rm -rf $HOME/.XCompose
  cat > $HOME/.XCompose << EOF
<dead_acute> <c>     : "ç"
<dead_acute> <C>     : "Ç"
EOF
}
