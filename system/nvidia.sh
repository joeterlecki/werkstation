#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Nvidia Drivers"

sudo dnf install -y akmod-nvidia
sudo dnf install -y xorg-x11-drv-nvidia-cuda

log_warn "Blacklisting nouveau drivers..."
log_info "Checking for existing blacklist..."
if [ ! -f /etc/modprobe.d/blacklist-nouveau.conf ]; then
    echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
    echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
    
    log_warn "Regenerating initramfs..."
    sudo dracut --force
fi

log_info "Installing mokutil for secureboot..."
sudo dnf install -y mokutil

log_info "Nvida driver installation complete"

