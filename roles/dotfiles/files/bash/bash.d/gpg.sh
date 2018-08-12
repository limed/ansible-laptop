GPG_AGENT=$(which gpg-agent)
if [[ -z "${GPG_AGENT}" ]]; then
    echo "Please install gpg-agent"
fi

pgrep gpg-agent > /dev/null
rv=$?
if [ "${rv}" -eq 1 ]; then
    eval $(gpg-agent --daemon)
fi
