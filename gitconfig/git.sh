#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Git Configuration"
log_info "Installing git configuration..."

log_warn "$SCRIPT_DIR"

for file in "${SCRIPT_DIR}/dotfiles/git/.gitconfig"*; do
	if [ -f "$file" ]; then
		cp "$file" "$HOME/"
		log_info "Installed $file"
	fi
done

log_info "Git configuration complete"
