#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "SSH Configuration"

set_permissions() {
  local file="$1"
  chmod 600 "$file"
  log_info "Permissions set for $file"
}

read -r -p "Do you want to configure SSH? (yes/no): " response </dev/tty

if [[ "$response" =~ ^[Yy][Ee][Ss]$ ]] || [[ "$response" =~ ^[Yy]$ ]]; then
  ssh_dir="$HOME/.ssh"
  if [ ! -d "$ssh_dir" ]; then
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    log_info "Created .ssh directory"
  fi

  log_info "Paste your public key content (press Ctrl+D when done):"
  public_key_content=$(cat </dev/tty)

  if [ -n "$public_key_content" ]; then
    echo "$public_key_content" >"$ssh_dir/id_rsa.pub"
    set_permissions "$ssh_dir/id_rsa.pub"
    log_info "Public key configured"
  else
    log_error "No public key content provided"
    exit 1
  fi

  log_info "Paste your private key content (press Ctrl+D when done):"
  private_key_content=$(cat </dev/tty)

  if [ -n "$private_key_content" ]; then
    echo "$private_key_content" >"$ssh_dir/id_rsa"
    set_permissions "$ssh_dir/id_rsa"
    log_info "Private key configured"
  else
    log_error "No private key content provided"
    exit 1
  fi

  log_info "SSH configuration completed successfully!"
else
  log_info "SSH configuration skipped."
  exit 0
fi
