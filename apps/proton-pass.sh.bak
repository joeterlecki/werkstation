#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Proton Pass"

log_info "Downloading Proton Pass..."
curl -L -o "/tmp/proton-pass.rpm" "https://proton.me/download/pass/linux/proton-pass-1.27.2-1.x86_64.rpm"

log_info "Installing Proton Pass..."
sudo dnf install -y "/tmp/proton-pass.rpm"

rm -f "/tmp/proton-pass.rpm"
log_info "Proton Pass installation complete"
