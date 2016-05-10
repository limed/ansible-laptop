KEYCHAIN=$(which keychain)
if [[ -z "${KEYCHAIN}" ]]; then
    echo "Please install keychain"
fi

KEYS=(id_rsa id_rsa_boomer)

if [ -d ${HOME}/.ssh ] || [ -d ${HOME}/.gnupg ]; then
    for i in ${KEYS[@]}; do
        keychain --nogui ${i}
    done
    [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
    [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && source $HOME/.keychain/$HOSTNAME-sh-gpg
else
    echo "[WARN]: .ssh or .gnupg folder does not exists"
fi
