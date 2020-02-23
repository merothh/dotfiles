# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

if [ -f $HOME/.exports ]; then
	source $HOME/.exports
fi

# source powerlevel10k zsh theme
[ ! -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ] || source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# powerlevel10k configs | To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ ! -f ~/.p10k.zsh ] || source ~/.p10k.zsh
