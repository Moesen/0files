fcd-zellij-widget() {
    local layout_file
    layout_file=$(cd "$HOME/0files/cli-tools/zellij/layouts" && fd . --type f --ignore-file="${ZDOTDIR}/.fdignore" --strip-cwd-prefix | fzf \
    --preview 'bat -n --color=always {}' \
    --preview-window=right:60% \
    --border \
    --height=80%)
    if [[ -n $layout_file ]] then
        zellij --layout="$HOME/0files/cli-tools/zellij/layouts/$layout_file"
        zle reset-prompt
    fi
}
zle -N fcd-zellij-widget
bindkey "^N" fcd-zellij-widget

fcd-zellij-attach-widget() {
    local session_name
    session_name=$(zellij ls -s --no-formatting | fzf \
    --preview-window=right:60% \
    --border \
    --height=80%)
    if [[ -n $session_name ]] then
        zellij attach "$session_name"
        zle reset-prompt
    fi
}
zle -N fcd-zellij-attach-widget
bindkey "^A" fcd-zellij-attach-widget

### Dir search from home
fcd-home-widget() {
  local dir
  dir=$(cd "$HOME" && {echo "."; fd . --type d --follow --ignore-file="${ZDOTDIR}/.fdignore" --strip-cwd-prefix;} | fzf \
    --preview 'eza --tree --icons --git --color=always {} | head -200' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $dir ]] then
    cd "$HOME/$dir"
    zle reset-prompt
  fi
}
zle -N fcd-home-widget
bindkey "^H" fcd-home-widget

### Dir search from home and open in new zellij tab
fcd-home-zellij-tab-widget() {
  local dir target tab_name
  dir=$(cd "$HOME" && {echo "."; fd . --type d --follow --ignore-file="${ZDOTDIR}/.fdignore" --strip-cwd-prefix;} | fzf \
    --preview 'eza --tree --icons --git --color=always {} | head -200' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [[ -n $dir ]] then
    target="$HOME/$dir"
    tab_name="${target:t}"
    zellij action new-tab --cwd "$target" --name "$tab_name" >/dev/null
    zle reset-prompt
  fi
}
zle -N fcd-home-zellij-tab-widget
bindkey "^T" fcd-home-zellij-tab-widget

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
      dir=$(cd "$root" && {echo "."; fd . --type d --follow --ignore-file="${ZDOTDIR}/.fdignore" --strip-cwd-prefix;} | fzf \
        --preview 'eza --tree --icons --git --color=always {} | head -200' \
        --preview-window=right:60% \
        --border \
        --height=80%)
      if [[ -n $dir ]] then
        cd "$root/$dir"
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

### Open zellij layouts

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
