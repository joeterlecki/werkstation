#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Docker"

if command -v docker &>/dev/null; then
    log_warn "Previous Docker installation found..."
    log_warn "Skipping installation"
    exit 0
else

    log_info "Removing docker installations if present..."
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

    log_info "Retrieving convienience script..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh

    log_info "Executing Docker installation script..."
    sudo sh /tmp/get-docker.sh

    log_info "Enabling and starting Docker..."
    sudo systemctl enable docker && sudo systemctl start docker
fi

log_info "Docker installation complete"
