#!/bin/bash

# Set up XDG_CONFIG_HOME if not set
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# List of dotfiles to symlink
DOTFILES=(".zshrc" ".tmux.conf")
CONFIG_DIRS=("nvim" "starship" "alacritty" "bat")

# Symlink top-level dotfiles
for file in "${DOTFILES[@]}"; do
  ln -sf "$PWD/$file" "$HOME/$file"
  echo "Linked $file -> $HOME/$file"
done

# Symlink config directories
mkdir -p "$CONFIG_HOME"
for dir in "${CONFIG_DIRS[@]}"; do
  ln -sf "$PWD/.config/$dir" "$CONFIG_HOME/$dir"
  echo "Linked config: $dir -> $CONFIG_HOME/$dir"
done

echo "✅ Dotfiles installed successfully!"
