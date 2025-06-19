iso_name="janus-linux"
iso_label="JANUS_$(date +%Y%m)"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
arch="x86_64"
work_dir="work"
out_dir="out"

bootmodes=('bios.syslinux.mbr' 'uefi-boot.vmlinuz.efi')

file_permissions=(
  ["ai/aicmd.sh"]="0:0:755"
  ["configs/post_install.sh"]="0:0:755"
)
