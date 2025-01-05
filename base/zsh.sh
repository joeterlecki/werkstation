#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "ZSH Shell Configuration"

if grep -q "^$USER.*zsh$" /etc/passwd; then
    is_current_shell_zsh=true
else
    is_current_shell_zsh=false
fi

if ! command -v zsh &>/dev/null || ! $is_current_shell_zsh; then
    log_info "Installing ZSH..."
    sudo apt-get update
    sudo apt-get install -y zsh
    zsh_path=$(command -v zsh)
    if ! $is_current_shell_zsh; then
        log_info "Setting ZSH as default shell..."
        sudo usermod -s "$zsh_path" "$USER"
        log_info "Note: Shell change will take effect after next login"
    fi
else
    log_warn "ZSH already installed and set as default shell..."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    if curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh; then
        log_info "Oh My Zsh installed successfully"
    else
        log_error "Oh My Zsh installation failed"
        exit 1
    fi
else
    log_warn "Oh My Zsh is already installed"
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    log_info "Installing Powerlevel10k theme..."
    if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"; then
        log_info "Powerlevel10k installed successfully"
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

        echo '# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi' | cat - "$HOME/.zshrc" >temp && mv temp "$HOME/.zshrc"

        echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >>"$HOME/.zshrc"

        log_info "Powerlevel10k configuration added to .zshrc"

        log_info "Creating p10k.zsh config..."
    else
        log_error "Powerlevel10k installation failed"
        exit 1
    fi
else
    log_warn "Powerlevel10k is already installed"
fi

log_info "Checking $HOME/.zshrc..."
if [[ -s "$HOME/.zshrc" ]]; then
    log_warn "$HOME/.zshrc exists and not empty"
else
    log_info "$HOME/.zshrc does not exist, creating..."
    touch "$HOME"/.zshrc
    echo "# ~/.zshrc configuration file" >"$HOME"/.zshrc
fi

if [ -f "$(dirname "$0")/p10k.zsh" ]; then
    log_info "Copying p10k configuration file..."
    if cp "$(dirname "$0")/dotfiles/p10k.zsh" "$HOME/.p10k.zsh"; then
        log_info "p10k.zsh configuration copied successfully"
    else
        log_error "Failed to copy p10k.zsh configuration"
        exit 1
    fi
fi

AUTO_SUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$AUTO_SUGGESTIONS_DIR" ]; then
    log_info "Installing zsh-autosuggestions..."
    if git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTO_SUGGESTIONS_DIR"; then
        log_info "zsh-autosuggestions installed successfully"
    else
        log_error "zsh-autosuggestions installation failed"
        exit 1
    fi
else
    log_warn "zsh-autosuggestions is already installed"
fi

SYNTAX_HIGHLIGHT_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$SYNTAX_HIGHLIGHT_DIR" ]; then
    log_info "Installing zsh-syntax-highlighting..."
    if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHT_DIR"; then
        log_info "zsh-syntax-highlighting installed successfully"
    else
        log_error "zsh-syntax-highlighting installation failed"
        exit 1
    fi
else
    log_warn "zsh-syntax-highlighting is already installed"
fi

if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc" || ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc" || ! grep -q "git" "$HOME/.zshrc"; then
    log_info "Adding missing plugins..."
    sed -i 's/^plugins=.*/plugins=(zsh-autosuggestions zsh-syntax-highlighting git)/' "$HOME/.zshrc"
fi

log_info "ZSH, Oh My Zsh, and Powerlevel10k setup complete"
