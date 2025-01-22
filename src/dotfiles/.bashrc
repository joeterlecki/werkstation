# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

alias cat='bat'

# Basic terraform commands
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfw='terraform workspace'
alias tfo='terraform output'
alias tff='terraform fmt'
alias tfv='terraform validate'

# Plan and apply with auto-approve
alias tfpa='terraform plan -auto-approve'
alias tfaa='terraform apply -auto-approve'

# Terraform state manipulation
alias tfs='terraform state'
alias tfsl='terraform state list'
alias tfss='terraform state show'
alias tfsrm='terraform state rm'
alias tfsm='terraform state mv'

# Workspace management
alias tfws='terraform workspace show'
alias tfwl='terraform workspace list'
alias tfwn='terraform workspace new'
alias tfws='terraform workspace select'

# Target specific resources
alias tfpt='terraform plan -target'
alias tfat='terraform apply -target'

# Variables and outputs
alias tfvl='terraform validate && terraform plan'
alias tfof='terraform output -json | jq'  # Requires jq installed

# Common combinations
alias tfir='terraform init -upgrade && terraform init -reconfigure'
alias tfpf='terraform fmt && terraform plan'
alias tffv='terraform fmt && terraform validate'

# Debug helpers
alias tft='TF_LOG=TRACE terraform'
alias tfd='TF_LOG=DEBUG terraform'
alias tlog='tail -f terraform.log'  # Useful when running with TF_LOG

# Initialize and select workspace in one go
function tfiw() {
    terraform init && terraform workspace select "$1" || terraform workspace new "$1"
}

# Plan with specific var file
function tfpv() {
    terraform plan -var-file="$1.tfvars"
}

# Apply with specific var file
function tfav() {
    terraform apply -var-file="$1.tfvars"
}

# Show specific output in JSON format
function tfo() {
    terraform output -json | jq ".$1"
}
