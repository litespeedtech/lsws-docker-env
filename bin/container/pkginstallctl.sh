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
        ed -V > /dev/null 2>&1
        if [ ${?} != 0 ]; then
            echoR 'Issue with ed, Please check!'
        fi          
    fi    
}

install_unzip(){
    if [ ! -f /usr/bin/unzip ]; then 
        echoG "Install unzip package"
        apt-get install unzip -y > /dev/null 2>&1
        unzip -v > /dev/null 2>&1
        if [ ${?} != 0 ]; then
            echoR 'Issue with unzip, Please check!'
        fi          
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

install_systemd(){
    if [ ! -f /bin/systemd ]; then 
        echoG "Install systemd package"
        apt-get install systemd -y > /dev/null 2>&1
        systemd --version > /dev/null 2>&1
        if [ ${?} != 0 ]; then
            echoR 'Issue with systemd, Please check!'
        fi         
    fi		
}

install_elasticsearch(){
    if [ ! -e /etc/elasticsearch ]; then
        apt-get install -y gnupg2 >/dev/null 2>&1
        curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - >/dev/null 2>&1
        echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list >/dev/null 2>&1
        apt update >/dev/null 2>&1
        apt install elasticsearch -y >/dev/null 2>&1
        echoG 'Start elasticsearch service'
        service elasticsearch start >/dev/null 2>&1
        if [ ${?} != 0 ]; then
            echoR 'Issue with elasticsearch package, Please check!'
            exit 1
        fi
        systemctl enable elasticsearch >/dev/null 2>&1
    else
        echoG 'Elasticsearch already exist, skip!'
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
            systemd)
                install_systemd
            ;;    
            elasticsearch)
                install_elasticsearch
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