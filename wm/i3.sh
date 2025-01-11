#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Window Manager"

PACKAGES=(
  i3
  picom
  feh
  dunst
  polybar
  lxappearance
  flameshot
  thunar
  rofi
  fastfetch
)

log_info "Installing i3 window manager and required packages..."
sudo dnf install -y "${PACKAGES[@]}"

log_info "Window manager installation complete"
