export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Options for path completion (e.g. vim **<TAB>)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'

# Options for directory completion (e.g. cd **<TAB>)
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

# Options to make ctrl-t ignore .gitignore files
export FZF_DEFAULT_COMMAND="fd --type f --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments ($@) to fzf.
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --follow --hidden --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

fcd-widget() {
  local dir
  dir=$(fd --type d --follow --exclude .git --exclude __pycache__ --exclude node_modules | fzf \
    --preview 'eza --tree --icons --git --color=always {} | head -200' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $dir ]] then
    cd $dir
    zle reset-prompt
  fi
}
zle -N fcd-widget
bindkey "^E" fcd-widget

fzf_nvim() {
  local file
  file=$(fd --type f --follow --hidden --exclude .git | fzf \
    --preview 'bat -n --color=always {}' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $file ]]; then
    nvim $file
  fi
}
source <(fzf --zsh)
