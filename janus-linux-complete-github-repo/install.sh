#!/bin/bash

set -e

echo "Installing dependencies..."
sudo pacman -Syu --noconfirm \
  hyprland waybar rofi kitty \
  wl-clipboard xdg-desktop-portal-hyprland \
  ttf-font-awesome neovim

echo "Setting up dotfiles..."
mkdir -p ~/.config
cp -r .config/* ~/.config/

echo "Copying wallpapers and scripts..."
mkdir -p ~/Pictures ~/bin
cp -r wallpapers/* ~/Pictures/ 2>/dev/null || true
cp -r scripts/* ~/bin/
chmod +x ~/bin/*

echo "Setup complete. Launch Hyprland and enjoy!"
