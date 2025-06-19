#!/bin/bash

# Janus Linux Installation Script
# Arch base with Hyprland, TerminalGPT, and hacking tools

set -e

# Configuration
USER_NAME=janus
HOST_NAME=janus-linux

# 1. Update and install base Arch system
pacstrap /mnt base base-devel linux linux-firmware vim git sudo networkmanager zsh

# 2. Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 3. Chroot into system
arch-chroot /mnt /bin/bash <<EOF

# Set timezone, locale, hostname
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$HOST_NAME" > /etc/hostname

# Add user and set password
useradd -m -G wheel -s /bin/zsh $USER_NAME
echo "$USER_NAME:password" | chpasswd
echo "root:password" | chpasswd

# Enable sudo for wheel group
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Enable services
systemctl enable NetworkManager

# 4. Setup dotfiles
cd /home/$USER_NAME
git clone https://github.com/yourusername/janus-dotfiles.git
cp -r janus-dotfiles/.config .config
cp janus-dotfiles/.zshrc .

chown -R $USER_NAME:$USER_NAME .config .zshrc

# 5. Install Hyprland & deps
pacman -S --noconfirm hyprland waybar kitty rofi neovim thunar wl-clipboard xdg-desktop-portal-hyprland

# 6. TerminalGPT (AI CLI Tool)
pip install terminalgpt
echo 'export OPENAI_API_KEY="your-api-key-here"' >> /home/$USER_NAME/.zshrc

# 7. Install hacking tools
pacman -S --noconfirm nmap wireshark-qt aircrack-ng metasploit bettercap john hashcat nikto gobuster

# 8. Done
EOF

echo "✅ Janus Linux base install complete. Reboot and log in as $USER_NAME."
