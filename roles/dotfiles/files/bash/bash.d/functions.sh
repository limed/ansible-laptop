function abort() {
    echo $*
    exit 1
}

function get_ldap_password() {
    if [ -z $1 ]; then echo "Usage: $FUNCNAME [password file]"; return 1; fi
    local passwd_file=$1
    gpg --use-agent --batch -q -d ~/.passwd/${passwd_file}
}

function get_ldap_password_gpg() {
    gpg --use-agent --batch -q -d ~/.passwd/mozilla.gpg
}

function ldap_query_admin() {
    ldapsearch -LLL -o ldif-wrap=no -x -D "mail=elim_la@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password mozilla_la.asc)" -h 127.0.0.1 -p 9090 -b dc=mozilla $1 $2
}

function ldap_query() {
    ldapsearch -LLL -o ldif-wrap=no -x -D "mail=elim@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password_gpg)" -h 127.0.0.1 -p 9090 -b dc=mozilla $1 $2
}

function load_ldif() {
    local ldif_file=$1
    read -p "You are about to load ${ldif_file} to ldapmaster1.db.scl3.mozilla.com, are you sure? [y/n]: " answer
    if [[ $answer == 'y' ]]; then
        echo "Loading ldif file: ${ldif_file}"
        ldapmodify -x -D "mail=elim_la@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password mozilla_la.asc)" -h ldapmaster1.db.scl3.mozilla.com -f $1
        return 0
    elif [[ $answer == 'n' ]]; then
        echo "Not doing anything, exiting"
        return 1
    else
        echo "Invalid input"
        return 1
    fi
}

function load_ldif_dev() {
    local ldif_file=$1
    read -p "You are about to load ${ldif_file} to ldapmaster1.dev.db.scl3.mozilla.com, are you sure? [y/n]: " answer
    if [[ $answer == 'y' ]]; then
        echo "Loading ldif file: ${ldif_file}"
        ldapmodify -x -D "mail=elim_la@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password mozilla_la.asc)" -h ldapmaster1.dev.db.scl3.mozilla.com -f $1
        return 0
    elif [[ $answer == 'n' ]]; then
        echo "Not doing anything, exiting"
        return 1
    else
        echo "Invalid input"
        return 1
    fi
}

function myip() {
    local arg=$1

    local curl_cmd='curl --retry 5 -s -fq http://ipinfo.io'
    local output
    if [[ "$arg" == '--verbose' ]]; then
        output=$(${curl_cmd} | python -m'json.tool')
    else
        output=$(${curl_cmd} | python -c 'import sys, json; print json.load(sys.stdin)["ip"]')
    fi
    echo "${output}"
}

function gocd() {
    cd $(go list -f '{{.Dir}}' $1)
}

function aws-vault() {
    local aws_vault_cmd=$(which aws-vault)

    if [ -z "${aws_vault_cmd}" ]; then
        echo "aws-vault is not on your path you do not have it installed"
        exit 1
    fi
    case "$1" in
        exec)
            local action=$1
            shift 1
            local profile=$1
            shift 1
            local options="--assume-role-ttl=1h --session-ttl=4h"
            #${aws_vault_cmd} ${action} ${profile} ${options} -- $@
            ${aws_vault_cmd} ${action} ${profile} ${options} $@
        ;;
        *)
            ${aws_vault_cmd} $@
        ;;
    esac
}

# docker fucntions
function drm() {
    docker rm $(docker ps -f "status=exited" -q -a)
}

function drmi() {
    docker rmi $(docker images -qf dangling=true)
}

function drmv() {
    docker volume rm $(docker volume ls -qf dangling=true)
}
