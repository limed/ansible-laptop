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
    ldapsearch -x -D "mail=elim_la@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password mozilla_la.asc)" -h ldap.db.scl3.mozilla.com -b dc=mozilla $1 $2
}

function ldap_query() {
    ldapsearch -x -D "mail=elim@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password_gpg)" -h ldap.db.scl3.mozilla.com -b dc=mozilla $1 $2
}

function load_ldif() {
    local ldif_file=$1

    local bind_user="mail=elim_la@mozilla.com,o=com,dc=mozilla"
    local ldap_master="ldapmaster1.db.scl3.mozilla.com"

    read -p "You are about to load ${ldif_file} to ${ldap_master}, are you sure? [y/n]: " answer
    if [[ $answer == 'y' ]]; then
        echo "Loading ldif file: ${ldif_file}"
        ldapmodify -x -D "mail=elim@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password_gpg)" -h ${ldap_master} -f $1
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
    read -p "You are about to load ${ldif_file} to ldapmaster1.dev.db.phx1.mozilla.com, are you sure? [y/n]: " answer
    if [[ $answer == 'y' ]]; then
        echo "Loading ldif file: ${ldif_file}"
        ldapmodify -x -D "mail=elim@mozilla.com,o=com,dc=mozilla" -w "$(get_ldap_password_gpg)" -h ldapmaster1.dev.db.scl3.mozilla.com -f $1
        return 0
    elif [[ $answer == 'n' ]]; then
        echo "Not doing anything, exiting"
        return 1
    else
        echo "Invalid input"
        return 1
    fi
}
