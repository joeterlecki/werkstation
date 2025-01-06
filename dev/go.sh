#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Golang"

GO_PATH='export PATH="$PATH:/usr/local/go/bin"'

LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go[0-9\.]*' | head -n 1)
DOWNLOAD_URL="https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz"

log_info "Downloading latest Go Version: ${LATEST_VERSION}..."
wget -q "$DOWNLOAD_URL" -O /tmp/go.tar.gz

log_info "Installing latest Go version: ${LATEST_VERSION}..."
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz

if ! grep -q "PATH=\"\$PATH:/usr/local/go/bin\"" "$HOME/.bashrc"; then
    log_info "Adding Go to PATH in bashrc..."
    echo "$GO_PATH" >> "$HOME/.bashrc"
else
    log_info "Go PATH already in .bashrc"
fi

if ! grep -q "PATH=\"\$PATH:/usr/local/go/bin\"" "$HOME/.zshrc"; then
    log_info "Adding Go to PATH in zshrc..."
    echo "$GO_PATH" >> "$HOME/.zshrc"
else
    log_info "Go PATH already in .zshrc"
fi

log_info "Cleaning up Go installation..."
rm /tmp/go.tar.gz

log_info "Golang installation complete"
