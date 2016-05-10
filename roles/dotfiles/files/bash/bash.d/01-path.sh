# Path environment variable goes here

NUBIS_BUILDER_PATH="${HOME}/nubis/nubis-builder/bin"
# basic os detection
case "$OSTYPE" in
    darwin*)
        PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:/usr/local/sbin:${HOME}/bin:${NUBIS_BUILDER_PATH}:$PATH"
    ;;
    linux*)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${NUBIS_BUILDER_PATH}:$PATH"
    ;;
    *)
        PATH="${HOME}/bin:$PATH"
esac
export PATH

