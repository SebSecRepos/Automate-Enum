#!/bin/bash

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

list=""


if [[ ! -d  ./DNS_ENUM/ ]];then

    echo -e "\n${red}[!]${yellow} You should use ${green}dnsa${yellow} module before filter AXFR attack results \n\t ${green}./DNS_ENUM/ folder not found${end}"
    exit 1

fi


for file in $(find ./DNS_ENUM/ -type f -name '*axfr');do

    cat $file | grep -E 'Transfer failed|no servers could be reached' &>/dev/null

    if [[ $? -ne 0 ]] && [[ $(wc -l $file | awk '{print $1}' ) -ge 5 ]]; then
        cat $file
    fi
done