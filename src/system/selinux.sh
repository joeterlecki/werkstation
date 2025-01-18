#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "SELinux"

log_info "Disabling SELinux..."
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

log_info "SELinux disabled"
