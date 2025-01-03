#!/usr/bin/env bash
source "$(dirname "$0")/../utils/log.sh"

log_section "Golang"
GO_PATH='export PATH="$PATH:/usr/local/go/bin"'

check_go_path() {
    if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
        log_warn "Go binary not found in current PATH"
    else
        log_info "Go binary found in current PATH"
    fi

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
}

if command -v go &>/dev/null; then
    log_warn "Current Go version: $(go version)"
    log_warn "Please use native Go updates via go install"
    check_go_path
    exit 0
fi

LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go[0-9\.]*' | head -n 1)
DOWNLOAD_URL="https://go.dev/dl/${LATEST_VERSION}.linux-${ARCH}.tar.gz"

log_info "Downloading latest Go Version: ${LATEST_VERSION}..."
wget -q "$DOWNLOAD_URL" -O /tmp/go.tar.gz

log_info "Installing latest Go version: ${LATEST_VERSION}..."
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz

log_info "Cleaning up Go installation..."
rm /tmp/go.tar.gz

check_go_path
log_info "Golang installation complete"
