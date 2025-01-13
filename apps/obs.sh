#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"  

log_section "OBS Studio"

log_info "Installing obs via dnf..."
sudo dnf install -y obs-studio

log_info "OBS Studio installation complete..."
