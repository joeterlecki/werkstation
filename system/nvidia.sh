#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Nvidia Drivers"

log_info "Checking installed VGA for NVIDIA..."
if lspci | grep -i nvidia > /dev/null; then
    log_warn "NVIDIA Card Detected..."

    log_info "Installing akmod and cuda x11 drivers..."
    sudo dnf install -y akmod-nvidia
    sudo dnf install -y xorg-x11-drv-nvidia-cuda

    log_info "Checking for existing blacklist..."
    if [ ! -f /etc/modprobe.d/blacklist-nouveau.conf ]; then
        log_warn "Blacklisting nouveau drivers..."
        echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
        echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
        
        log_warn "Regenerating initramfs..."
        sudo dracut --force
    else
        log_info "Nouveau blacklist already exists..."
    fi

   log_info "Installing mokutil for secureboot..."
   sudo dnf install -y mokutil
else
    log_warn "No Nvidia card detected..."
    log_warn "Skipping driver installation..."
    exit 0
fi

log_info "Nvida driver installation complete"

