#!/bin/sh
# Fix NAM on new Ubuntu/Kali (NAM prints only "nam:" and exits).
# NS2's tclcl library has two problems with new Tk versions:
#  1. It replaces Tcl's "source" command with one that rejects
#     "source -encoding utf-8 file", which new Tk uses at startup.
#  2. Its built-in copy of Tk's startup script loads ttk.tcl a second time;
#     Tk 8.6.15+ refuses this ("Duplicate element Combobox.downarrow").
# This changes 4 bytes in libtclcl to fix both. NS2 results are unchanged.
# Usage: curl -sL is.gd/uvcenam | sudo sh
L=$(readlink -f /usr/lib/x86_64-linux-gnu/libtclcl.so.1 2>/dev/null)
[ -f "$L" ] || L=$(find /usr/lib -name 'libtclcl.so*' -type f 2>/dev/null | head -1)
if [ ! -f "$L" ]; then
    echo "libtclcl not found. Install NS2 first: sudo apt install -y ns2 nam"
    exit 1
fi
[ -f "$L.bak" ] || cp "$L" "$L.bak"
perl -pi -e 's/^rename source source\.orig$/#ename source source.orig/; s/^proc source \{fileName\} \{$/proc sourcX {fileName} {/; s/^if \{\$::ttk::library ne ""\} \{$/if {\$::ttk::library eq ""} {/' "$L"
ok=0
grep -q '#ename source source.orig' "$L" && ok=$((ok+1))
grep -q 'proc sourcX {fileName}' "$L" && ok=$((ok+1))
grep -q 'if {$::ttk::library eq ""}' "$L" && ok=$((ok+1))
if [ "$ok" -eq 3 ]; then
    echo "NAM fixed (3/3 changes applied). Try: nam lab1.nam"
else
    echo "Only $ok/3 changes applied. Send a screenshot of this output."
    exit 1
fi
