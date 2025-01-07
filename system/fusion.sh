#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "RPM Fusion"

log_info "Enabling free rpm fusion repos..."
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

log_info "Enabling nonfree rpm fusion repos..."
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

log_info "Upgrading repos and refresh..."
sudo dnf upgrade --refresh

log_info "RPM Fusion repo installation complete"
