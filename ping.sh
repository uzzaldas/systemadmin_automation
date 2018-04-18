#!/bin/bash
# catx - a script to read text
# from a text file and paste it
# to the clipboard.

FNAME=$1

if [[ -z "$FNAME" ]]; then
 echo "catx <name of file>"
 echo " catx is a script to read text from a"
 echo " text file and paste it to the clipboard."
 exit;
fi

cat "$FNAME" | pbcopy
exit;
