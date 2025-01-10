
#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "DNF Optimizations"

log_info "Backing up original config..."
sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.backup

log_info "Adding Optimal DNF settings..."
sudo bash -c 'cat > /etc/dnf/dnf.conf << EOL
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=True
max_parallel_downloads=10
deltarpm=True
keepcache=True
EOL'

log_info "Generating mirror list..."
sudo dnf clean all
sudo dnf makecache

log_info "Running DNF upgrade..."
sudo dnf upgrade -y

log_info "Clearing DNF cache..."
sudo dnf clean all
sudo dnf autoremove -y

log_info "DNF Optimizations complete"
