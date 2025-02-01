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

    echo -e "${green}[!] DNS module usage: \n\t ${yellow} ae dnsa [-d domain/domain_list] " 
    echo -e "${green}[!] Optional -o for output: \n\t ${yellow} ae dnsa [-d domain/domain_list] -o <directory>  " 
    echo -e "${green}[+] Results will be stored as: \n\t ${blue} domain_lookup & domain_axfr " 
    exit 1
}

# Usamos getopts en un bucle while para analizar las opciones de línea de comandos
while getopts "d:" option; do
    case "${option}" in
        d) domain=${OPTARG} ;;
        *) usage >&2 ;;
    esac
done


function exist_domain_folder(){

    if [[ ! -d ./DNS_ENUM ]]; then

        mkdir ./DNS_ENUM/
    fi

}


if [[ "$domain" == "" ]] || [[ "$domain" == " " ]] || [[ "$domain" == "\n" ]] || [[ "$domain" == ".." ]] || [[ "$domain" == "." ]]; then

    echo -e "${green}[!] ${domain} ${red}Domain list not found\n" 
    exit 1

fi

axfr_attack () {
    echo "$1" | grep nameserver &>/dev/null
    if [[ $? -eq 0  ]];then
        echo "$1" | grep nameserver | cut -d '=' -f2  | while read -r line; do 
            clear
            echo -e "\n[+] ---------- AXFR Atack results for $2 @$line -----------\n" > "./DNS_ENUM/${2}/${line}_axfr"
            /usr/bin/timeout 20 /usr/bin/dig axfr $2 @$line >> "./DNS_ENUM/${2}/${line}_axfr" 2>/dev/null
        done
    fi
}


dnsall () {

    mkdir ./DNS_ENUM/${1}/ &>/dev/null
    vEfilter1='Server:|Address:|Authoritative answers can be found from:|Non-authoritative answer:'
    vEfilter2='Server:|Address:|Authoritative answers can be found from:|Non-authoritative answer:|nameserver ='
    (
        echo -e "\n[+] ---------- NS Authoriative servers -----------"
        authoritative_result="$(/usr/bin/timeout 20 /usr/bin/nslookup -type=ns $1 | grep -vE "$vEfilter1")"
        echo -e "$authoritative_result"
        (axfr_attack "$authoritative_result" "$1") &
        wait
        echo -e "\n[+] ---------- A records -----------"
        Arecords=$(/usr/bin/timeout 20 /usr/bin/nslookup -type=A $1 | grep -vE '#|Server:' | grep 'Address:' | sort -u | uniq)
        Ips=$(echo -e "${Arecords}" | awk '{print $2}')
        echo -e "\n$Arecords\n"
        echo -e "\n[+] ---------- AAAA records -----------"
        /usr/bin/timeout 20 /usr/bin/nslookup -type=AAAA $1 | grep -vE "$vEfilter1"
        echo -e "\n[+] ---------- MX records -----------"
        /usr/bin/timeout 20 /usr/bin/nslookup -type=mx $1 | grep -vE "$vEfilter2"
        echo -e "\n[+] ---------- TXT records -----------"
        /usr/bin/timeout 20 /usr/bin/nslookup -type=txt $1 | grep -vE "$vEfilter2"
        echo -e "\n[+] ---------- SOA records -----------"
        /usr/bin/timeout 20 /usr/bin/nslookup -type=soa $1 | grep -vE "$vEfilter2"
        echo -e "\n[+] ---------- Whois lookup for (${1}) -----------\n"
        /usr/bin/timeout 20 /usr/bin/whois $1


    ) > "./DNS_ENUM/${1}/DNS_lookup"

    clear
    echo -e "\n ${green}[+] ${yellow}---------- Performing ${blue}DNS Lookup${end} & ${red}AXFR Attack ${yellow}-----------${end}\n"
    echo -e "\n${green}[+]${yellow} ---------- Results saved in -----------\n\n\t ${green}./DNS_ENUM/${1}/ ${end}"

    

}



if [[ "$domain" == "" ]] || [[ "$domain" == " " ]] || [[ "$domain" == "\n" ]]; then

    usage
    exit 1
fi


if [[ ! -f $domain ]]; then   
    echo -e "\n ${green}[+] ${yellow}---------- Performing ${blue}DNS Lookup${end} & ${red}AXFR Attack ${yellow}-----------${end}\n"
    exist_domain_folder

    dnsall $domain

elif [[ -f $domain ]]; then

    echo -e "\n ${green}[+] ${yellow}---------- Performing ${blue}DNS Lookup${end} & ${red}AXFR Attack ${yellow}-----------${end}\n"
    exist_domain_folder

    limit_process=120
    current=0

    for dm in $(cat $domain);do

       if [[ $current -ge $limit_process ]];then
            wait
            current=0
       fi    
        current=$(($current+1))

       (dnsall "$dm") &

    done

else

    usage
    exit 1

fi
