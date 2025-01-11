#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils/log.sh"

check_environment() {
	if ! command -v dnf >/dev/null; then
		log_error "This script only supports Fedora based systems"
		exit 1
	fi

	if grep -qi microsoft /proc/version; then
		export IS_WSL=1
		log_info "WSL environment detected"
	else
		export IS_WSL=0
		log_info "Native Linux environment detected"
	fi

	arch=$(uname -m)

	case $arch in
	x86_64)
		export ARCH="amd64"
		;;
	aarch64 | arm64)
		export ARCH="arm64"
		;;
	*)
		log_error "Architecture not supported: $arch"
		exit 1
		;;
	esac
	log_info "Detected architecture: $ARCH"
}

update_system() {
	log_section "Running system updates"
	sudo dnf update -y
}

execute() {
	local dir=$1
	if [[ ! -d "$dir" ]]; then
		log_error "Directory: $dir not found"
		return 1
	fi

	log_section "Processing directory: $SCRIPT_DIR/$(basename "$dir")"

	while IFS= read -r script; do
		if [[ -f "$script" && "$script" != "${SCRIPT_DIR}/install.sh" ]]; then
			if ! bash "$script"; then
				log_error "Failed to execute script: $script"
				return 1
			fi
		fi
	done < <(find "$dir" -type f -name "*.sh" | sort)
}

main() {
	check_environment

	log_warn "Retrieving SUDO password for elevated actions"
	sudo -v

	update_system

	export IS_WSL
	export ARCH
	export SCRIPT_DIR
	export -f log_info log_warn log_error log_section
	export RED GREEN YELLOW PURPLE NC

	log_section "Starting Installation"
	#execute "$SCRIPT_DIR"/base
	#execute "$SCRIPT_DIR"/dev
	execute "$SCRIPT_DIR"/neovim
	#execute "$SCRIPT_DIR"/system
	#execute "$SCRIPT_DIR"/wm
	#execute "$SCRIPT_DIR"/apps
	#execute "$SCRIPT_DIR"/ssh
	#execute "$SCRIPT_DIR"/gitconfig
	log_section "Installation script complete"
}

main
