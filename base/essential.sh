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
	fuse-devel
	stow
	ripgrep
	dnf-plugins-core
)

log_info "Installing common tools..."
sudo dnf install -y "${PACKAGES[@]}"

log_info "Installing group tools and packages"
sudo dnf group install -y development-tools


REMOVE_PACKAGES=(
	dnfdragora-updater
)

log_info "Uninstalling unwanted packages..."
sudo dnf remove -y "${REMOVE_PACKAGES[@]}"

log_info "Essential packages installation completed"
