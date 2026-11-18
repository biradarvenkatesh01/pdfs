#!/bin/sh
# Downloads cnlab.sh into the current folder and opens the menu.
# Usage: curl -sL is.gd/<link> | sh
# jsDelivr mirror first (works where raw.githubusercontent.com is blocked), GitHub as fallback
URL1=https://cdn.jsdelivr.net/gh/biradarvenkatesh01/pdfs@main/cnlab.sh
URL2=https://raw.githubusercontent.com/biradarvenkatesh01/pdfs/main/cnlab.sh
get() {
    if command -v curl >/dev/null 2>&1; then curl -fsL "$1" -o cnlab.sh
    else wget -qO cnlab.sh "$1"; fi
}
get "$URL1" || get "$URL2" || { echo "Download failed. Check your internet connection."; exit 1; }
echo "Saved: $PWD/cnlab.sh"
exec bash cnlab.sh < /dev/tty
