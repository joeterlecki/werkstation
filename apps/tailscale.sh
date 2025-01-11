#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Tailscale"

log_info "Installing Tailscale..."
sudo dnf-3 config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
sudo dnf install tailscale -y
sudo systemctl enable --now tailscaled

log_info "Tailscale installation complete"

