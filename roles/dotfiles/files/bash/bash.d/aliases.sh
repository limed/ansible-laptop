# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias rdns='dscacheutil -q host -a ip_address'
    alias dhost='dscacheutil -q host -a name'
    alias dip='dscacheutil -q host -a ip_address'
fi

# some more ls aliases
alias ll='ls -lahoF'
alias la='ls -A'
alias l='ls -CF'
alias mv='mv -i'
#alias cp='cp -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias mplayer='mplayer -nojoystick -nolirc '
alias ncmpc='ncmpc --colors'
alias gam='~/gam/gam'
alias git='hub'
alias awsenv='env | grep AWS'
alias awsexpire="date -d @${AWS_SESSION_EXPIRATION}"
alias kubeenv='env | grep KUBECONFIG'
alias nubisctl='~/nubis/nubis-ctl/nubis-ctl'
alias saferm='shred -vfz -u -n 10'
alias terrafmt="terraform fmt -write=true -diff=true"
alias kns="kubens"
alias kctx="kubectx"
alias k="kubectl"
alias awsunset='unset AWS_ACCESS_KEY_ID; unset AWS_SECRET_ACCESS_KEY; unset AWS_SESSION_TOKEN; unset AWS_MAWS_PROFILE; unset AWS_SESSION_EXPIRATION;'
