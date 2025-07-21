# =============================================================================
# ZSH Configuration
# =============================================================================

# Basic zsh plugins (manually managed)
# Install zsh-autosuggestions and zsh-syntax-highlighting via package manager
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# =============================================================================
# History Configuration
# =============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks from history items
setopt HIST_VERIFY             # Show command with history expansion to user before running it
setopt SHARE_HISTORY           # Share history between all sessions
setopt EXTENDED_HISTORY        # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY      # Append to history file immediately, not when shell exits
setopt HIST_FIND_NO_DUPS       # Do not display duplicates when searching history

# =============================================================================
# Completion Configuration
# =============================================================================

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Enable menu selection
zstyle ':completion:*' menu select

# Color completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =============================================================================
# Aliases
# =============================================================================

# File operations
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System monitoring
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Package management (for CachyOS/Arch)
alias pac='sudo pacman'
alias pacs='pacman -Ss'
alias pacin='sudo pacman -S'
alias pacup='sudo pacman -Syu'
alias pacr='sudo pacman -R'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# =============================================================================
# Environment Variables
# =============================================================================

# Qt theming (preserved from original)
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum

# Default applications
export BROWSER=chromium
export EDITOR=nano
export VISUAL=nano

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# Rose Pine Theme Configuration
# =============================================================================

# Rose Pine terminal colors
export ROSE_PINE_BASE="191724"
export ROSE_PINE_SURFACE="1f1d2e"
export ROSE_PINE_OVERLAY="26233a"
export ROSE_PINE_MUTED="6e6a86"
export ROSE_PINE_SUBTLE="908caa"
export ROSE_PINE_TEXT="e0def4"
export ROSE_PINE_LOVE="eb6f92"
export ROSE_PINE_GOLD="f6c177"
export ROSE_PINE_ROSE="ebbcba"
export ROSE_PINE_PINE="31748f"
export ROSE_PINE_FOAM="9ccfd8"
export ROSE_PINE_IRIS="c4a7e7"

# Set LS_COLORS for Rose Pine
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32"

# FZF Rose Pine theme
export FZF_DEFAULT_OPTS="
    --color=fg:#908caa,bg:#191724,hl:#ebbcba
    --color=fg+:#e0def4,bg+:#26233a,hl+:#f6c177
    --color=border:#403d52,header:#31748f,gutter:#191724
    --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

# BAT Rose Pine theme
export BAT_THEME="base16"

# =============================================================================
# Key Bindings
# =============================================================================

# Use vim key bindings
bindkey -v

# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Home and End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete key
bindkey '^[[3~' delete-char

# =============================================================================
# Functions
# =============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find largest files in current directory
largest() {
    du -ah . | sort -rh | head -n ${1:-10}
}

# =============================================================================
# Starship Prompt
# =============================================================================

# Initialize Starship prompt
eval "$(starship init zsh)"
# =============================================================================
# Theme Switcher Functions
# =============================================================================

# Theme is now handled by Starship configuration

