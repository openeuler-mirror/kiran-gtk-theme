#!/bin/sh
set -e

# Usage: create_folders <target-directory>
create_folders () {
    for j in gtk-2.0 gtk-3.0; do
        if ! [ -d "$1/$j" ]; then
            mkdir -p "$1/$j"
        fi
    done
}

render_metacity() {
    cp  -r metacity-1/ "$1"
    cp assets/window-close-symbolic.svg "$1/metacity-1/"
    cp assets/window-maximum-symbolic.svg "$1/metacity-1/"
    cp assets/window-minimum-symbolic.svg "$1/metacity-1/"
    cp assets/window-unmaximum-symbolic.svg "$1/metacity-1/"
    cp assets/thumbnail.png "$1/metacity-1/"
    cat "$2" | while read line; do
        key=`echo $line | sed -n 's/^\([^=]\+\)=\(.*\)$/\1/p'`
        value=`echo $line | sed -n 's/^\([^=]\+\)=\(.*\)$/\2/p'`
        sed -i "s/@$key/$value/g" "$1/metacity-1/metacity-theme-3.xml"
        sed -i "s/@$key/$value/g" "$1/metacity-1/metacity-theme-2.xml"
        sed -i "s/@$key/$value/g" "$1/metacity-1/metacity-theme-1.xml"
    done
}

# Usage render_theme <colorscheme> <theme-name> <theme-dir> <colorschemebase>
render_theme () {
    create_folders "$3"

    # index.theme
    sed -e "s/META_THEME_NAME/$2/g" -e "s/GTK_THEME_NAME/$2/g" index.theme > $3/index.theme

    # gtk2
    cp -R gtk2/* "$3/gtk-2.0/"

    # gtk3
    python3 render_assets.py -c "$1" -a "$3/assets" \
      -g "$3/gtk-2.0" -G "$3" -b "$4"

    sassc -I "$3" gtk3/gtk.scss "$3/gtk-3.0/gtk.css" 
    rm -f "$3/_global.scss"

    # assets
    cp -r assets/ "$3"

    # window manager
    render_metacity "$3" "$5"
}

COLOR_SCHEME=""
THEME_NAME=""
THEME_BUILD_DIR=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "$0: build Kiran theme"
            echo "Usage: $0 [-t THEME_NAME] [-c COLOR_FILE] [-d DEST_DIRECTORY]"
            echo
            echo "Arguments:"
            echo "  -h, --help                           show this help"
            echo "  -c, --color-scheme COLOR_SCHEME      use color scheme with name COLOR_SCHEME"
            echo "  -t, --theme-name   THEME_NAME        theme name"
            echo "  -d, --dest-dir     DEST_DIRECTORY    the directory to install the theme"
            exit 0
        ;;
        -c|--color-scheme)
            shift
            COLOR_SCHEME="$1"
        ;;
        -t|--theme-name)
            shift
            THEME_NAME="$1"
        ;;
        -d|--dest-dir)
            shift
            THEME_BUILD_DIR="$1"
        ;;
    esac
    shift
done


render_theme "./colors/${COLOR_SCHEME}.colors" "${THEME_NAME}" "${THEME_BUILD_DIR}" "./colors/base.colors" "./colors/metacity_${COLOR_SCHEME}.colors"
