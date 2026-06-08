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
    --color=bg+:#2b3b51 \
    --color=bg:#192330 \
    --color=border:#cdcecf \
    --color=fg:#aeafb0 \
    --color=fg+:#cdcecf \
    --color=gutter:#192330 \
    --color=header:#cdcecf \
    --color=hl+:#dbc074 \
    --color=hl:#dbc074 \
    --color=info:#575860 \
    --color=marker:#d16983 \
    --color=pointer:#cdcecf \
    --color=prompt:#cdcecf \
    --color=query:#aeafb0:regular \
    --color=scrollbar:#aeafb0 \
    --color=separator:#cdcecf \
    --color=spinner:#575860 \
"
