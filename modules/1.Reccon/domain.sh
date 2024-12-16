#!/bin/bash

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

domain=""

function usage(){
    echo -e "${green}[!] Subdomains module usage: \n\t ${yellow} bbt dm [-d domain]" 
    exit 1
}

function exist_domain_folder(){

    if [[ ! -d ./DOMAINS/ ]]; then

        mkdir ./DOMAINS/
    fi

}


# Usamos getopts en un bucle while para analizar las opciones de línea de comandos
while getopts "d:" option; do
    case "${option}" in
        d) domain=${OPTARG} ;;
        *) usage >&2 ;;
    esac
done


if [[ "$domain" == "" ]] || [[ "$output" == " " ]]; then
    usage
fi

exist_domain_folder

echo $domain | grep -E 'http|https' &>/dev/null
if [[ "$?" -eq "0" ]]; then
    echo "[!] That's a url not a valid DOMAIN!"
    exit
fi


/usr/bin/subfinder -d $domain -nc -silent -o "subf.tmp"
$HOME/go/bin/assetfinder --subs-only $domain > "asset.tmp" 

cat ./subf.tmp ./asset.tmp > "./DOMAINS/${domain}_subdomains"
cat "./DOMAINS/${domain}_subdomains" | sort -u | uniq |  sed 's/*.//g' | sponge "./DOMAINS/${domain}_subdomains"

rm *.tmp
