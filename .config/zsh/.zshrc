###########################
# Zinit Initialization
###########################

# Install Zinit if missing
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Load Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load annexes (required for Zinit features)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


###########################
# Paths and Environment
###########################

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# ASDF & kubelogin
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# History configuration
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Zsh options
setopt histignorealldups sharehistory


###########################
# Plugins via Zinit
###########################

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# fzf (if installed manually)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


###########################
# Completion system
###########################

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# Process completion coloring
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# LS_COLORS
eval "$(dircolors -b)"


###########################
# VCS Info
###########################

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '


###########################
# Prompt
###########################

setopt PROMPT_SUBST
PROMPT='%B%F{white}%n%F{red}@%F{white}%m:[%F{blue}%~%f] %F{green}${vcs_info_msg_0_}%f%F{red}$ %b%F{white}'


###########################
# Aliases
###########################

alias ls='ls --color=auto'
alias n='nvim'
alias k='kubectl'


###########################
# Extra Configs
###########################

# Load additional user config if exists
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
