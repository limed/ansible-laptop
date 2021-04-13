#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

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
    read -r -p "You are about to load ${ldif_file} to ldapmaster1.dev.db.scl3.mozilla.com, are you sure? [y/n]: " answer
    if [[ $answer == 'y' ]]; then
        echo "Loading ldif file: ${ldif_file}"
        ldapmodify -x -D "mail=elim_la@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password mozilla_la.asc)" -h ldapmaster1.dev.db.scl3.mozilla.com -f "$1"
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
            local options="--duration=12h"
            ${aws_vault_cmd} ${action} ${profile} ${options} $@
        ;;
        *)
            ${aws_vault_cmd} "${@}"
        ;;
    esac
}

function goog() {
    local project_name=$1
    if [ -z "${project_name}" ]; then "Usage: $FUNCNAME [project name]"; return 1; fi

    if [ "${project_name}" == "ls" ]; then
        echo -e "${GREEN}Listing service accounts${NOCOLOR}"
        command ls --color --format=single-column "${HOME}/.gcloud"
        return 0
    elif [ "${project_name}" == "whoami" ]; then
        echo "${GOOGLE_APPLICATION_CREDENTIALS}"
        return 0
    fi

    FULLFILE="${1}"
    FILENAME=$(basename -- "${FULLFILE}")
    FILENAME="${FILENAME%.*}"
    export GOOGLE_PROJECT="${FILENAME}"
    export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.gcloud/${1}"
}

function kube-export(){
    local account_name=$1
    if [ -z "${account_name}" ]; then "Usage: ${FUNCNAME[0]} [account name]"; return 1; fi

    if [ "${account_name}" == "ls" ]; then
        echo -e "${GREEN}Listing k8s configs${NOCOLOR}"
        command ls --color --format=single-column "${HOME}"/.kube/*.config
        return 0
    fi

    export KUBECONFIG="${HOME}/.kube/${account_name}.config"
}

function ssh-ssm() {
    local private_dns=$1
    if [ -z "${private_dns}" ]; then echo "Usage ${FUNCNAME[0]} <ec2 private dns>"; return 1; fi

    instance_id=$(aws ec2 describe-instances --filters "Name=private-dns-name, Values=${private_dns}" --query "Reservations[*].Instances[*].InstanceId" --output text)

    if [ -z "${instance_id}" ]; then
        echo "Unable to find instance ID"
        return 1
    fi

    aws ssm start-session --target "${instance_id}"
}

function gen-ssh-key() {
    local keyname=$1
    local filename="id_ed25519-${keyname}"
    if [ -z "${keyname}" ]; then echo "Usage: ${FUNCNAME[0]} <keyname>"; return 1; fi

    if [ -f "${HOME}/.ssh/${filename}" ]; then
        echo "[${FUNCNAME[0]}]: Key already exists"
        return 1
    fi
    ssh-keygen -o -a 100 -t ed25519 -f "${HOME}/.ssh/${filename}" -C "${keyname}"
}

function gimme-creds() {
    local profile=$1
    if [ -z "${profile}" ]; then echo "Usage: ${FUNCNAME[0]} <profile name>"; return 1; fi

    if ! command -v gimme-aws-creds &> /dev/null; then
        echo "${RED}gimme-aws-creds not installed${NOCOLOR}"
        return 1
    fi

    if [ "${profile}" == "ls" ]; then
        echo -e "${GREEN}Listing okta profiles${NOCOLOR}"
        < .okta_aws_login_config grep "\[" | sed -e "s#\[##g" | sed -e "s#\]##g" | grep -v DEFAULT
        return 0
    fi
    eval "$(gimme-aws-creds -p "${profile}" -o export)"
}
