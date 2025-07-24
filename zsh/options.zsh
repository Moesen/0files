HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTIONS="false"
COMPLETION_WAITING_DOTS="true"

HISTSIZE=10000
SAVEHIST=10000
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
HISTFILE=${HOME}/.zsh_history
HISTORY_IGNORE="(l[alsh]#( *)#)"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export BROWSER="zen.desktop"
