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
  --color=bg+:#272727 \
  --color=bg:#101010 \
  --color=border:#ffffff \
  --color=fg:#b0b0b0 \
  --color=fg+:#ffffff \
  --color=gutter:#101010 \
  --color=header:#ffffff \
  --color=hl+:#d9ba73 \
  --color=hl:#d9ba73 \
  --color=info:#50585d \
  --color=marker:#ff7676 \
  --color=pointer:#ffffff \
  --color=prompt:#ffffff \
  --color=query:#b0b0b0:regular \
  --color=scrollbar:#b0b0b0 \
  --color=separator:#ffffff \
  --color=spinner:#50585d \
"
