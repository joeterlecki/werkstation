#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils/log.sh"

Mcheck_environment() {
	if ! command -v dnf >/dev/null; then
		log_error "This script only supports Fedora based systems"
		exit 1
	fi
}

log_section "Running system updates"
sudo dnf update -y

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

	export SCRIPT_DIR
	export -f log_info log_warn log_error log_section
	export RED GREEN YELLOW PURPLE NC

	log_section "Starting Installation"
	execute "$SCRIPT_DIR"/base
	execute "$SCRIPT_DIR"/homebrew
	execute "$SCRIPT_DIR"/dev
	execute "$SCRIPT_DIR"/neovim
	execute "$SCRIPT_DIR"/wm
	execute "$SCRIPT_DIR"/apps
	execute "$SCRIPT_DIR"/ssh
    execute "$SCRIPT_DIR"/system
	log_section "Installation script complete"
}

main
