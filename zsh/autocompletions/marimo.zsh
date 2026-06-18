if command -v marimo >/dev/null 2>&1; then
    eval "$(_MARIMO_COMPLETE=zsh_source marimo)"
fi
