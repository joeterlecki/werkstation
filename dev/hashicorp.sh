#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Hashicorp"

log_info "Adding Hashicorp repository..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update

log_info "Installing Hashicorp tools..."
sudo apt-get install -y terraform packer

log_info "Hashicorp tools installation complete"
