#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Golang"
GO_PATH="export PATH='$PATH:/usr/local/go/bin'"

LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go[0-9\.]*' | head -n 1)
DOWNLOAD_URL="https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz"

log_info "Downloading latest Go Version: ${LATEST_VERSION}..."
wget -q "$DOWNLOAD_URL" -O /tmp/go.tar.gz

log_info "Installing latest Go version: ${LATEST_VERSION}..."
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz

log_info "Adding go to path"

if ! grep -q "$GO_PATH" ~/.bashrc; then
    echo "$GO_PATH" >>~/.bashrc
    log_info "Added Go PATH to .bashrc"
else
    log_info "Go PATH already in .bashrc"
fi

if ! grep -q "$GO_PATH" ~/.zshrc; then
    echo "$GO_PATH" >>~/.zshrc
    log_info "Added Go PATH to .zshrc"
else
    log_info "Go PATH already in .zshrc"
fi

log_info "Cleaning up Go installation..."
rm /tmp/go.tar.gz

log_info "Golang installation complete"
