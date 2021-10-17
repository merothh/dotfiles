# set PATH so it includes user's bin(s) if it exists
[ ! -d "$HOME/bin" ] || PATH="$HOME/bin:$PATH"
[ ! -d "$HOME/.local/bin" ] || PATH="$(find -L $HOME/.local/bin -type d | tr '\n' ':')$PATH"

export _JAVA_AWT_WM_NONREPARENTING=1
