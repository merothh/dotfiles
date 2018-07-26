#!/bin/bash

release=$(head /etc/os-release -n 1 | cut -d '"' -f 2)

case $release in 
	"Arch Linux"|"Antergos Linux"|"Manjaro Linux")

		echo "Installing required packages"
		sudo pacman -Sy i3-wm i3blocks i3lock dmenu scrot alsa-utils sysstat acpi feh playerctl xorg-xbacklight rxvt-unicode urxvt-perls adapta-gtk-theme papirus-icon-theme lxappearance

		#cleanup leftovers
		rm -rf ~/.config/i3 ~/.i3 ~/.fonts/Font-Awesome

		#make sure directories are present
		mkdir -p ~/{.fonts,.config}
		mkdir -p ~/Pictures/Screenshots

		#symlink all the goodies
		ln -s ~/dotfiles/.config/i3/ ~/.config/i3 
		ln -s ~/dotfiles/.fonts/Font-Awesome/ ~/.fonts/Font-Awesome
		ln -s ~/dotfiles/.Xresources ~/.Xresources

	;;
	*)
		echo "woops. you're not running an Arch based distro"
	;;

esac
