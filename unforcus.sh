#!/bin/bash

## Help
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage : unforcus.sh <dir>"
    exit 1
fi

input="$1"
title="${input%.*}"

while read -r n; do
    echo -n "$n:"
    convert "$n" -statistic StandardDeviation 3x3 -format "%[fx:maxima]\n" info:
done < <(find "$title" -type f -name '*.jpg' | sort -V ) | tee unforcus.txt

echo "check yourself these files"
sort -t ':' -k 2 -n < unforcus.txt | head -n 20
