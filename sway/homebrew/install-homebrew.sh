#!/bin/bash

BREW_PREFIX="/home/linuxbrew/.linuxbrew"
BREW_PACKAGES_FILE="/etc/brew-install.txt"

if [ -x "${BREW_PREFIX}/bin/brew" ]; then
    echo "Homebrew already installed at ${BREW_PREFIX}"
else
    echo "Installing Homebrew..."
    
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo "Homebrew installed successfully"
fi

eval "$(${BREW_PREFIX}/bin/brew shellenv)"

if [ -f "${BREW_PACKAGES_FILE}" ]; then
    echo "Installing Homebrew packages..."
    while IFS= read -r package || [ -n "$package" ]; do
        [[ -z "$package" || "$package" =~ ^#.*$ ]] && continue
        
        echo "Installing ${package}..."
        brew install "${package}"
    done < "${BREW_PACKAGES_FILE}"
    
    echo "Homebrew package installation complete"
else
    echo "No package list found at ${BREW_PACKAGES_FILE}"
fi
