#!/bin/bash

BREW_PREFIX="/home/linuxbrew/.linuxbrew"

if [ -x "${BREW_PREFIX}/bin/brew" ]; then
    echo "Homebrew already installed at ${BREW_PREFIX}"
    exit 0
fi

echo "Installing Homebrew..."

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Homebrew installed successfully"
