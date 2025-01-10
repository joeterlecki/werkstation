#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Lazygit Installation"

log_info "Installing Lazygit..."
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y

log_info "Lazygit installation complete"
