# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

