# Path environment variable goes here

GOPATH="${HOME}/go"

brew_get_prefix() {
    local package=$1
    if [ "$(uname -s)" == "Darwin" ]; then
        /usr/local/bin/brew --prefix "${package}"
    fi
}

# basic os detection
case "$OSTYPE" in
    darwin*)
        BREW_PREFIX="/usr/local/opt"
        GETTEXT_PATH="${BREW_PREFIX}/gettext/bin"
        COREUTIL_PATH="${BREW_PREFIX}/coreutils/libexec/gnubin"
        GNUSED_PATH="${BREW_PREFIX}/gnu-sed/libexec/gnubin"
        FINDUTIL_PATH="${BREW_PREFIX}/findutils/libexec/gnubin"
        PATH="${GNUSED_PATH}:${COREUTIL_PATH}:${FINDUTIL_PATH}:${GETTEXT_PATH}:/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
    ;;
    linux*)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
    ;;
    *)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
esac

export PATH
export GOPATH
