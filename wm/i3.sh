#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Window Manager"

log_info "Installing i3 window manager and required packages..."
sudo dnf install i3 picom feh polybar dunst lxappearance flameshot -y

log_info "Window manager installation complete"
