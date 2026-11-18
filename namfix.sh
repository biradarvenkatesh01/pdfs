#!/bin/bash
# Fix NAM on new Kali/Ubuntu: NS2's tclcl replaces Tcl's "source" with a version that
# only accepts "source fileName", but Tcl/Tk 8.6.14+ call "source -encoding utf-8 file".
# This rewrites those calls to plain "source file" (all these files are plain ASCII).
set -e
echo "Patching Tcl/Tk script files..."
sudo grep -rlZ "source -encoding utf-8" /usr/share/tcltk /usr/lib/tcltk 2>/dev/null | sudo xargs -0 -r sed -i 's/source -encoding utf-8 /source /g'
echo "Patching NS2's tclcl library..."
for LIB in $(find /usr/lib -name "libtclcl.so*" -type f 2>/dev/null); do
    sudo perl -pi -e 's/source -encoding utf-8 /source                 /g' "$LIB"
done
echo "Guarding ttk against being loaded twice..."
TTK=/usr/share/tcltk/tk8.6/ttk/ttk.tcl
if [ -f "$TTK" ] && ! grep -q "cnlab-namfix" "$TTK"; then
    sudo sed -i '1i if {[info exists ::ttk::__loaded]} return ;# cnlab-namfix\nset ::ttk::__loaded 1 ;# cnlab-namfix' "$TTK"
fi
LEFT=$(grep -rl "source -encoding utf-8" /usr/share/tcltk /usr/lib/tcltk 2>/dev/null | wc -l)
echo "Files still using 'source -encoding': $LEFT (should be 0)"
echo "Done. Test with: nam lab1.nam"
