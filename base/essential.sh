#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Essential Packages"

PACKAGES=(
	python3-venv
	curl
	wget
	git
	unzip
	build-essential
	software-properties-common
	apt-transport-https
	ca-certificates
	gnupg
	fuse
	stow
	cmake
	jq
)

log_info "Installing common tools..."
sudo apt-get install -y "${PACKAGES[@]}"

log_info "Essential packages installation completed"
