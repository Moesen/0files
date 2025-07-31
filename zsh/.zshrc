. "$HOME/.local/bin/env"
export PATH=$HOME/.cargo/bin:$PATH # Add cargo bin
export PATH=$HOME/0files/cli-tools/uv/.venv/bin:$PATH # Add uv global python install

autoload bashcompinit && bashcompinit
autoload -U compinit; compinit

user=$(whoami)
# Source city
source ${ZDOTDIR}/options.zsh
source ${ZDOTDIR}/cli-replacement-aliases.zsh

# Fixes starship funcnest error
# See https://github.com/starship/starship/issues/3418#issuecomment-1711630970
type starship_zle-keymap-select >/dev/null || \
{
  eval "$(starship init zsh)"
}

# Antidote (Package manager)
zsh_plugins=${ZDOTDIR}/.zsh_plugins
[[ -f {zsh_plugins}}.txt ]] || touch ${zsh_plugins}.txt
fpath=(${ZDOTDIR}/.antidote/functions $fpath)
## BRR ZONE
autoload -Uz antidote
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi
##/ BRR ZONE
source ${zsh_plugins}.zsh

alias sz="source ${ZDOTDIR}/.zshrc"

source ${ZDOTDIR}/autocompletions.zsh
