# Homebrew Setup (Mac specific)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

[[ -f "${HOME}/.local/bin/env" ]] && . "$HOME/.local/bin/env"
[[ -f "${HOME}/.cargo/env" ]] && . "$HOME/.cargo/env"
export PATH=$HOME/.cargo/bin:$PATH # Add cargo bin
export PATH=$HOME/0files/cli-tools/uv/.venv/bin:$PATH # Add uv global python install
# Antidote (Package manager)
zsh_plugins=${ZDOTDIR}/.zsh_plugins
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt
fpath=(${ZDOTDIR}/.antidote/functions $fpath)
## BRR ZONE
autoload -Uz antidote
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi
##/ BRR ZONE
source ${zsh_plugins}.zsh

export EDITOR="nvim"

fpath=(${ZDOTDIR}/zsh-completions $fpath)

autoload bashcompinit && bashcompinit
autoload -U compinit; compinit

user=$(whoami)
# Source city
source ${ZDOTDIR}/options.zsh
# Source autocompletions (and bindkey -v) BEFORE shortcuts to avoid overwriting bindings
source ${ZDOTDIR}/autocompletions.zsh
source ${ZDOTDIR}/cli-replacement-aliases.zsh
source ${ZDOTDIR}/shortcuts.zsh


# Fixes starship funcnest error
# See https://github.com/starship/starship/issues/3418#issuecomment-1711630970
type starship_zle-keymap-select >/dev/null || \
{
  eval "$(starship init zsh)"
}


# Keybinds for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias sz="source ${ZDOTDIR}/.zshrc"
source ${ZDOTDIR}/fuzzy/git.zsh

# Add Standard GNU Tools to path
# see: https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da
path=(${(@s/:/)PATH})
path=(${path:#<->})
typeset -U path PATH manpath MANPATH
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  # gnubin; gnuman
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
    [[ -d $d ]] && path=($d $path)
  done
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do
    [[ -d $d ]] && manpath=($d $manpath)
  done
fi

if [[ -d "/opt/homebrew/opt/libpq/bin/" ]]; then
    export PATH="/opt/homebrew/opt/libpq/bin/:$PATH"
fi
