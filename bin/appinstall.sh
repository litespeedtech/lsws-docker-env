#!/usr/bin/env bash
APP_NAME=''
DOMAIN=''
EPACE='        '
SAMPLE=''

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m"
    echow '-A, --app [app_name] -D, --domain [DOMAIN_NAME]'
    echo "${EPACE}${EPACE}Example: appinstall.sh -A wordpress -D example.com"
    echo "${EPACE}${EPACE}Example: appinstall.sh -A magento -D example.com"
    echo "${EPACE}${EPACE}Example: appinstall.sh -A magento -S -D example.com"
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

set_phpmemory(){
    if [ "${1}" = 'magento' ]; then 
        PHP_INI=$(docker-compose exec litespeed su -c "php -i | grep 'Loaded Configuration File' | cut -d' ' -f5 " | tr -d '\r')
        PHP_MEMORY=$(docker-compose exec litespeed su -c "cat $PHP_INI | grep memory_limit" | tr -d '\r')
        docker-compose exec litespeed su -c "sed -i 's/^memory_limit.*/memory_limit = 755M/g' $PHP_INI"
        echo PHP_INI $PHP_INI
        echo PHP_MEMORY $PHP_MEMORY
    fi    
}

revert_phpmemory(){
    if [ "${1}" = 'magento' ]; then 
        docker-compose exec litespeed /bin/bash -c "sed -i 's/^memory_limit.*/$PHP_MEMORY/g' $PHP_INI"
    fi    
}   


install_packages(){
    if [ "${1}" = 'wordpress' ]; then
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package ed"
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package unzip"  
    elif [ "${1}" = 'magento' ]; then
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package composer"
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package systemd"
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package elasticsearch"
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package unzip"
        docker-compose exec litespeed /bin/bash -c "pkginstallctl.sh --package git"
    fi    
}

app_download(){
    set_phpmemory ${1}
    install_packages ${1}
    docker-compose exec litespeed bash -c "appinstallctl.sh --app ${1} --domain ${2} ${3}"
    revert_phpmemory ${1}
    bash bin/webadmin.sh -r
    exit 0
}

main(){
    app_download "${APP_NAME}" "${DOMAIN}" "${SAMPLE}"
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
		-[sS] | --sample)
            SAMPLE='-S'
            ;;                
        *) 
            help_message
            ;;              
    esac
    shift
done

main