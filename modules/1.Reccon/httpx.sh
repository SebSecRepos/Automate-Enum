#!/bin/bash

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
domains_list=""
output=""

function usage(){
    echo -e "\n${green}[+] httpx module usage :\n\t${yellow}ae ht [-d domain_list]${end}" 
    exit 1
}

function exist_url_folder(){

    if [[ ! -d ./URL_HTTPX/ ]]; then

        mkdir ./URL_HTTPX/
    fi

}


while getopts "d:o:" option; do
    case "${option}" in
        d) domains_list=${OPTARG} ;;
        *) usage >&2 ;;
    esac
done



if [[ "$domains_list" == "" ]]; then
    usage
fi

if [[ ! -f $domains_list ]]; then
    echo -e "\n[!] Domain list not found\n"
    exit
fi

exist_url_folder

cat $domains_list | $HOME/go/bin/httpx -silent -location -t 120 -fep --random-agent -sc -title -td -ip -server -fr -fc 500,404,400 -o "./URL_HTTPX/httpx_result"

