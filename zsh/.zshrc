# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"
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
export PNPM_HOME="/home/snooze/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"
