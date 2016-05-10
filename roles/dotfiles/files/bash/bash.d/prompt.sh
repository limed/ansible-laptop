GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS="yes"

if [[ `type -t __git_ps1` = "function" ]]; then
    GITPS1='$(__git_ps1 "(%s)")'
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}'"$GITPS1"': ${PWD/$HOME/~}\007"'
    ;;
    xterm-color)
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\][\u@\h]'"$GITPS1"'\033[00m\]\033[01;34m\][\w]\033[00m\]\$ '
    ;;
    *)
        #PS1='${debian_chroot:+($debian_chroot)}[\[\u@\h][\033[1;34m\w\[\033[0m]$ '
        #PS1='${debian_chroot:+($debian_chroot)}[\u@\h][\w]$ '
    ;;
esac

# Colorize root
if [ $(id -u) -eq 0 ]; then # you are root, set red colour prompt
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\]'"$GITPS1"'\W \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]'"$GITPS1"':\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
