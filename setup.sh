#!/bin/bash

cyan='tput setaf 6'
yellow='tput setaf 3'
reset='tput sgr0'

release=$(head /etc/os-release -n 1 | cut -d '"' -f 2)

echo -e "\n$($cyan)// Switch to $($yellow)zsh $($cyan)+ $($yellow)oh-my-zsh-git $($cyan)? [y/n]$($reset)?"
read zsh

if [ "$zsh" = "y" ]; then
	packages+="zsh git base-devel"
fi

case $release in 
	"Arch Linux"|"Antergos Linux"|"Manjaro Linux")

		packages+=" i3-wm i3blocks i3lock dmenu scrot alsa-utils sysstat acpi feh playerctl xorg-xbacklight rxvt-unicode urxvt-perls adapta-gtk-theme papirus-icon-theme lxappearance"

		echo -e "\n$($cyan)// Installing required packages$($reset)\n"
		sudo pacman -S $packages

		#cleanup leftovers
		rm -rf ~/.config/i3 ~/{.i3,.zshrc} ~/.fonts/{Font-Awesome,Inconsolata-for-Powerline}

		#make sure directories are present
		mkdir -p ~/{.fonts,.config}
		mkdir -p ~/Pictures/Screenshots

		#symlink all the goodies
		ln -s ~/dotfiles/.config/i3/ ~/.config/i3 
		ln -s ~/dotfiles/.fonts/Font-Awesome/ ~/.fonts/Font-Awesome
		ln -s ~/dotfiles/.fonts/Inconsolata-for-Powerline ~/.fonts/Inconsolata-for-Powerline

		echo -e "\n$($cyan)// Backing up any previous $($yellow).Xresources $($cyan)& symlinking new one$($reset)\n"
		if [ -f ~/.Xresources ]; then
			mv ~/.Xresources ~/.Xresources.old
		fi
		ln -s ~/dotfiles/.Xresources ~/.Xresources

		#setup zsh & oh-my-zsh
		if [ "$zsh" = "y" ]; then
			echo -e "\n$($cyan)// Changing default shell to $($yellow)zsh$($reset)\n"
			chsh -s $(which zsh)

			echo -e "\n$($cyan)// Cloning & Building $($yellow)oh-my-zsh-git$($reset)\n"
			git clone https://aur.archlinux.org/oh-my-zsh-git .build
			cd .build && makepkg -si
			cd ../
			rm -rf .build

			echo -e "\n$($cyan)// Backing up any previous $($yellow).zshrc $($cyan)& symlinking new one$($reset)\n"
			if [ -f ~/.zshrc ]; then
				mv ~/.zshrc ~/.zshrc.old
			fi
			ln -s ~/dotfiles/.zshrc ~/.zshrc
		fi

		echo -e "\n$($cyan)// All done. Make sure to \n	1.Set themes and fonts using $($yellow)lxappearance $($cyan)after logging into i3wm\n	2.Maybe move useful code from $($yellow).zshrc.old $($cyan)or $($yellow).bashrc\n	$($cyan)3.Keep your old $($yellow).bashrc .zshrc.old .Xresources.old $($cyan)tucked off somewhere"
	;;
	*)
		echo -e "\n$($cyan)// woops. you're not running an Arch based distro\n"
	;;

esac
