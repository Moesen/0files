set-font-big ()
{
    sed -i -E 's/^font-size=[0-9]+$/font-size=22/' "$HOME/0files/terms/ghostty/config" && pkill -USR2 -x ghostty
}

set-font-small ()
{
    sed -i -E 's/^font-size=[0-9]+$/font-size=16/' "$HOME/0files/terms/ghostty/config" && pkill -USR2 -x ghostty
}
