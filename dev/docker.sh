#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Docker"

log_info "Installing docker repositories..."
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
                  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
                  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update

log_info "Installing docker via apt..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

log_info "Enabling and starting docker service..."
sudo systemctl enable docker
sudo systemctl start docker

log_info "Adding user to docker group..."
sudo usermod -aG docker $USER

log_info "Docker installation complete"
