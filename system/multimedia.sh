#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Multimedia and media plugins"

log_info "Installing VLC..."
sudo dnf install -y vlc

log_info "Installing fusion ffmpeg and swapping from fedora.."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

log_info "Installating media codecs..."
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

log_info "Multimedia and media plugins installation complete"


