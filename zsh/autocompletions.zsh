_comp_options+=(globdots)
# Loading to make colors work, which they still don't
zmodload  zsh/complist
# Order of trying to complete
zstyle ":completion:*" completer _extensions _complete _approximate
# Creates highlight around selection
zstyle ":completion:*" menu select
# Writes description of each category
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# Not sure what this does
zstyle ':completion:*' group-name ''
# This should also add colors, but right now doesn't
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Sets completion to first try case sensitive, then insensitive, and also looks for partial completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
bindkey -v
export KEYTIMEOUT=10
# Keybinds for traversing completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

for fp in $(ls ${ZDOTDIR}/autocompletions/*.zsh); do
  source $fp
done
