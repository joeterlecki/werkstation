#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "ZSH Shell Configuration"

log_info "Installing ZSH..."
sudo apt-get install zsh -y
zsh_path=$(command -v zsh)

log_info "Setting default shell to zsh"
sudo usermod -s "$zsh_path" "$USER"

log_info "Note: Shell change will take effect after next login"

log_info "Installing Oh My Zsh..."
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

log_info "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
log_info "Powerlevel10k installed successfully"

log_info "ZSH, Oh My Zsh, and Powerlevel10k setup complete"
