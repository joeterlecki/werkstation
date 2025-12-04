#!/bin/bash

BREW_PREFIX="/home/linuxbrew/.linuxbrew"

if [ -x "${BREW_PREFIX}/bin/brew" ]; then
    echo "Homebrew already installed at ${BREW_PREFIX}"
    exit 0
fi

echo "Installing Homebrew..."

mkdir -p /home/linuxbrew/.linuxbrew

git clone https://github.com/Homebrew/brew "${BREW_PREFIX}/Homebrew"

mkdir -p "${BREW_PREFIX}/bin"
ln -s "${BREW_PREFIX}/Homebrew/bin/brew" "${BREW_PREFIX}/bin/brew"

chmod -R 755 /home/linuxbrew

echo "Homebrew installed successfully"
