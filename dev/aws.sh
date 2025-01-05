#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

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
        return 0
    else
        log_info "Installing $tool"
        return 1
    fi
}

install_aws_cli() {
    local current_version=""

    if command -v aws >/dev/null 2>&1; then
        current_version=$(aws --version | cut -d' ' -f1 | cut -d'/' -f2)
        # Get latest version from GitHub tags
        latest_version=$(curl -s https://api.github.com/repos/aws/aws-cli/tags | grep '"name":' | head -1 | cut -d'"' -f4)

        log_info "AWS CLI current version: $current_version"
        log_info "AWS CLI latest version: $latest_version"

        if [[ "$current_version" == "$latest_version" ]]; then
            log_warn "AWS CLI is already at the latest version"
            return 0
        fi
    fi
    log_info "Downloading AWS CLI..."
    if [ "$ARCH" == "arm64" ]; then
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "${TEMP_DIR}/awscliv2.zip"
    else
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TEMP_DIR}/awscliv2.zip"
    fi

    unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
    if [ $? -eq 0 ]; then
        sudo "${TEMP_DIR}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli $(command -v aws >/dev/null 2>&1 && echo "--update") &>/dev/null
    fi
}

install_sam_cli() {
    local current_version=""
    local latest_version=""

    if command -v sam >/dev/null 2>&1; then
        current_version=$(sam --version | cut -d' ' -f4)
        latest_version=$(curl -s https://api.github.com/repos/aws/aws-sam-cli/releases/latest | grep '"tag_name":' | cut -d'"' -f4 | tr -d 'v')

        log_info "SAM CLI current version: $current_version"
        log_info "SAM CLI latest version: $latest_version"

        if [ "$current_version" = "$latest_version" ]; then
            log_warn "SAM CLI is already at the latest version"
            return 0
        fi
    fi

    log_info "Retrieving SAM CLI Installer..."
    if [ "$ARCH" == "arm64" ]; then
        curl -sL "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-arm64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"
    else
        curl -sL "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"
    fi

    log_info "Unzipping SAM CLI Installer..."
    unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"
    if [ $? -eq 0 ]; then
        log_info "Executing SAM CLI Installer..."
        sudo "${TEMP_DIR}/sam-installation/install" $(command -v sam >/dev/null 2>&1 && echo "--update") &>/dev/null
    fi
}

install_aws_cli
log_info "AWS CLI installation complete"

install_sam_cli
log_info "SAM CLI installation complete"

check_existing "session-manager-plugin"

if [ "$ARCH" == "arm64" ]; then
    curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "${TEMP_DIR}/session-manager-plugin.deb"
    sudo dpkg -i "${TEMP_DIR}/session-manager-plugin.deb" &>/dev/null
else
    curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "${TEMP_DIR}/session-manager-plugin.deb"
    sudo dpkg -i "${TEMP_DIR}/session-manager-plugin.deb" &>/dev/null
fi

log_info "Session Manager Plugin installation complete"

log_warn "Cleaning up TMP installation artifacts"
sudo rm -rf "${TEMP_DIR:?}"/* /tmp/tmp.*
log_info "AWS TOOLS installation complete"
