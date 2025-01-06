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
	apt-transport-https
	ca-certificates
	gnupg
	jq
	fuse
	stow
	dnf-plugins-core
)

log_info "Installing common tools..."
sudo dnf install -y "${PACKAGES[@]}"

log_info "Installing group tools and packages"
sudo dnf group install -y development-tools

log_info "Essential packages installation completed"

