#!/bin/sh

PATH="/usr/share/teclasat:/usr/lib/teclasat:$PATH"

# no user configuration available
if [ ! -d "$HOME"/.tecla ]; then
	mkdir -p "$HOME"/.tecla
	if [ -e /usr/share/teclasat/teclasat.desktop ]; then
		# place an icon on the desktop
		mkdir -p "$HOME"/Desktop
		install -m 0644 /usr/share/teclasat/teclasat.desktop "$HOME"/Desktop/
		echo "installing desktop link"
	fi
fi

# start teclasat
exec /usr/share/teclasat/tecla%TECLA_VER%-%TECLA_BUILD%.sh &

