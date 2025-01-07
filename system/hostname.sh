#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Hostname Configuration"

DESIRED_HOSTNAME="werkstation"
CURRENT_HOSTNAME=$(hostnamectl --static)

if [ "$CURRENT_HOSTNAME" != "$DESIRED_HOSTNAME" ]; then

    log_info "Setting the system hostname $DESIRED_HOSTNAME..."
    sudo hostnamectl set-hostname "werkstation"
else
  log_warn "Hostname already configured: $DESIRED_HOSTNAME..."
fi

log_info "Hostname setting complete"
