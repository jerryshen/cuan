#!/bin/sh
# generate tag file for lookupfile plugin
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > filenametags
find . -regex  '.*?\(html\|htm\|js\|rb\|erb\|yml\|txt\|css\)' -type f -printf '%f\t%p\t1\n' | sort -f >> filenametags
