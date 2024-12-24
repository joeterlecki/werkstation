#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"
log_section "Golang"

GO_PATH='export PATH="$PATH:/usr/local/go/bin"'

log_info "Checking for previous installation..."
if command -v go &> /dev/null; then
    log_warn "Current Go version: $(go version)"
    log_warn "Please use native Go updates via go install"
    
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
    exit 0
else
    log_info "Calculating latest GO version..."
    LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go[0-9\.]*' | head -n 1)
    DOWNLOAD_URL="https://go.dev/dl/${LATEST_VERSION}.linux-${ARCH}.tar.gz"
    log_info "Downloading latest Go Version: ${LATEST_VERSION}..."
    wget -q "$DOWNLOAD_URL" -O /tmp/go.tar.gz
    log_info "Installing latest Go version: ${LATEST_VERSION}..."
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    log_info "Cleaning up Go installation..."
    rm /tmp/go.tar.gz
    
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
fi

log_info "Golang installation complete"