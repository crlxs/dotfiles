# Keep the rest of the Zsh configuration under XDG_CONFIG_HOME.
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[ ! -r "$ZDOTDIR/.zshenv" ] || . "$ZDOTDIR/.zshenv"
