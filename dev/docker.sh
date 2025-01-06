#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Docker"

TEMP_DIR=$(mktemp -d)

log_info "Removing old docker installations if present..."
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine


log_info "Adding docker repo..."
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

log_info "Installing docker engine and tools..."

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
log_info "Enabling and starting Docker..."

sudo systemctl enable docker
sudo systemctl start docker

log_info "Adding user to docker group..."
sudo usermod -aG docker $USER

sudo rm -rf /tmp/tmp.*
log_info "Docker installation complete"
