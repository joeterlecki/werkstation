#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "AstroNvim"

NVIM_CONFIG_PATH="$HOME/.config/nvim"

if [ -d "$NVIM_CONFIG_PATH" ] && [ "$(ls -A $NVIM_CONFIG_PATH)" ]; then
    log_info "Neovim configuration already exists at $NVIM_CONFIG_PATH"
    exit 0
fi

ASTRONVIM_TEMPLATE="https://github.com/AstroNvim/template"
sudo dnf install neovim -y
log_info "Cloning AstroNvim template..."
git clone --depth 1 "$ASTRONVIM_TEMPLATE" "$NVIM_CONFIG_PATH"
log_info "Removing git repository..."
rm -rf "$NVIM_CONFIG_PATH/.git"
log_info "Neovim and AstroNVIM installation complete..."
