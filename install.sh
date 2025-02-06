#!/usr/bin/env bash

set -euo pipefail
trap 'echo "Error on line $LINENO"' ERR

#===============================================================================
# Script Metadata
#===============================================================================
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_NAME="Fedora Development Environment Setup"
readonly SCRIPT_AUTHOR="Joe Terlecki"
readonly MINIMUM_FEDORA_VERSION="41"

#===============================================================================
# System Requirements Check
#===============================================================================
check_system_requirements() {
	log_section "Checking system requirements"

	local fedora_version
	fedora_version=$(rpm -E %fedora)
	if [ "$fedora_version" -lt "$MINIMUM_FEDORA_VERSION" ]; then
		log_error "This script requires Fedora $MINIMUM_FEDORA_VERSION or higher"
		log_error "Current version: $fedora_version"
		exit 1
	fi

	log_info "System requirements met - Fedora $fedora_version detected"
}

#===============================================================================
# ASCII Art Splash Screen
#===============================================================================
display_splash() {
	cat <<"EOF"
 ____ ____ ____ ____ ____ ____ ____ ____ ____ ____ ____ 
||W |||E |||R |||K |||S |||T |||A |||T |||I |||O |||N ||
||__|||__|||__|||__|||__|||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|

 System Setup & Configuration
EOF
	echo -e "\n${SCRIPT_NAME} v${SCRIPT_VERSION}"
	echo "Author: ${SCRIPT_AUTHOR}"
	echo "Minimum Fedora Version: ${MINIMUM_FEDORA_VERSION}"
	echo -e "\n"
}

#===============================================================================
# Logging Functions
#===============================================================================
log() {
	local level=$1
	local message=$2
	local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	# ANSI color codes
	local RED='\033[0;31m'
	local GREEN='\033[0;32m'
	local YELLOW='\033[1;33m'
	local PURPLE='\033[0;35m'
	local NC='\033[0m'

	case $level in
	"INFO") echo -e "${GREEN}[INFO]${NC} $timestamp $message" ;;
	"WARN") echo -e "${YELLOW}[WARN]${NC} $timestamp $message" >&2 ;;
	"ERROR") echo -e "${RED}[ERROR]${NC} $timestamp $message" >&2 ;;
	"SECTION") echo -e "\n${PURPLE}====== $message ======${NC}\n" ;;
	*) echo -e "$timestamp $message" ;;
	esac
}

log_info() { log "INFO" "$1"; }
log_warn() { log "WARN" "$1"; }
log_error() { log "ERROR" "$1"; }
log_section() { log "SECTION" "$1"; }

#===============================================================================
# Helper Functions
#===============================================================================
check_fedora() {
	if ! command -v dnf >/dev/null; then
		log_error "This script only supports Fedora based systems"
		exit 1
	fi
}

configure_dnf() {
	log_section "DNF Optimizations"

	log_info "Backing up original config..."
	sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.backup

	log_info "Adding Optimal DNF settings..."
	sudo bash -c 'cat > /etc/dnf/dnf.conf << EOL
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=True
max_parallel_downloads=10
deltarpm=True
keepcache=True
EOL'

	log_info "Generating mirror list..."
	sudo dnf clean all
	sudo dnf makecache

	log_info "Running DNF upgrade..."
	sudo dnf upgrade -y

	# Clean up
	log_info "Clearing DNF cache..."
	sudo dnf clean all
	sudo dnf autoremove -y

	log_info "DNF Optimizations complete"
}

configure_rpmfusion() {
	log_section "RPM Fusion"

	local fedora_version
	fedora_version=$(rpm -E %fedora)

	# Enable Free RPM Fusion
	log_info "Enabling free rpm fusion repos..."
	sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm"

	# Enable Non-Free RPM Fusion
	log_info "Enabling nonfree rpm fusion repos..."
	sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"

	# Upgrade and refresh repos
	log_info "Upgrading repos and refresh..."
	sudo dnf upgrade --refresh -y

	log_info "RPM Fusion repo installation complete"
}

remove_packages() {
	log_section "Uninstalling unwanted packages"
	declare -a REMOVE_PACKAGES=(
		dnfdragora-updater
		firefox
		docker
		docker-client
		docker-client-latest
		docker-common
		docker-latest
		docker-latest-logrotate
		docker-logrotate
		docker-selinux
		docker-engine-selinux
		docker-engine
	)

	if [ ${#REMOVE_PACKAGES[@]} -gt 0 ]; then
		log_info "Removing ${#REMOVE_PACKAGES[@]} packages..."
		sudo dnf remove -y "${REMOVE_PACKAGES[@]}"
		log_info "Package removal complete"
	else
		log_info "No packages to remove"
	fi
}

install_packages() {
	log_section "Installing essential dnf packages"
	declare -a PACKAGES=(
		zsh
		curl
		wget
		git
		unzip
		apt-transport-https
		ca-certificates
		gnupg
		fuse
		fuse-devel
		stow
		dnf-plugins-core
		xrandr
		polkit-devel
		xsettingsd
		ripgrep
		xlclip
		tree-sitter-cli
		neovim
		i3
		picom
		feh
		dunst
		polybar
		lxappearance
		flameshot
		thunar
		rofi
		fastfetch
		light
		powertop
		fzf
		zoxide
		lsd
		bat
		obs-studio
		kitty
		"https://packages.microsoft.com/yumrepos/edge/Packages/m/microsoft-edge-stable-132.0.2957.140-1.x86_64.rpm"
		tailscale
		docker-ce
		docker-ce-cli
		containerd.io
		docker-buildx-plugin
		docker-compose-plugin
		vlc
		brave-browser
		postgresql
	)

	log_info "Insuring dnf core plugins are installed..."
	sudo dnf install dnf-plugins-core

	log_info "Adding additional repositories..."
	sudo dnf-3 config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
	sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

	log_info "Installing ${#PACKAGES[@]} packages..."
	sudo dnf install -y "${PACKAGES[@]}" --skip-unavailable

	log_info "Installing development tools group..."
	sudo dnf group install -y development-tools

	log_info "Package installation complete"
}

configure_nvidia() {
	log_section "Nvidia Drivers"

	log_info "Checking installed VGA for NVIDIA..."
	if ! lspci | grep -i nvidia >/dev/null; then
		log_warn "No Nvidia card detected..."
		log_warn "Skipping driver installation..."
		return 0
	fi

	log_warn "NVIDIA Card Detected..."
	log_info "Installing akmod and cuda x11 drivers..."
	sudo dnf install -y akmod-nvidia
	sudo dnf install -y xorg-x11-drv-nvidia-cuda

	log_info "Checking for existing blacklist..."
	if [ ! -f /etc/modprobe.d/blacklist-nouveau.conf ]; then
		log_warn "Blacklisting nouveau drivers..."
		echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
		echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf

		log_warn "Regenerating initramfs..."
		sudo dracut --force
	else
		log_info "Nouveau blacklist already exists..."
	fi

	log_info "Installing mokutil for secureboot..."
	sudo dnf install -y mokutil

	log_info "Nvidia driver installation complete"
}

configure_services() {
	log_section "Configuring system services"
	declare -a SERVICES=(
		tailscaled
		docker
	)

	if [ ${#SERVICES[@]} -gt 0 ]; then
		log_info "Enabling services..."
		sudo systemctl enable "${SERVICES[@]}"

		log_info "Starting services..."
		sudo systemctl start "${SERVICES[@]}"

		for service in "${SERVICES[@]}"; do
			if sudo systemctl is-active --quiet "$service"; then
				log_info "$service is running"
			else
				log_warn "$service failed to start"
			fi
		done
	else
		log_info "No services to configure"
	fi
}

configure_docker() {
	log_section "Configuring Docker"

	log_info "Adding user to docker group..."
	sudo usermod -aG docker "$USER"

	if command -v docker >/dev/null; then
		log_info "Verifying docker installation..."
		if sudo docker version >/dev/null 2>&1; then
			log_info "Docker is properly installed and configured"
		else
			log_warn "Docker is installed but may not be properly configured"
		fi
	else
		log_error "Docker installation not found"
	fi
}

configure_flatpak() {
	log_section "Configuring Flatpak"

	if ! command -v flatpak >/dev/null; then
		log_info "Installing Flatpak..."
		sudo dnf install -y flatpak
	fi

	log_info "Adding Flathub repository..."
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	if flatpak remotes | grep -q "flathub"; then
		log_info "Flathub repository successfully configured"
	else
		log_warn "Flathub repository configuration may have failed"
	fi
}

configure_zsh() {
	log_section "Configuring ZSH"
	local zsh_path

	if ! command -v zsh >/dev/null; then
		log_info "Installing ZSH..."
		sudo dnf install -y zsh
	fi

	zsh_path=$(command -v zsh)

	log_info "Setting default shell to ZSH..."
	sudo usermod -s "$zsh_path" "$USER"
	log_warn "Note: Shell change will take effect after next login..."

	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		log_info "Installing Oh My Zsh..."
		curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
	fi

	if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
		log_info "Installing Powerlevel10k theme..."
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
		log_info "Powerlevel10k installed successfully"
	fi
}

disable_selinux() {
	log_section "SELinux"

	local current_mode
	current_mode=$(getenforce 2>/dev/null || echo "Unknown")

	if [ "$current_mode" = "Disabled" ]; then
		log_info "SELinux is already disabled"
		return 0
	fi

	log_info "Disabling SELinux..."
	sudo setenforce 0

	log_info "Updating SELinux config for permanent disable..."
	sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

	log_info "SELinux disabled successfully"
	log_warn "A system reboot is recommended for changes to take full effect"
}

configure_multimedia() {
	log_section "Multimedia and media plugins"

	# Multimedia group installations
	log_info "Adding multimedia group via dnf4 group..."
	sudo dnf4 group upgrade multimedia -y
	sudo dnf upgrade @multimedia -y --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

	# Sound and Video group
	log_info "Installing sound and video..."
	sudo dnf4 -v -y group install 'Sound and Video'

	# VLC installation
	log_info "Installing VLC..."
	sudo dnf install -y vlc

	# Hardware acceleration support
	log_info "Installing additional HW Decoding VA-API tools"
	sudo dnf install -y ffmpeg-libs libva libva-utils --allowerasing
	sudo dnf swap -y libva-intel-media-driver intel-media-driver --allowerasing
	sudo dnf install -y libva-intel-driver

	# FFmpeg configuration (moved to end)
	log_info "Swapping ffmpeg-free and ffmpeg..."
	sudo dnf install -y ffmpeg
	sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

	log_info "Multimedia and media plugins installation complete"
}

configure_hostname() {
	log_section "Hostname Configuration"

	DESIRED_HOSTNAME="werkstation"
	CURRENT_HOSTNAME=$(hostnamectl --static)

	if [ "$CURRENT_HOSTNAME" != "$DESIRED_HOSTNAME" ]; then

		log_info "Setting the system hostname $DESIRED_HOSTNAME..."
		sudo hostnamectl set-hostname "werkstation"
	else
		log_warn "Hostname already configured: $DESIRED_HOSTNAME..."
	fi

	log_info "Hostname setting complete"
}

update_firmware() {
	log_section "Firmware updates"

	log_warn "This script is interactive, please follow prompts accordingly!"

	# Refresh firmware database
	log_info "Refreshing update db..."
	sudo fwupdmgr refresh --force

	# Get device information
	log_info "Retrieving devices..."
	sudo fwupdmgr get-devices -y

	# Check for updates
	log_info "Retrieving updates..."
	sudo fwupdmgr get-updates -y

	# Install updates
	log_warn "Full update requires reboot after completion"
	log_info "Running updates..."
	sudo fwupdmgr update -y
}

install_fonts() {
	log_section "Installing Nerd Fonts"

	local font_dir="$HOME/.fonts"
	local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaMono.zip"
	local temp_zip="/tmp/CascadiaMono.zip"

	log_info "Creating fonts directory..."
	mkdir -p "$font_dir"

	log_info "Downloading Cascadia Mono Nerd Font..."
	wget -q "$font_url" -O "$temp_zip"

	log_info "Extracting fonts to $font_dir..."
	unzip -q -o "$temp_zip" -d "$font_dir" -x "*.txt" "*.md" "LICENSE*" "README*"

	local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CodeNewRoman.zip"
	local temp_zip="/tmp/CodeNewRoman.zip"

	log_info "Downloading CodeNewRoman Nerd Font..."
	wget -q "$font_url" -O "$temp_zip"

	log_info "Extracting fonts to $font_dir..."
	unzip -q -o "$temp_zip" -d "$font_dir" -x "*.txt" "*.md" "LICENSE*" "README*"

	log_info "Cleaning up temporary files..."
	rm -f "$temp_zip"

	log_info "Updating font cache..."
	fc-cache -f "$font_dir"

	log_info "Font installation complete"
}

install_vscode() {
	log_section "Install Visual Studio Code"

	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

	sudo dnf check-update
	sudo dnf install code
}

install_golang() {
	log_section "Install Golang"
	log_info "Retrieving golang tar..."
	wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz

	log_info "Installing go via tar"
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.6.linux-amd64.tar.gz
}

install_dotnet() {
	log_section "Install dotnet"
	log_info "Retrieving dotnet install script..."
	wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
	chmod +x /tmp/dotnet-install.sh
	/tmp/dotnet-install.sh -c lts

}

#===============================================================================
# Main Installation Function
#===============================================================================
main() {
	display_splash
	check_fedora
	check_system_requirements

	log_section "Starting Installation"
	log_warn "Retrieving SUDO password for elevated actions"
	sudo -v

	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &

	log_section "Running system updates"
	sudo dnf update -y

	# configure_dnf
	# configure_rpmfusion
	# remove_packages
	# install_packages
	# configure_multimedia
	# configure_nvidia
	# configure_docker
	# configure_flatpak
	# configure_zsh
	# configure_services
	# install_fonts
	# disable_selinux
	# configure_hostname
	install_vscode
	install_golang
	# update_firmware

	log_section "Installation script complete"
	log_warn "Please log out and log back in for all changes to take effect"
}

main "$@"
