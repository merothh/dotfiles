#!/bin/bash

cyan='tput setaf 6'
yellow='tput setaf 3'
reset='tput sgr0'

release=$(head /etc/os-release -n 1 | cut -d '"' -f 2)

echo -e "\n$($cyan)// Switch to $($yellow)zsh $($cyan)+ $($yellow)oh-my-zsh-git $($cyan)? [y/n]$($reset)?"
read zsh

case $release in 
	"Arch Linux"|"Antergos Linux"|"Manjaro Linux")

		packages=" i3-wm i3lock rofi picom scrot feh playerctl rxvt-unicode urxvt-perls adwaita-icon-theme papirus-icon-theme lxappearance otf-font-awesome noto-fonts bdf-unifont"

		echo -e "\n$($cyan)// Installing required packages$($reset)\n"
		sudo pacman -S $packages

		echo -e "\n$($cyan)// Installing AUR packages$($reset)\n"
		aur_packages="polybar ttf-comfortaa termsyn-font"
		aur_dependencies="git base-devel"

		if [ "$zsh" = "y" ]; then

			aur_packages+=" oh-my-zsh-git"
			aur_dependencies+=" zsh"
		fi

		echo -e "\n$($cyan)Installing dependencies for building $($yellow) AUR packages $($reset)\n"
		sudo pacman -S $aur_dependencies

		echo -e "\n$($cyan)// Cloning & Building $($yellow)AUR packages$($reset)\n"
		for aur_package in $aur_packages
		do
			echo -e "\n$($yellow)$aur_package$($reset)\n"
			git clone https://aur.archlinux.org/$aur_package .build
			cd .build && makepkg -si
			cd ../
			rm -rf .build
		done

	;;
	"Ubuntu")

		echo -e "\n$($yellow)Ubuntu $($cyan)support has been disabled due to me not having a system to test the script anymore. If you are indeed using $($yellow) Ubuntu $($cyan) feel free to let me know about it.$($reset)"
		exit

		:'
		echo -e "\n$($cyan)// Adding PPA for $($yellow) adapta-gtk-theme $($cyan) && $($yellow) papirus-icon-theme$($reset)\n"
		sudo add-apt-repository ppa:papirus/papirus
		sudo add-apt-repository ppa:tista/adapta

		packages+=" i3-wm i3blocks i3lock rofi compton scrot alsa-utils sysstat acpi feh xbacklight rxvt-unicode adapta-gtk-theme adwaita-icon-theme-full papirus-icon-theme lxappearance"

		echo -e "\n$($cyan)// Installing required packages$($reset)\n"
		sudo apt install $packages

		#clone/install oh-my-zsh
		if [ "$zsh" = "y" ]; then

			echo -e "\n$($cyan)// Installing $($yellow)oh-my-zsh$($reset)\n"
			sudo apt install git zsh
			sudo rm -rf ~/.oh-my-zsh /usr/share/oh-my-zsh
			sudo git clone https://github.com/robbyrussell/oh-my-zsh /usr/share/oh-my-zsh

		fi
		'
	;;
	*)
		echo -e "\n$($cyan)// woops. you're probably not running an $($yellow)Arch $($blue)or $($yellow)Ubuntu $($cyan)based distro$($reset)\n"
	;;

esac

#cleanup leftovers
rm -rf ~/.config/{i3,git,polybar,rofi,termite} ~/{.i3} ~/.fonts/{Inconsolata-for-Powerline,MaterialIcons-Regular,Ubuntu-Nerd-Font-Complete}

#make sure directories are present
mkdir -p ~/{.fonts,.config}
mkdir -p ~/Pictures/Screenshots

#symlink all the goodies
ln -s ~/dotfiles/.config/i3 ~/.config/i3
ln -s ~/dotfiles/.config/git ~/.config/git
ln -s ~/dotfiles/.config/polybar ~/.config/polybar
ln -s ~/dotfiles/.config/rofi ~/.config/rofi
ln -s ~/dotfiles/.config/termite ~/.config/termite
ln -s ~/dotfiles/.fonts/Inconsolata-for-Powerline ~/.fonts/Inconsolata-for-Powerline
ln -s ~/dotfiles/.fonts/MaterialIcons-Regular ~/.fonts/MaterialIcons-Regular
ln -s ~/dotfiles/.fonts/Ubuntu-Nerd-Font-Complete ~/.fonts/Ubuntu-Nerd-Font-Complete

echo -e "\n$($cyan)// Backing up any previous $($yellow).Xresources $($cyan)& symlinking new one$($reset)\n"
if [ -f ~/.Xresources ]; then
	mv ~/.Xresources ~/.Xresources.old
fi
ln -s ~/dotfiles/.Xresources ~/.Xresources

if [ "$zsh" = "y" ]; then

	echo -e "\n$($cyan)// Backing up any previous $($yellow).zshrc $($cyan)& symlinking new one$($reset)\n"
	if [ -f ~/.zshrc ]; then
		mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh
	fi
	ln -s ~/dotfiles/.zshrc ~/.zshrc

	echo -e "\n$($cyan)// Changing default shell to $($yellow)zsh$($reset)\n"
	chsh -s $(which zsh)
fi

echo -e "\n$($cyan)// All done. Make sure to \n	1.Set themes and fonts using $($yellow)lxappearance $($cyan)after logging into i3wm\n	2.Log out and back in for $($yellow)zsh $($cyan)to kick in\n	3.Maybe move useful code from $($yellow).zshrc.pre-oh-my-zsh $($cyan)or $($yellow).bashrc\n	$($cyan)4.Keep your old $($yellow).bashrc .zshrc.pre-oh-my-zsh .Xresources.old $($cyan)tucked off somewhere$($reset)"
