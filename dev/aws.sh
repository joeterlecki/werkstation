#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

TEMP_DIR=$(mktemp -d)
if [[ ! "$TEMP_DIR" || ! -d "$TEMP_DIR" ]]; then
    log_error "Failed to create temporary directory"
    exit 1
fi

log_section "AWS TOOLS"

curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TEMP_DIR}/awscliv2.zip"

unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
sudo "${TEMP_DIR}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli $(command -v aws >/dev/null 2>&1 && echo "--update") &>/dev/null
log_info "AWS CLI installation complete"

log_info "Retrieving SAM CLI Installer..."
curl -sL "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"

log_info "Unzipping SAM CLI Installer..."
unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"
sudo "${TEMP_DIR}/sam-installation/install" $(command -v sam >/dev/null 2>&1 && echo "--update") &>/dev/null

log_info "SAM CLI installation complete"
curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "${TEMP_DIR}/session-manager-plugin.deb"
sudo dpkg -i "${TEMP_DIR}/session-manager-plugin.deb" &>/dev/null

log_info "Session Manager Plugin installation complete"

log_warn "Cleaning up TMP installation artifacts"
sudo rm -rf "${TEMP_DIR:?}"/* /tmp/tmp.*

log_info "AWS TOOLS installation complete"
