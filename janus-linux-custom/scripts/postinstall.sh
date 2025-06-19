#!/bin/bash
set -e

echo "🧠 Installing ShellGPT (TerminalGPT-like CLI)..."
if ! command -v sgpt &> /dev/null; then
    pip install --upgrade pip
    pip install shell-gpt
fi

echo "📦 Setting up OpenAI API key..."
mkdir -p ~/.config/shell_gpt
echo 'OPENAI_API_KEY="your-api-key-here"' > ~/.config/shell_gpt/.env

echo "💀 Adding BlackArch repository..."
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syu --noconfirm

echo "🛠️ Installing core BlackArch tools..."
sudo pacman -S --noconfirm --needed \
    nmap metasploit sqlmap john aircrack-ng hydra burpsuite

echo "✅ TerminalGPT and hacking tools installed!"
