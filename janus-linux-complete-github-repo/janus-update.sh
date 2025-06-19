#!/bin/bash
# janus-update.sh - Auto update script for Janus Linux
# Updates system, AI models, and dotfiles

set -e

log() {
  echo "[janus-update] $1"
}

log "Starting Janus Linux update..."

# Update system packages
log "Updating system packages..."
sudo pacman -Syu --noconfirm

# Update AUR packages if yay is installed
if command -v yay &> /dev/null; then
  log "Updating AUR packages..."
  yay -Syu --noconfirm
fi

# Update dotfiles (assumes Git repo in ~/dotfiles)
if [ -d "$HOME/dotfiles/.git" ]; then
  log "Updating dotfiles repository..."
  cd ~/dotfiles && git pull
fi

# Update AI models via Ollama
if command -v ollama &> /dev/null; then
  log "Checking for Ollama model updates..."
  ollama pull llama3
fi

log "All updates complete."
exit 0
