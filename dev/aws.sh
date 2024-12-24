#!/usr/bin/env bash
source "$(dirname "$0")/../utils/log.sh"

TEMP_DIR=$(mktemp -d)
if [[ ! "$TEMP_DIR" || ! -d "$TEMP_DIR" ]]; then
    log_error "Failed to create temporary directory"
    exit 1
fi

log_section "AWS TOOLS"

if command -v aws >/dev/null 2>&1; then
    log_warn "Previous AWS CLI Installation found..."
    log_info "Attempting to update current installation..."
    
    if [ "$ARCH" == "arm64" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "${TEMP_DIR}/awscliv2.zip"
        unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
        sudo "${TEMP_DIR}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    else 
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TEMP_DIR}/awscliv2.zip"
        unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
        sudo "${TEMP_DIR}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    fi
else
    log_info "Installing AWS CLI Tools"
    if [ "$ARCH" == "arm64" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "${TEMP_DIR}/awscliv2.zip"
        unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
        sudo "${TEMP_DIR}/aws/install"
    else 
        log_info "Installing AWS CLI"
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TEMP_DIR}/awscliv2.zip"
        unzip -q "${TEMP_DIR}/awscliv2.zip" -d "$TEMP_DIR"
        sudo "${TEMP_DIR}/aws/install"
    fi
    log_info "AWS CLI installation complete"
fi

if command -v sam >/dev/null 2>&1; then
    log_warn "Previous SAM CLI Installation found..."
    log_info "Attempting to update current installation..."
    
    if [ "$ARCH" == "arm64" ]; then
        log_info "Retrieving SAM CLI Installer..."
        curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-arm64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"

        log_info "Unzipping SAM CLI Installer..."
        unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"

        log_info "Executing SAM CLI Installer Updates..."
        sudo "${TEMP_DIR}/sam-installation/install" --update

        log_info "Cleaning up SAM CLI Installer artifacts..."
    else 
        log_info "Retrieving SAM CLI Installer..."
        curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"

        log_info "Unzipping SAM CLI Installer..."
        unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"

        log_info "Executing SAM CLI Installer Updates..."
        sudo "${TEMP_DIR}/sam-installation/install" --update
    fi
else
    log_info "Installing SAM CLI"
    if [ "$ARCH" == "arm64" ]; then
        log_info "Retrieving SAM CLI Installer..."
        curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-arm64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"

        log_info "Unzipping SAM CLI Installer..."
        unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"

        log_info "Executing SAM CLI Installer..."
        sudo "${TEMP_DIR}/sam-installation/install"

        log_info "Cleaning up SAM CLI Installer artifacts..."
    else 
        log_info "Retrieving SAM CLI Installer..."
        curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "${TEMP_DIR}/aws-sam-cli.zip"

        log_info "Unzipping SAM CLI Installer..."
        unzip -q "${TEMP_DIR}/aws-sam-cli.zip" -d "${TEMP_DIR}/sam-installation"

        log_info "Executing SAM CLI Installer..."
        sudo "${TEMP_DIR}/sam-installation/install"

        log_info "Cleaning up SAM CLI Installer artifacts..."
    fi
fi

sudo rm -rf "${TEMP_DIR:?}"/*
log_warn "Cleaning up TMP installation artifacts"
sudo rm -rf /tmp/tmp.*
log_info "AWS TOOLS installation complete"