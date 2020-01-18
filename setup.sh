#!/bin/bash

cyan='tput setaf 6'
yellow='tput setaf 3'
reset='tput sgr0'

release=$(head /etc/os-release -n 1 | cut -d '"' -f 2)

echo -e "\n$($cyan)// Switch to $($yellow)zsh $($cyan)+ $($yellow)oh-my-zsh-git $($cyan)? [y/n]$($reset)?"
read zsh

case $release in 
	"Arch Linux"|"Manjaro Linux")

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

backup_list=(.vimrc .Xresources)
if [ "$zsh" = "y" ]; then
	backup_list+=(.zshrc)
	echo -e "\n$($cyan)// Changing default shell to $($yellow)zsh$($reset)\n"
	chsh -s $(which zsh)
fi

rm -rf ~/dotfiles/.backup; mkdir ~/dotfiles/.backup
for file in ${backup_list[*]}
do
	cp ~/$file ~/dotfiles/.backup
done

symlink_list=(.config/i3 .config/git .config/polybar .config/rofi .fonts/Inconsolata-for-Powerline .fonts/Material-Icons .vimrc .Xresources)
# cleanup previous files if any
for file in ${symlink_list[*]}
do
	rm -rf ~/$file
done

# make sure directories we need are present
dir_list=(.fonts .config Pictures/Screenshots)
for dir in ${dir_list[*]}
do
	mkdir -p ~/$dir
done

# go ahead and symlink everything
for file in ${symlink_list[*]}
do
    ln -s ~/dotfiles/$file ~/$file
done

echo -e "\n$($cyan)// All done. Make sure to \n	1. Set themes and fonts using $($yellow)lxappearance $($cyan)after logging into i3wm\n	2. Log out and back in for $($yellow)zsh $($cyan)to kick in\n	3. Your previous $($yellow).bashrc .zshrc .Xresources $($cyan) are at $($yellow) ~/dotfiles/.backup $($cyan)\n	4. Maybe move useful code from previous $($yellow).zshrc $($cyan)or $($yellow).bashrc\n $($reset)"
