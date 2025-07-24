. "$HOME/.local/bin/env"
export PATH=$HOME/.cargo/bin:$PATH # Add cargo bin

autoload bashcompinit && bashcompinit
autoload -U compinit; compinit

user=$(whoami)
# Source city
source ${ZDOTDIR}/options.zsh
source ${ZDOTDIR}/cli-replacement-aliases.zsh

eval "$(starship init zsh)"

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

alias v="nvim"
alias sz="source ${ZDOTDIR}/.zshrc"

source ${ZDOTDIR}/autocompletions.zsh
