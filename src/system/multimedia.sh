#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Multimedia and media plugins"

log_info "Swapping ffmpeg-free and ffmpg..."
sudo dnf install -y ffmpeg
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

log_info "Adding multimedia group via dnf4 group..."
sudo dnf4 group upgrade multimedia -y

sudo dnf upgrade @multimedia -y --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

log_info "Installing sound and video..."
sudo dnf4 -v group install 'Sound and Video'

log_info "Installing VLC..."
sudo dnf install -y vlc

log_info "Installing additional HW Decoding VA-API tools"
sudo dnf install -y ffmpeg-libs libva libva-utils
sudo dnf swap -y libva-intel-media-driver intel-media-driver --allowerasing
sudo dnf install -y libva-intel-driver

log_info "Multimedia and media plugins installation complete"
