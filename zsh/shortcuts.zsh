### Dir search from home
fcd-home-widget() {
  local dir
  dir=$(fd . ~/ --type d --follow --ignore-file="${ZDOTDIR}/.fdignore"  | fzf \
    --preview 'eza --tree --icons --git --color=always {} | head -200' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $dir ]] then
    cd $dir
    zle reset-prompt
  fi
}
zle -N fcd-home-widget
bindkey "^H" fcd-home-widget

### Dir search from cur path
fcd-cur-widget() {
  local dir
  dir=$(fd --type d --follow --ignore-file="${ZDOTDIR}/.fdignore"  | fzf \
    --preview 'eza --tree --icons --git --color=always {} | head -200' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $dir ]] then
    cd $dir
    zle reset-prompt
  fi
}
zle -N fcd-cur-widget
bindkey "^E" fcd-cur-widget

### Dir search from root of repo if in repo
fcd-repo-root-widget() {
    local root
    root=$(git rev-parse --show-toplevel)
    local dir
      dir=$(fd . $root --type d --follow --ignore-file="${ZDOTDIR}/.fdignore"  | fzf \
        --preview 'eza --tree --icons --git --color=always {} | head -200' \
        --preview-window=right:60% \
        --border \
        --height=80%)
      if [[ -n $dir ]] then
        cd $dir
        zle reset-prompt
      fi
}
zle -N fcd-repo-root-widget
bindkey "^B" fcd-repo-root-widget

### File search and open in nvim
fzf_nvim() {
  local file
  file=$(fd --type f --follow --hidden --ignore-file="${ZDOTDIR}/.fdignore"  | fzf \
    --preview 'bat -n --color=always {}' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $file ]]; then
    nvim $file
  fi
}
zle -N fzf_nvim
bindkey "^F" fzf_nvim

### Fugitive shortcut
bindkey -s "^G^G" "nvim -c 'Git | only'\n"
