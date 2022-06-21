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
    if [ -e "$f".pdf ]; then
        echo "    " skip "$f"
        continue
    fi

    if ! tesseract "$f" "$f" -l $TESSERACT_LANG pdf; then
        exit 1
    fi
done < <(find "$input" -maxdepth 1 -type f -name '*.'"$EXT")


echo Unite pdf ...

if [ ! -e "$input"/"$title"-text.pdf ]; then
    array=()
    while IFS=  read -r -d $'\0'; do
        array+=("$REPLY")
    done < <(find "$input"/ -maxdepth 1 -type f -name '*.pdf' | sort -V | tr '\n' '\0')

    if ! pdfunite "${array[@]}" "$input"/"$title"-text.pdf; then

        exit 1
    fi
fi


echo Compressing ...
if ! gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/ebook \
    -dAutoRotatePages=/None \
    -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile="$input"/"$title"-ebook.pdf "$input"/"$title"-text.pdf; then
    exit 1
fi

rm "$input"/"$title"-text.pdf
