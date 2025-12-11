ARG NAME="werkstation-sway"
ARG NERDFONTS_VERSION="3.4.0"

FROM busybox:latest AS nerdfonts
ARG NERDFONTS_VERSION
RUN wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERDFONTS_VERSION}/CascadiaCode.zip?agree=true" -O ./cc_font.zip \
    && mkdir -p /fonts-install/usr/local/share/fonts \
    && unzip -o ./cc_font.zip -d /fonts-install/usr/local/share/fonts/ \
    && rm ./cc_font.zip \
    && wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERDFONTS_VERSION}/NerdFontsSymbolsOnly.zip?agree=true" -O ./nfs_font.zip \
    && unzip -o ./nfs_font.zip -d /fonts-install/usr/local/share/fonts/ \
    && rm ./nfs_font.zip

FROM quay.io/fedora-ostree-desktops/sway-atomic:43 as release

COPY --from=nerdfonts /fonts-install/usr /usr/

RUN echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-ip-forward.conf \
    && echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/99-ip-forward.conf

RUN sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

RUN mkdir -p /usr/local/bin \
    && curl -L -o /tmp/devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" \
    && install -c -m 0755 /tmp/devpod /usr/local/bin/devpod \
    && rm -f /tmp/devpod

RUN dnf5 config-manager addrepo --from-repofile='https://pkgs.tailscale.com/stable/fedora/tailscale.repo' \
    && dnf5 install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-43.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-43.noarch.rpm

RUN dnf5 install -y \
    dnf-plugins-core \
    unzip \
    git \
    wget \
    curl \
    neovim \
    kitty \
    tailscale \
    zsh \
    nmap-ncat \
    steam-devices \
    @development-tools \
    && dnf clean all

COPY flatpak/flatpak.txt /etc/flatpak-install.txt
COPY flatpak/install-flatpaks.sh /usr/local/bin/install-flatpaks.sh
RUN chmod +x /usr/local/bin/install-flatpaks.sh

COPY flatpak/flatpak-install.service /usr/lib/systemd/user/flatpak-install.service
RUN mkdir -p /usr/lib/systemd/user/default.target.wants \
    && ln -s ../flatpak-install.service /usr/lib/systemd/user/default.target.wants/flatpak-install.service

RUN rpm-ostree override remove firefox firefox-langpacks \
    && rpm-ostree cleanup -m \
    && ostree container commit

LABEL name="${NAME}" \
    summary="Fedora atomic sway with developer tools" \
    maintainer="Joe Terlecki" \
    org.opencontainers.image.source="https://github.com/joeterlecki/werkstation" \
    org.opencontainers.image.description="Sway-based Fedora Atomic container with development tools" \
    org.opencontainers.image.version="43"
