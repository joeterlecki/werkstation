#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Slack"

log_info "Installing slack..."
sudo dnf install -y "https://downloads.slack-edge.com/desktop-releases/linux/x64/4.41.105/slack-4.41.105-0.1.el8.x86_64.rpm"

log_info "Slack installation finished"
