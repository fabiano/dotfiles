{
  # dotfiles settings
  DOTFILES_REPOSITORY="git@github.com:fabiano/dotfiles.git"
  DOTFILES_INSTALL_DIR="$HOME/.dotfiles"

  # install apps
  sudo dnf -y upgrade
  sudo dnf -y copr enable atim/starship
  sudo dnf -y copr enable peterwu/iosevka
  sudo dnf -y install bash-completion
  sudo dnf -y install bat
  sudo dnf -y install git
  sudo dnf -y install google-roboto-fonts
  sudo dnf -y install helix
  sudo dnf -y install iosevka-fonts
  sudo dnf -y install iosevka-term-fonts
  sudo dnf -y install kitty
  sudo dnf -y install nautilus
  sudo dnf -y install starship
  sudo dnf -y install util-linux-user
  sudo dnf -y install vim-enhanced
  sudo dnf -y install zsh
  sudo dnf -y install zsh-autosuggestions
  sudo dnf -y install zsh-syntax-highlighting

  # install eza
  curl -L https://github.com/eza-community/eza/releases/download/v0.23.0/eza_x86_64-unknown-linux-gnu.zip -o eza.zip && unzip eza.zip && sudo mv eza /usr/local/bin/ && sudo chmod +x /usr/local/bin/eza && rm eza.zip

  # install visual studio code
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install -y code

  # remove unused apps
  sudo dnf -y remove foot
  sudo dnf -y remove mpv
  sudo dnf -y remove system-config-language
  sudo dnf -y remove system-config-printer
  sudo dnf -y remove Thunar
  sudo dnf -y remove xarchiver
  sudo dnf -y autoremove

  # clone repository
  rm -rf $DOTFILES_INSTALL_DIR
  git clone $DOTFILES_REPOSITORY $DOTFILES_INSTALL_DIR

  # create dotfiles
  rm -rf $HOME/.bash_profile
  rm -rf $HOME/.bashrc
  rm -rf $HOME/.config/Code
  rm -rf $HOME/.config/helix
  rm -rf $HOME/.config/kanshi
  rm -rf $HOME/.config/kitty
  rm -rf $HOME/.config/rofi
  rm -rf $HOME/.config/starship.toml
  rm -rf $HOME/.config/sway
  rm -rf $HOME/.config/swaylock
  rm -rf $HOME/.config/waybar
  rm -rf $HOME/.gitconfig
  rm -rf $HOME/.vimrc
  rm -rf $HOME/.zshrc

  mkdir -p $HOME/.config/Code/User
  mkdir -p $HOME/.config/helix
  mkdir -p $HOME/.config/kanshi
  mkdir -p $HOME/.config/kitty
  mkdir -p $HOME/.config/rofi
  mkdir -p $HOME/.config/sway
  mkdir -p $HOME/.config/swaylock
  mkdir -p $HOME/.config/waybar

  ln -s $DOTFILES_INSTALL_DIR/bash-bashprofile $HOME/.bash_profile
  ln -s $DOTFILES_INSTALL_DIR/bash-bashrc $HOME/.bashrc
  ln -s $DOTFILES_INSTALL_DIR/git-gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_INSTALL_DIR/helix-config.toml $HOME/.config/helix/config.toml
  ln -s $DOTFILES_INSTALL_DIR/kanshi-config $HOME/.config/kanshi/config
  ln -s $DOTFILES_INSTALL_DIR/kitty.conf $HOME/.config/kitty/kitty.conf
  ln -s $DOTFILES_INSTALL_DIR/rofi-config.rasi $HOME/.config/rofi/config.rasi
  ln -s $DOTFILES_INSTALL_DIR/rofi-theme.rasi $HOME/.config/rofi/theme.rasi
  ln -s $DOTFILES_INSTALL_DIR/starship.toml $HOME/.config/starship.toml
  ln -s $DOTFILES_INSTALL_DIR/sway-config $HOME/.config/sway/config
  ln -s $DOTFILES_INSTALL_DIR/swaylock-config $HOME/.config/swaylock/config
  ln -s $DOTFILES_INSTALL_DIR/vim-vimrc $HOME/.vimrc
  ln -s $DOTFILES_INSTALL_DIR/vscode-settings.json $HOME/.config/Code/User/settings.json
  ln -s $DOTFILES_INSTALL_DIR/waybar-config $HOME/.config/waybar/config
  ln -s $DOTFILES_INSTALL_DIR/waybar-style.css $HOME/.config/waybar/style.css
  ln -s $DOTFILES_INSTALL_DIR/zsh-zshrc $HOME/.zshrc

  # set zsh as default shell
  chsh -s /usr/bin/zsh

  # install plug
  rm -rf $HOME/.vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # install visual studio code extensions
  IFS=$'\r\n'; for line in `cat $DOTFILES_INSTALL_DIR/vscode-extensions.txt`; do code --install-extension ${line}; done

  # install fonts
  mkdir -p $HOME/.local/share/fonts
  cp $DOTFILES_INSTALL_DIR/font-iosevka-nerd-font.ttf $HOME/.local/share/fonts/iosevka-nerd-font.ttf
  cp $DOTFILES_INSTALL_DIR/font-iosevka-term-nerd-font.ttf $HOME/.local/share/fonts/iosevka-term-nerd-font.ttf

  # use roboto and iosevka as gnome default fonts
  gsettings set org.gnome.desktop.interface font-name 'Roboto 10'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Iosevka 10'
  gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
  gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto 10'

  # set font antialiasing and hinting
  gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
  gsettings set org.gnome.desktop.interface font-hinting 'full'

  # prefer dark mode
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  bash -c 'cat > $HOME/.config/gtk-3.0/settings.ini' << EOF
[Settings]
gtk-application-prefer-dark-theme=1
EOF

  bash -c 'cat > $HOME/.config/gtk-4.0/settings.ini' << EOF
[Settings]
gtk-application-prefer-dark-theme=1
EOF

  # fix electron blurriness on wayland
  cat > $HOME/.zprofile << EOF
export ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

  # enable kanshi service
  systemctl --user enable kanshi.service

  # change power key to suspend by default (requires restart)
  sudo mkdir -p /etc/systemd/logind.conf.d

  sudo bash -c 'cat > /etc/systemd/logind.conf.d/power-key.conf' << EOF
[Login]
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff
EOF

  # set sddm theme
  sudo mkdir -p /usr/share/sddm/themes/00-custom-theme
  sudo cp -r $DOTFILES_INSTALL_DIR/sddm-theme/* /usr/share/sddm/themes/00-custom-theme

  sudo bash -c 'cat > /etc/sddm.conf.d/custom-theme.conf' << EOF
[General]
GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=DP-1=2;DP-2=2

[Theme]
Current=00-custom-theme
EOF
}
