

THEME_NAME=""
COLOR_FILE=""
THEME_BUILD_DIR=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help)
      echo "$0: build Kiran theme"
      echo "Usage: $0 [-t THEME_NAME] [-c COLOR_FILE] [-d DEST_DIRECTORY]"
      echo
      echo "Arguments:"
      echo "  -h, --help                         show this help"
      echo "  -t, --theme-name THEME_NAME        theme name"
      echo "  -c, --color-file COLOR_FILE        base color file"
      echo "  -d, --dest-dir   DEST_DIRECTORY    the directory to install the theme"
      exit 0
    ;;
    -t|--theme-name)
      shift
      THEME_NAME="$1"
    ;;
    -c|--color-file)
      shift
      COLOR_FILE="$1"
    ;;
    -d|--dest-dir)
      shift
      THEME_BUILD_DIR="$1"
    ;;
  esac
  shift
done


if [ -z "${THEME_NAME}" ]; then
    THEME_NAME="KiranNew"
fi


mkdir -p ${THEME_BUILD_DIR}
sed -e "s/META_THEME_NAME/${THEME_NAME}/g" -e "s/GTK_THEME_NAME/${THEME_NAME}/g" index.theme > ${THEME_BUILD_DIR}/index.theme

# ---------------------------------------------------------  gtk2 ---------------------------------------------------------
THEME_GTK2_BUILD_DIR=${THEME_BUILD_DIR}/gtk-2.0
mkdir -p ${THEME_GTK2_BUILD_DIR}
cp gtk2/gtkrc ${THEME_GTK2_BUILD_DIR}


# ---------------------------------------------------------  gtk3 ---------------------------------------------------------
THEME_GTK3_BUILD_DIR=${THEME_BUILD_DIR}/gtk-3.0
mkdir -p ${THEME_GTK3_BUILD_DIR}
cp ${COLOR_FILE} ${THEME_GTK3_BUILD_DIR}/colors.scss
cp -r assets ${THEME_GTK3_BUILD_DIR}/
sassc -I ${THEME_GTK3_BUILD_DIR} gtk3/gtk.scss ${THEME_GTK3_BUILD_DIR}/gtk.css
rm ${THEME_GTK3_BUILD_DIR}/colors.scss