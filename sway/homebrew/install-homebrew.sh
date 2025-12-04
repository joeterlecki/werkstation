#!/bin/bash

BREW_PREFIX="/home/linuxbrew/.linuxbrew"

# Check if brew is already installed
if [ -x "${BREW_PREFIX}/bin/brew" ]; then
    echo "Homebrew already installed at ${BREW_PREFIX}"
    exit 0
fi

echo "Installing Homebrew..."

# Create directory structure
mkdir -p /home/linuxbrew/.linuxbrew

# Clone Homebrew
git clone https://github.com/Homebrew/brew "${BREW_PREFIX}/Homebrew"

# Create bin directory and symlink
mkdir -p "${BREW_PREFIX}/bin"
ln -s "${BREW_PREFIX}/Homebrew/bin/brew" "${BREW_PREFIX}/bin/brew"

# Make it world-writable so any user can use it
chmod -R 777 /home/linuxbrew

echo "Homebrew installed successfully"
