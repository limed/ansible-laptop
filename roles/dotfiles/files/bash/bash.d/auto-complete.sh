#!/usr/bin/env bash

# bash autocomplete

# aws cli bash autocomplete
complete -C aws_completer aws
complete -F __start_kubectl k

# lab (gitlab autocomplete)
_lab_completion() {
    export COMP_WORDBREAKS

    local compline="${COMP_LINE:0:${COMP_POINT}}"
    local IFS=$'\n'
    mapfile -t COMPREPLY < <(echo "$compline" | sed -e "s/ \$/ ''/" -e 's/"/\"/g' | xargs lab _carapace bash "_")
    [[ "${COMPREPLY[*]}" == "" ]] && COMPREPLY=() # fix for mapfile creating a non-empty array from empty command output

    [[ ${COMPREPLY[0]} == *[/=@:.,$'\001'] ]] && compopt -o nospace
    # TODO use mapfile
    # shellcheck disable=SC2206
    [[ ${#COMPREPLY[@]} -eq 1 ]] && COMPREPLY=(${COMPREPLY%$'\001'})
}

complete -F _lab_completion lab

# gcloud cli autocomplete
if [ -d "/usr/local/Caskroom/google-cloud-sdk" ]; then
    . /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
    . /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
fi

# Download autocomplete from
# https://raw.githubusercontent.com/99designs/aws-vault/master/completions/bash/aws-vault
if [ -f ${HOME}/.bash.d/aws-vault ]; then
    . ${HOME}/.bash.d/aws-vault
fi

# We assume that its only linux or mac
# so just 2 conditions here
if [[ "$OSTYPE" == "darwin"* ]]; then
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
