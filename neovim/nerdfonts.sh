#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Nerd Fonts"

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip"
FONT_NAME="0xProtoNerdFont"
FONTS_PATH="$HOME/.fonts"

if [ ! -d "$FONTS_PATH" ]; then
    log_warn "$FONTS_PATH not found, creating..."
    mkdir -p "$FONTS_PATH"
else
    log_info "$FONTS_PATH found, checking for nerd font..."
    if ls "$FONTS_PATH/$FONT_NAME"*.ttf &>/dev/null; then
        log_warn "$FONT_NAME found in $FONTS_PATH..."
        exit 0
    fi

fi

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

log_info "Downloading $FONT_NAME..."
log_info "URL: $FONT_URL"

wget -q --show-progress -P "$TEMP_DIR" $FONT_URL

log_info "Extracting font files..."
unzip -q "$TEMP_DIR"/*.zip -d "$TEMP_DIR"

log_info "Copying font files..."
mv "$TEMP_DIR"/*.ttf "$FONTS_PATH/"

log_info "Updating font cache..."
fc-cache -f "$FONTS_PATH"

log_info "Font installation complete"
