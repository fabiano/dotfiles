{
  # dotfiles settings
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install apps
  sudo dnf -y upgrade
  sudo dnf -y install brightnessctl
  sudo dnf -y install kanshi
  sudo dnf -y install mako
  sudo dnf -y install niri --setopt=install_weak_deps=False
  sudo dnf -y install rofi
  sudo dnf -y install swaybg
  sudo dnf -y install swayidle
  sudo dnf -y install swaylock
  sudo dnf -y install waybar
  
  # remove unused apps
  sudo dnf -y remove rygel
  sudo dnf -y autoremove

  # hide apps that cannot be removed
  rm -rf $HOME/.local/share/applications
  mkdir -p $HOME/.local/share/applications

  echo -e "[Desktop Entry]\nHidden=true" > $HOME/.local/share/applications/rofi-theme-selector.desktop
  echo -e "[Desktop Entry]\nHidden=true" > $HOME/.local/share/applications/rofi.desktop

  # create dotfiles
  rm -rf $HOME/.config/kanshi
  rm -rf $HOME/.config/mako
  rm -rf $HOME/.config/niri
  rm -rf $HOME/.config/rofi
  rm -rf $HOME/.config/swaylock
  rm -rf $HOME/.config/waybar

  mkdir -p $HOME/.config/kanshi
  mkdir -p $HOME/.config/mako
  mkdir -p $HOME/.config/niri
  mkdir -p $HOME/.config/rofi
  mkdir -p $HOME/.config/swaylock
  mkdir -p $HOME/.config/waybar

  ln -s $DOTFILES_INSTALL_DIR/kanshi-config $HOME/.config/kanshi/config
  ln -s $DOTFILES_INSTALL_DIR/mako-config $HOME/.config/mako/config
  ln -s $DOTFILES_INSTALL_DIR/niri.kdl $HOME/.config/niri/config.kdl
  ln -s $DOTFILES_INSTALL_DIR/rofi-config.rasi $HOME/.config/rofi/config.rasi
  ln -s $DOTFILES_INSTALL_DIR/rofi-theme.rasi $HOME/.config/rofi/theme.rasi
  ln -s $DOTFILES_INSTALL_DIR/swaylock-config $HOME/.config/swaylock/config
  ln -s $DOTFILES_INSTALL_DIR/waybar-config $HOME/.config/waybar/config
  ln -s $DOTFILES_INSTALL_DIR/waybar-style.css $HOME/.config/waybar/style.css
}
