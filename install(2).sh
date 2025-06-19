#!/usr/bin/env bash
# Janus Linux Installer for Arch Linux
# Installs Arch base, Hyprland desktop, TerminalGPT, dotfiles, and penetration-testing tools.
# WARNING: This will erase TARGET_DISK. Adjust variables before running.

set -euo pipefail

# === Configuration ===
TARGET_DISK="/dev/sda"            # Disk to wipe and install onto
HOSTNAME="janus"                  # Hostname for the new system
TIMEZONE="Europe/London"          # Timezone identifier
LOCALE="en_GB.UTF-8"              # System locale
KEYMAP="uk"                       # Console keymap
USERNAME="janus"                  # Non-root user
USER_PASSWORD="password"          # Non-root user password (hashed login prompt recommended)
ROOT_PASSWORD="password"          # Root password
DOTFILES_REPO="https://github.com/janus-linux/dotfiles.git"

# Partition layout (GPT, UEFI):
#   1: EFI System (512M)
#   2: Linux root (remaining)
EFI_PART="${TARGET_DISK}1"
ROOT_PART="${TARGET_DISK}2"

# === 1. Disk Partitioning ===
echo "[1/11] Partitioning ${TARGET_DISK}"
sgdisk --zap-all "${TARGET_DISK}"
sgdisk -n1:0:+512M -t1:ef00 -c1:"EFI System" "${TARGET_DISK}"
sgdisk -n2:0:0 -t2:8300 -c2:"Linux Root" "${TARGET_DISK}"

# === 2. Format Filesystems ===
echo "[2/11] Formatting partitions"
mkfs.fat -F32 "${EFI_PART}"
mkfs.ext4 -F "${ROOT_PART}"

# === 3. Mount Points ===
echo "[3/11] Mounting filesystems"
mount "${ROOT_PART}" /mnt
mkdir -p /mnt/boot
mount "${EFI_PART}" /mnt/boot

# === 4. Base System Install ===
echo "[4/11] Installing base packages"
pacstrap /mnt base linux linux-firmware sudo vim git networkmanager

# === 5. fstab Generation ===
echo "[5/11] Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# === 6. System Configuration ===
echo "[6/11] Configuring system (chroot)"
arch-chroot /mnt bash <<EOF
set -e
# Timezone & clock
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc

# Locale
echo "${LOCALE}" > /etc/locale.conf
sed -i "s/^#${LOCALE}/${LOCALE}/" /etc/locale.gen
locale-gen

# Keyboard
echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf

# Hostname & hosts
echo "${HOSTNAME}" > /etc/hostname
cat <<HOSTS > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS

# Set root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Enable NetworkManager
systemctl enable NetworkManager

# Create user and grant sudo
useradd -m -G wheel -s /bin/bash ${USERNAME}
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
EOF

# === 7. Install AUR Helper (yay) ===
echo "[7/11] Installing yay AUR helper"
arch-chroot /mnt bash <<'EOF'
set -e
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
enable_nocheck=$(grep -q "^#makedepends" PKGBUILD && echo "" || echo "")
makepkg -si --noconfirm
EOF

# === 8. Hyprland Desktop Setup ===
echo "[8/11] Installing Hyprland and Wayland components"
arch-chroot /mnt pacman -S --noconfirm hyprland waybar wofi foot alacritty starship grim slurp xdg-desktop-portal-wlr

# === 9. TerminalGPT Installation ===
echo "[9/11] Installing TerminalGPT"
arch-chroot /mnt pacman -S --noconfirm python pip
arch-chroot /mnt pip install terminal-gpt

# === 10. Hacking Tools ===
echo "[10/11] Installing security tools"
arch-chroot /mnt pacman -S --noconfirm nmap wireshark-qt aircrack-ng john hydra sqlmap nikto hashcat metasploit

# === 11. Dotfiles Deployment ===
echo "[11/11] Cloning and applying dotfiles"
arch-chroot /mnt bash <<EOF
set -e
su - ${USERNAME} -c \
  "git clone ${DOTFILES_REPO} ~/dotfiles && cd ~/dotfiles && chmod +x install.sh && ./install.sh"
EOF

echo "\nJanus Linux installation complete! Reboot when ready."
