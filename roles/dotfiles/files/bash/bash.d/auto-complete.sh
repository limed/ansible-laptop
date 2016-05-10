# bash autocomplete

# aws cli bash autocomplete
complete -C aws_completer aws

# We assume that its only linux or mac
# so just 2 conditions here
if [[ "$OSTYPE" == "darwin*" ]]; then
    # assumes you install bash_completion in brew
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
        . /usr/local/etc/bash_completion.d/git-completion.bash
    fi
else
    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
