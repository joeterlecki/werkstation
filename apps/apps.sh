#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Applications"

log_info "Installing kitty terminal..."
sudo dnf install kitty -y

log_info "Installing brave..."
sudo dnf-3 config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install brave-browser -y

log_info "Installing Tailscale..."
sudo dnf-3 config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
sudo dnf install tailscale -y
sudo systemctl enable --now tailscaled

log_info "Applications installation complete"
