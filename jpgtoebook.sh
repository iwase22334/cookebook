#!/bin/bash

## Help
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage : jpgtoebook.sh <dir> [-v]"
    echo "  -v : vertical aligned text"
    exit 1
fi


## Check Argument
input="$1"
title="${input%.*}"

for OPT in "$@"; do
    case $OPT in
        -v)
            FL_Vertical=1
            ;;
    esac
    shift
done


echo OCR working ...
if [ "$FL_Vertical" ]; then
    TESSERACT_LANG=jpn_vert
else
    TESSERACT_LANG=jpn
fi

while read -r f; do
    echo "    " processing "$f"
    if ! tesseract "$f" "${f%.*}" -l $TESSERACT_LANG pdf; then
        exit 1
    fi
done < <(find "$title" -type f -name '*.jpg')


echo Unite pdf ...
if ! pdfunite $(find "$title"/ -type f -name '*.pdf' | sort -V | tr \\n \\0 | xargs -0) "$title"-text.pdf; then
    exit 1
fi


echo Compressing ...
if ! gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/ebook \
    -dAutoRotatePages=/None \
    -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile="$title"-ebook.pdf "$title"-text.pdf; then
    exit 1
fi

rm "$title"-text.pdf
