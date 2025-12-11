#!/usr/bin/env bash

set -e

MANIFEST_FILE="/etc/flatpak-install.txt"
LOG_FILE="${HOME}/.flatpak-install.log"

echo "Starting Flatpak installation at $(date)" | tee "${LOG_FILE}"

echo "Configuring Flathub remote for user..." | tee -a "${LOG_FILE}"
if ! flatpak remotes --user | grep -q flathub; then
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

flatpak remote-modify --user --prio=0 flathub 2>/dev/null || true

if flatpak remotes --user | grep -q fedora; then
    flatpak remote-modify --user --prio=1 fedora 2>/dev/null || true
fi

echo "Flathub configured with highest priority" | tee -a "${LOG_FILE}"

if [[ ! -f "${MANIFEST_FILE}" ]]; then
    echo "ERROR: Manifest file not found: ${MANIFEST_FILE}" | tee -a "${LOG_FILE}"
    exit 1
fi

while IFS= read -r app; do
    [[ -z "$app" || "$app" =~ ^[[:space:]]*# ]] && continue
    
    app=$(echo "$app" | xargs)
    
    echo "Processing: ${app}" | tee -a "${LOG_FILE}"
    
    if flatpak list --user --app --columns=application | grep -q "^${app}$"; then
        echo "  Already installed: ${app}" | tee -a "${LOG_FILE}"
    else
        echo "  Installing: ${app}" | tee -a "${LOG_FILE}"
        if flatpak install --user --noninteractive -y flathub "${app}" >> "${LOG_FILE}" 2>&1; then
            echo "  Successfully installed: ${app}" | tee -a "${LOG_FILE}"
        else
            echo "  Failed to install: ${app}" | tee -a "${LOG_FILE}"
        fi
    fi
    
done < "${MANIFEST_FILE}"

echo "Setting Zen as Default Browser" | tee -a "${LOG_FILE}"
xdg-settings set default-web-browser app.zen_browser.zen.desktop

echo "Flatpak installation completed at $(date)" | tee -a "${LOG_FILE}"
