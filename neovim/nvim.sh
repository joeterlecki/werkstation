#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "AstroNvim"

NVIM_CONFIG_PATH="$HOME/.config/nvim"
ASTRONVIM_TEMPLATE="https://github.com/AstroNvim/template"

if ! command -v nvim &>/dev/null; then
    log_info "Neovim not found. Installing via apt..."
    sudo apt-get update
    sudo apt-get install neovim -y
    log_info "Neovim installation complete"
fi

if [ -d "$NVIM_CONFIG_PATH" ]; then
    log_warn "Neovim configuration already exists. Skipping installation..."
    exit 0
fi

log_info "Cloning AstroNvim template..."
git clone --depth 1 "$ASTRONVIM_TEMPLATE" "$NVIM_CONFIG_PATH"

log_info "Removing git repository..."
rm -rf "$NVIM_CONFIG_PATH/.git"

log_info "Neovim and AstroNVIM installation complete..."
