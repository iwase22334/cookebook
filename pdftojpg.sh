#!/bin/bash

## Help
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage : pdftoimage.sh <file>"
    exit 1
fi


## Check Argument
input="$1"
title="${input%.*}"
ext="${input#*.}"

## Process
mkdir -p "$title"

echo Prepareing image files.
if [ "$ext" == "pdf" ]; then
    echo "    it would take time ..."
    pdftoppm -jpeg "$title".pdf "$title"/"$title"

else
    echo "    not supported" "$ext"

fi
