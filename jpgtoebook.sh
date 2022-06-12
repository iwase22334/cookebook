#!/bin/bash -ex

## Help
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage : jpgtoebook.sh [-v] [-e <ext>] <dir> "
    echo "  -v : vertical aligned text"
    echo "  -e : extention. default: jpg"
    exit 1
fi


## Check Argument
for OPT in "$@"; do
    case $OPT in
        -v)
            FL_Vertical=1
            shift 1
            ;;

        -e)
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit 1
            fi
            EXT="$2"
            shift 2
            ;;
    esac
done

input="$1"
title="$(basename "${input}")"

echo OCR working ...
if [ "$FL_Vertical" ]; then
    TESSERACT_LANG=jpn_vert
else
    TESSERACT_LANG=jpn
fi

while read -r f; do
    echo "    " processing "$f"
    if ! tesseract "$f" "$f" -l $TESSERACT_LANG pdf; then
        exit 1
    fi
done < <(find "$input" -type f -name '*.'"$EXT")


echo Unite pdf ...
if ! pdfunite $(find "$input"/ -type f -name '*.pdf' | sort -V | tr \\n \\0 | xargs -0) "$title"-text.pdf; then
    exit 1
fi


echo Compressing ...
if ! gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/screen \
    -dAutoRotatePages=/None \
    -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile="$title"-ebook.pdf "$title".pdf; then
    exit 1
fi

rm "$title"-text.pdf
