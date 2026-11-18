#!/bin/sh
# Downloads cnlab.sh into the current folder and opens the menu.
# Usage: curl -sL is.gd/<link> | sh
URL=https://raw.githubusercontent.com/biradarvenkatesh01/pdfs/main/cnlab.sh
if command -v curl >/dev/null 2>&1; then
    curl -sL "$URL" -o cnlab.sh
else
    wget -qO cnlab.sh "$URL"
fi
echo "Saved: $PWD/cnlab.sh"
exec bash cnlab.sh < /dev/tty
