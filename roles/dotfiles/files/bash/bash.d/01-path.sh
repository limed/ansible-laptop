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
        COREUTIL_PATH="$(brew_get_prefix coreutils)/libexec/gnubin"
        GNUSED_PATH="$(brew_get_prefix gnu-sed)/libexec/gnubin"
        FINDUTIL_PATH="$(brew_get_prefix findutils)/libexec/gnubin"
        PATH="${GNUSED_PATH}:${COREUTIL_PATH}:${FINDUTIL_PATH}:/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
    ;;
    linux*)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
    ;;
    *)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
esac

export PATH
export GOPATH
export GO15VENDOREXPERIMENT=1
