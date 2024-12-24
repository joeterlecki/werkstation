#!/usr/bin/env bash
source "$(dirname "${0}")/../utils/log.sh"

log_section "Hashicorp"

HASHICORP_TOOLS=(terraform packer)

for tool in "${HASHICORP_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        INSTALL_REQUIRED=true
        break
    fi
done

if [ -z "$INSTALL_REQUIRED" ]; then
    log_warn "Hashicorp tools already installed"
    exit 0
fi

if ! [ -f /etc/apt/sources.list.d/hashicorp.list ]; then
    log_info "Adding Hashicorp repository..."
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update
else
    log_warn "Hashicorp repository already configured"
fi

log_info "Installing Hashicorp tools..."
sudo apt-get install -y "${HASHICORP_TOOLS[@]}"

log_info "Hashicorp tools installation complete"