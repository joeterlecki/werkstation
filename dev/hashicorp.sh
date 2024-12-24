#!/usr/bin/env bash

source "$(dirname "${0}")/../utils/log.sh"

log_section "Hashicorp"

log_info "Retrieving Hashicorp GPG key..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

log_info "Setting deb source for Hashicorp archive..."
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

log_info "Updating APT sources..."
sudo apt-get update

log_info "Installing Hashicorp tools: terraform, packer"
sudo apt-get install terraform packer -y

log_info "Hashicorp tools installation complete"
