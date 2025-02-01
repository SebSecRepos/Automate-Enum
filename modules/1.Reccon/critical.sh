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

function usage(){
    echo -e "\n${green}[+] Critial routes module usage: \n\t${yellow}ae cr [-l url_list]\n${end} -o /path/"; >&2
}

function exist_url_folder(){

    if [[ ! -d ./URL_FILTERED ]]; then

        mkdir ./URL_FILTERED
    fi

}

while getopts "l:" option; do
    case "${option}" in
        l) list=${OPTARG} ;;

        *) 
           exit 1 ;;

        \?) usage; >&2
           exit 1 ;;
    esac
done

if [[ ! -f $list ]]; then

    echo -e "\n${yellow}[!]Url list file: ${red}$list${yellow}not found${end}\n"; >&2
    usage
    exit 1

fi

output=$(echo -e $list  | cut -d '/' -f2)


function compare() {

    exist_url_folder

    echo -e "\n ${green}[+] Filtering critical files & routes${end}\n"

    limit=3
    processes=0
    urls=$(cat $1)
    lines=$(wc -l $1 | awk '{print $1}')

    for comp in $(cat $2); do

        if [[ $processes -ge $limit ]];then
            wait;
            processes=0
        fi
        processes=$((processes+1))
       ( echo -e "$urls" | grep -w "$comp" ) &
        
    done > "./URL_FILTERED/${output}_filtered"

    cat "./URL_FILTERED/${output}_filtered" | sort -u | /usr/bin/sponge "./URL_FILTERED/${output}_filtered"
}



compare $list /opt/automate-enum/wordlist/payloads.txt 

wait

echo -e "\n ${green}[+] Results saved in ./URL_FILTERED/${output}_filtered ${end}\n"


 




 