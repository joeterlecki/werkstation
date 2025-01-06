#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Essential Packages"

PACKAGES=(
	curl
	wget
	git
	unzip
	#build-essential
	#software-properties-common
	#apt-transport-https
	ca-certificates
	gnupg
	jq
	fuse
	stow
)

log_info "Installing common tools..."
sudo zypper -n install "${PACKAGES[@]}"

log_info "Essential packages installation completed"
