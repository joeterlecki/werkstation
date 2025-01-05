#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Docker"

if command -v docker &>/dev/null; then
    log_warn "Previous Docker installation found..."
    exit 0
fi

TEMP_DIR=$(mktemp -d)
if [[ ! "$TEMP_DIR" || ! -d "$TEMP_DIR" ]]; then
    log_error "Failed to create temporary directory"
    exit 1
fi

log_info "Removing old docker installations if present..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg
done

curl -fsSL https://get.docker.com -o "${TEMP_DIR}/get-docker.sh"
sudo sh "${TEMP_DIR}/get-docker.sh"

log_info "Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

sudo rm -rf /tmp/tmp.*
log_info "Docker installation complete"