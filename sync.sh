#!/bin/bash

# function to handle the 'up' command
up() {
	echo "copying ~/.config files to current directory..."
	rm -rf .config/
	mkdir -p .config
	cp -r ~/.config/* .config/

	echo "creating git commit..."
	current_datetime=$(date +"%y-%m-%d_%h-%m-%s")
	git add .
	git commit -m "sync:$current_datetime"

	echo "pushing to remote repository..."
	git push

	echo "sync up completed!"
}

# function to handle the 'down' command
down() {
	# check if backup exists
	if [ -d ~/config.bak ]; then
		read -p "backup already exists. overwrite? (y/n): " choice
		case "$choice" in
		y | y)
			echo "removing old backup..."
			rm -rf ~/config.bak
			echo "creating new backup of ~/.config..."
			cp -r ~/.config ~/config.bak
			;;
		*)
			echo "skipping backup creation."
			;;
		esac
	else
		echo "creating backup of ~/.config..."
		cp -r ~/.config ~/config.bak
	fi

	echo "copying .config from current directory to ~/.config..."
	rm -rf ~/.config
	cp -r .config ~/.config

	echo "sync down completed!"
}

# main script logic
if [ "$#" -ne 1 ]; then
	echo "usage: $0 {up|down}"
	exit 1
fi

case "$1" in
up)
	up
	;;
down)
	down
	;;
*)
	echo "invalid command. use 'up' or 'down'."
	exit 1
	;;
esac
