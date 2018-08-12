# Path environment variable goes here

GOPATH="${HOME}/go"

# basic os detection
case "$OSTYPE" in
    darwin*)
        PATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:$(/usr/local/bin/brew --prefix findutils)/libexec/gnubin:/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
    ;;
    linux*)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${NUBIS_BUILDER_PATH}:${GOPATH}/bin:$PATH"
    ;;
    *)
        PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${GOPATH}/bin:$PATH"
esac

export PATH
export GOPATH
export GO15VENDOREXPERIMENT=1
