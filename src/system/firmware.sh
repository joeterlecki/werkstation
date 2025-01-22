#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Firmware updates..."

log_warm "This script is interactive, please follow prompts accordingly!"
log_info "Refreshing update db..."

sudo fwupdmgr refresh --force

log_info "Retrieving devices..."
sudo fwupdmgr get-devices -y # Lists devices with available updates.

log_info "Retrieving updates..."
sudo fwupdmgr get-updates -y # Fetches list of available updates.

log_warn "Full update requires reboot, NO for now as to not interrupt other scripts.."
log_info "Running updates..."
sudo fwupdmgr update -y
