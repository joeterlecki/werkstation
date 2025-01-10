#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Bottom System Monitor"

log_info "Installing Bottom..."
sudo dnf copr enable atim/bottom -y
sudo dnf install bottom -y

log_info "Bottom installation complete"
