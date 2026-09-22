HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTIONS="false"
COMPLETION_WAITING_DOTS="true"

HISTSIZE=50000
SAVEHIST=50000
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
HISTFILE=${HOME}/.zsh_history
HISTORY_IGNORE="(l[alsh]#( *)#)"

export BROWSER=open

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --border=none \
    --color=bg+:#3c3836 \
    --color=bg:#282828 \
    --color=border:#ebdbb2 \
    --color=fg:#d5c4a1 \
    --color=fg+:#ebdbb2 \
    --color=gutter:#282828 \
    --color=header:#ebdbb2 \
    --color=hl+:#fabd2f \
    --color=hl:#fabd2f \
    --color=info:#928374 \
    --color=marker:#fe8019 \
    --color=pointer:#ebdbb2 \
    --color=prompt:#ebdbb2 \
    --color=query:#d5c4a1:regular \
    --color=scrollbar:#d5c4a1 \
    --color=separator:#ebdbb2 \
    --color=spinner:#928374 \
"
