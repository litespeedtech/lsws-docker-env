#!/bin/bash
MA_COMPOSER='/usr/local/bin/composer'
EPACE='        '

echoY() {
    echo -e "\033[38;5;148m${1}\033[39m"
}
echoG() {
    echo -e "\033[38;5;71m${1}\033[39m"
}
echoR()
{
    echo -e "\033[38;5;203m${1}\033[39m"
}
echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
	echo -e "\033[1mOPTIONS\033[0m"
    echow '-A, -app [wordpress|magento] -D, --domain [DOMAIN_NAME]'
    echo "${EPACE}${EPACE}Example: appinstallctl.sh --app wordpress --domain example.com"
    echow '-H, --help'
    echo "${EPACE}${EPACE}Display help and exit."
    exit 0
}

install_ed(){
    if [ ! -f /bin/ed ]; then
        echo "Install ed package.."
        apt-get install ed -y > /dev/null 2>&1
    fi    
}

install_unzip(){
    if [ ! -f /usr/bin/unzip ]; then 
        echo "Install unzip package.."
        apt-get install unzip -y > /dev/null 2>&1
    fi		
}

install_composer(){
    if [ -e ${MA_COMPOSER} ]; then
        echoG 'Composer already installed'
    else
        echoG 'Going to install composer package'
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar ${MA_COMPOSER}
        composer --version
        if [ ${?} != 0 ]; then
            echoR 'Issue with composer, Please check!'
        fi        
    fi    
}

install_git(){
	if [ ! -e /usr/bin/git ]; then
		echoG 'Install git'
		apt-get update >/dev/null 2>&1
		apt-get install git -y >/dev/null 2>&1
    fi
}

case ${1} in 
    -[pP] | -package | --package) shift
        if [ -z "${1}" ]; then
            help_message
        fi
        case ${1} in 
            ed)
                install_ed
            ;;    
            unzip)
                install_unzip
            ;;
            composer)
                install_composer
            ;;
            git)
                install_git
            ;;    
        esac    
    ;;
    -[hH] | -help | --help)
        help_message
    ;;
    *)
        help_message
    ;;
esac