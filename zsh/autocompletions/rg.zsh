if command -v rg >/dev/null 2>&1; then
    source <(rg --generate=complete-zsh)
fi
