#!/bin/bash
set -e
if [[ ! -d dot_config ]]; then
  echo "🌐 Cloning repo..."
  git clone https://github.com/YOUR_USERNAME/your-distro.git ~/your-distro-tmp
  cd ~/your-distro-tmp
  exec ./install.sh
fi
echo "🚀 Starting installation..."
install_packages() {
  echo "📦 Installing packages..."
  sudo pacman -Syu --noconfirm --needed \
    hyprland waybar rofi kitty dunst sddm \
    networkmanager pipewire wireplumber wl-clipboard \
    grim slurp swappy unzip wget git base-devel jq curl
}
enable_services() {
  echo "🔌 Enabling services..."
  sudo systemctl enable NetworkManager
  sudo systemctl enable sddm
}
copy_configs() {
  echo "💾 Copying configs..."
  mkdir -p ~/.config
  cp -r dot_config/* ~/.config/
}
set_wallpaper() {
  echo "🖼️ Setting wallpaper..."
  mkdir -p ~/Pictures
  cp wallpapers/default.jpg ~/Pictures/wallpaper.jpg
}
run_postinstall() {
  if [[ -f scripts/postinstall.sh ]]; then
    echo "🛠️ Running postinstall..."
    chmod +x scripts/postinstall.sh
    ./scripts/postinstall.sh
  fi
}
install_packages
enable_services
copy_configs
set_wallpaper
run_postinstall
echo "✅ Done! Reboot and login to Hyprland."
