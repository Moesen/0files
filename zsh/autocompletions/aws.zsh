[[ -f /usr/local/bin/aws_completer ]] && complete -C '/usr/local/bin/aws_completer' aws
if [[ -f ~/.local/share/amazon-q/shell/zshrc.pre.zsh ]]
then
    echo "Sourcing amazon-q"
    source ~/.local/share/amazon-q/shell/zshrc.pre.zsh
    source ~/.local/share/amazon-q/shell/zshrc.post.zsh
fi
