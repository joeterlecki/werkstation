#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

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
       sudo usermod -s "$zsh_path" $USER
       log_info "Note: Shell change will take effect after next login"
   fi
else
   log_warn "ZSH already installed and set as default shell..."
   exit 0
fi

log_info "ZSH setup complete"