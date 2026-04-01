[[ -f "${HOME}/.local/bin/env" ]] && . "$HOME/.local/bin/env"
[[ -f "${HOME}/.cargo/env" ]] && . "$HOME/.cargo/env"
export PATH=$HOME/.cargo/bin:$PATH # Add cargo bin
export PATH=$HOME/0files/cli-tools/uv/.venv/bin:$PATH # Add uv global python install

export EDITOR="nvim"

fpath=(${ZDOTDIR}/zsh-completions $fpath)

autoload bashcompinit && bashcompinit
autoload -U compinit; compinit

user=$(whoami)
# Source city
source ${ZDOTDIR}/options.zsh
source ${ZDOTDIR}/cli-replacement-aliases.zsh
source ${ZDOTDIR}/functions.zsh
source ${ZDOTDIR}/shortcuts.zsh


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
source ${ZDOTDIR}/fuzzy/git.zsh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


[[ -d "$HOME/.krew" ]] && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Add Standard GNU Tools to path
# see: https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  NEWPATH=${PATH}
  # gnubin; gnuman
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do NEWPATH=$d:$NEWPATH; done
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
 export PATH=$(echo ${NEWPATH} | tr ':' '\n' | cat -n | sort -uk2 | sort -n | cut -f2- | xargs | tr ' ' ':')
fi
