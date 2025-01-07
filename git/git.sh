#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Git Configuration"
log_info "Installing git configuration..."

for file in ./dotfiles/git/*; do
	[ -f "$file" ] && cp "$file" "$HOME/.$(basename $file)"
	log_info "Installed $HOME/.$(basename $file)"
done

log_info "Git configuration complete"
