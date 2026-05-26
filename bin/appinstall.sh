#!/usr/bin/env bash
APP_NAME=''
DOMAIN=''
EPACE='        '

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m"
    echow '-A, --app [app_name] -D, --domain [DOMAIN_NAME]'
    echo "${EPACE}${EPACE}Example: appinstall.sh -A wordpress -D example.com"
    echo "${EPACE}${EPACE}Will install WordPress CMS under the example.com domain"
    echow '-H, --help'
    echo "${EPACE}${EPACE}Display help and exit."
    exit 0
}

check_input(){
    if [ -z "${1}" ]; then
        help_message
        exit 1
    fi
}

validate_domain(){
    if ! echo "${1}" | grep -Eq '^(localhost|([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,})$'; then
        echo "[X] Invalid domain name: '${1}'. Abort!"
        exit 1
    fi
}

validate_app_name(){
    case "${1}" in
        wordpress|wp) ;;
        *)
            echo "[X] Invalid app name: '${1}'. Abort!"
            exit 1
            ;;
    esac
}

app_download(){
    validate_app_name "${1}"
    validate_domain "${2}"
    docker compose exec litespeed su -c "appinstallctl.sh --app ${1} --domain ${2}"
    bash bin/webadmin.sh -r
    exit 0
}

main(){
    app_download ${APP_NAME} ${DOMAIN}
}

check_input ${1}
while [ ! -z "${1}" ]; do
    case ${1} in
        -[hH] | -help | --help)
            help_message
            ;;
        -[aA] | -app | --app) shift
            check_input "${1}"
            APP_NAME="${1}"
            ;;
        -[dD] | -domain | --domain) shift
            check_input "${1}"
            DOMAIN="${1}"
            ;;          
        *) 
            help_message
            ;;              
    esac
    shift
done

main