# Zsh Config Home
export ZDOTDIR="${HOME}/0files/zsh"

# Antidote: use Homebrew install on macOS, local submodule elsewhere
if [[ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
elif [[ -f /usr/local/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /usr/local/opt/antidote/share/antidote/antidote.zsh
fi
# On Linux, antidote is loaded via fpath in .zshrc using the local submodule

# uv
export PATH="${HOME}/.local/bin:$PATH"
