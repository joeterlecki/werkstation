#!/usr/bin/env bash
source "$(dirname "$0")/../utils/log.sh"

TEMP_DIR=$(mktemp -d)
if [[ ! "$TEMP_DIR" || ! -d "$TEMP_DIR" ]]; then
    log_error "Failed to create temporary directory"
    exit 1
fi

log_section "AWS TOOLS"

check_existing() {
    local tool=$1
    if command -v "$tool" >/dev/null 2>&1; then
        log_warn "Previous $tool Installation found..."
        log_info "Attempting to update current installation..."
        return 0
    else
        log_info "Installing $tool"
        return 1
    fi
}

check_existing "aws"
if [ "$ARCH" == "arm64" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "${TEMP_DIR}/awscliv2.zip"
    unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
    if [ $? -eq 0 ]; then
        sudo "${TEMP_DIR}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli $(command -v aws >/dev/null 2>&1 && echo "--update")
    fi
else 
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TEMP_DIR}/awscliv2.zip"
    unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
    if [ $? -eq 0 ]; then
        sudo "${TEMP_DIR}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli $(command -v aws >/dev/null 2>&1 && echo "--update")
    fi
fi
log_info "AWS CLI installation complete"

check_existing "sam"
if [ "$ARCH" == "arm64" ]; then
    log_info "Retrieving SAM CLI Installer..."
    curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-arm64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"
    log_info "Unzipping SAM CLI Installer..."
    unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"
    if [ $? -eq 0 ]; then
        log_info "Executing SAM CLI Installer..."
        sudo "${TEMP_DIR}/sam-installation/install" $(command -v sam >/dev/null 2>&1 && echo "--update")
    fi
else 
    log_info "Retrieving SAM CLI Installer..."
    curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"
    log_info "Unzipping SAM CLI Installer..."
    unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"
    if [ $? -eq 0 ]; then
        log_info "Executing SAM CLI Installer..."
        sudo "${TEMP_DIR}/sam-installation/install" $(command -v sam >/dev/null 2>&1 && echo "--update")
    fi
fi

check_existing "session-manager-plugin"
if [ "$ARCH" == "arm64" ]; then
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "${TEMP_DIR}/session-manager-plugin.deb"
    sudo dpkg -i "${TEMP_DIR}/session-manager-plugin.deb"
else 
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "${TEMP_DIR}/session-manager-plugin.deb"
    sudo dpkg -i "${TEMP_DIR}/session-manager-plugin.deb"
fi
log_info "Session Manager Plugin installation complete"

log_warn "Cleaning up TMP installation artifacts"
sudo rm -rf "${TEMP_DIR:?}"/* /tmp/tmp.*
log_info "AWS TOOLS installation complete"