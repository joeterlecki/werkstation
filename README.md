<h1 align="center">Fedora i3 Werkstation</h1>
<p align="center"><img src="./img/Fedora_logo.svg"/></p>

This repo contains my dotfiles and Ansible Role for installing and configuring a complete i3wm
install on a Fresh Fedora40 XFCE installation.

The Ansibile playbook/role is not intended for maintaining updates, but rather a baseline config
to streamline new installations. For maintaining updates to config files, gnu stow (TODO) will be
used to symlink dotfiles

## Prerequisites
- git
- ansible
- fresh Fedora40 XFCE Spin

## Key tiling Software
Below is the key software for my i3 config.
- kitty
- picom
- feh
- homebrew
- i3

## Features
The role configures and does the following
- Updates and patches the DNF system and tunes mirrors for performance
- Installs and configures akmod nvidia drivers and disables nouveau
- Installs Development tools/languages using Homebrew
- Installs rose-pine gtk3 and icon themes
- Installs nerdfonts for desktop and terminal
- Installs neovim dependencies and AstroNvim distrobution

## Installing
You must have a password enabled and be part of the sudoers/wheel group. The role is executed under 
the assumption of running as a non root user, however; escalation is required for tasks such as 
installing software and configuring kernel modules
```bash
ansible-playbook playbook.yaml -K -v
```

## Testing
To test the installation of the config, a packer configuration file is included. Even though
this is for a system configuration, a docker container can be used to ensure the majority of the playbook
tasks.

From the root of the directory
```bash
packer init .
packer build .
```

# TODO
- Configure Neovim with lsps, themes, and tweaks
- Configure lightdm login wallpaper
- Install/Configure Tmux with vim bindings and theme
- Intsall Obsidian, slack
- More will come
