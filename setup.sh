#!/bin/bash

cyan='tput setaf 6'
yellow='tput setaf 3'

release=$(head /etc/os-release -n 1 | cut -d '"' -f 2)

case $release in 
	"Arch Linux"|"Antergos Linux"|"Manjaro Linux")

		echo -e "\n$($cyan)Installing required packages"
		sudo pacman -Sy i3-wm i3blocks i3lock dmenu scrot alsa-utils sysstat acpi feh playerctl xorg-xbacklight rxvt-unicode urxvt-perls adapta-gtk-theme papirus-icon-theme lxappearance

		#cleanup leftovers
		rm -rf ~/.config/i3 ~/.i3 ~/.fonts/{Font-Awesome,Inconsolata-for-Powerline}

		#make sure directories are present
		mkdir -p ~/{.fonts,.config}
		mkdir -p ~/Pictures/Screenshots

		#symlink all the goodies
		ln -s ~/dotfiles/.config/i3/ ~/.config/i3 
		ln -s ~/dotfiles/.fonts/Font-Awesome/ ~/.fonts/Font-Awesome
		ln -s ~/dotfiles/.fonts/Inconsolata-for-Powerline ~/.fonts/Inconsolata-for-Powerline
		ln -s ~/dotfiles/.Xresources ~/.Xresources

		echo -e "\n$($cyan)All done. Make sure to set themes and fonts using $($yellow)lxappearance $($cyan)after logging into i3wm"
	;;
	*)
		echo -e "\n$($cyan)woops. you're not running an Arch based distro"
	;;

esac
