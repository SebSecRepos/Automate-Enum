#!/bin/bash

option=$1
dependencies=0
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"



function usage(){


echo -e "${green}"
cat << 'EOF'
 =============================================================================================
|                  _                        _              ______                             |
|       /\        | |                      | |            |  ____|                            |
|      /  \  _   _| |_ ___  _ __ ___   __ _| |_ ___ ______| |__   _ __  _   _ _ __ ___        |
|     / /\ \| | | | __/ _ \| '_ ` _ \ / _` | __/ _ \______|  __| | '_ \| | | | '_ ` _ \       |
|    / ____ \ |_| | || (_) | | | | | | (_| | ||  __/      | |____| | | | |_| | | | | | |      |
|   /_/    \_\__,_|\__\___/|_| |_| |_|\__,_|\__\___|      |______|_| |_|\__,_|_| |_| |_|      |
|                                                                                             |
 =============================================================================================

 --> Automate DNS & URL enumeration

EOF

echo -e "${end}"
sleep 1.5
clear

    echo -e "\n${green}[+] Uso:${end}\n"
    echo -e "\t ${green}ae ${purple}<module> ${yellow}<parameters>${end} \n"; >&2
    echo -e "\t ------------------------------------------------------------------------------------ \n"; >&2
    echo -e "\t ${green}ae ${purple}dm ${end}[-d domain]\t\t\t${yellow}Subdomain discovery ${end}\n"; >&2
    echo -e "\t ${green}ae ${purple}dnsa ${end}[-d domain/domain_list]\t${yellow}DNS Lookup & automate AXFR Attacks  ${end}\n"; >&2
    echo -e "\t ${green}ae ${purple}axfr ${end}\t\t\t\t${yellow}Filter for ${green}success AXFR Attack results${yellow} saved in ${purple} ./DNS_ENUM/ ${end}\n"; >&2
    echo -e "\t ${green}ae ${purple}ur ${end}[-u url/url_list]\t\t${yellow}Url discovery ${red}(recommended just an url for each scan & not repeat domains)${end}\n"; >&2
    echo -e "\t ${green}ae ${purple}ht ${end}[-d domain_list]\t\t\t${yellow}Domain url analysis using httpx ${end}\n"; >&2
    echo -e "\t ${green}ae ${purple}cr ${end}[-l url_list]\t\t\t${yellow}Filter for ${red}critical files & routes${yellow} in a url list. ${green}Useful with ${purple}ur${green} module results${end}\n"; >&2
    echo -e "\t ------------------------------------------------------------------------------------ \n"; >&2
    echo -e "${green}[+] Results: \n"; >&2
    echo -e "\t${purple}dm ${yellow} ./DOMAINS/ ${end}\n"; >&2
    echo -e "\t${purple}dnsa ${yellow} ./DNS_ENUM/${end}\n"; >&2
    echo -e "\t${purple}ur ${yellow} ./URL_ENUM/ ${end}\n"; >&2
    echo -e "\t${purple}ht ${yellow} ./URL_HTTPX/${end}\n"; >&2
    echo -e "\t${purple}cr ${yellow} ./URL_FILTERED/${end}\n"; >&2


    
}


if [[ ! -f /usr/bin/batcat ]]; then
        echo -e "\n${yellow}[!] ${red}\"batcat\" Is required${green} \n\n\t apt install bat\n${end}"
        dependencies=1
fi
if [[ ! -f /usr/bin/nslookup ]]; then
        echo -e "\n${yellow}[!] ${red}\"dnsutils\" Is required${green} \n\n\t apt install dnsutils\n${end}"
        dependencies=1
fi
if [[ ! -f /usr/bin/whois ]]; then
        echo -e "\n${yellow}[!] ${red}\"whois\" Is required${green} \n\n\t apt install whois\n${end}"
        dependencies=1
fi
if [[ ! -f /usr/bin/subfinder ]]; then
        echo -e "\n${yellow}[!] ${red}\"subfinder\" Is required${green} \n\n\t go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest\n${end}"
        dependencies=1
fi
if [[ ! -f /usr/bin/assetfinder ]]; then
        echo -e "\n${yellow}[!] ${red}\"assetfinder\" Is required${green} \n\n\t go install -v github.com/tomnomnom/assetfinder@latest\n${end}"
        dependencies=1
fi
if [[ ! -f $HOME/go/bin/waybackurls ]]; then
        echo -e "\n${yellow}[!] ${red}\"waybackurls\" Is required${green} \n\n\t go install github.com/tomnomnom/waybackurls@latest\n${end}"
        dependencies=1
fi
if [[ ! -f $HOME/go/bin/urlfinder ]]; then
        echo -e "\n${yellow}[!] ${red}\"urlfinder\" Is required${green} \n\n\t go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest\n${end}"
        dependencies=1
fi
if [[ ! -f $HOME/go/bin/httpx ]]; then
        echo -e "\n${yellow}[!] ${red}\"httpx\" Is required${green} \n\n\t go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest\n${end}"
        dependencies=1
fi
if [[ $dependencies -eq 1 ]]; then
    exit 1
fi


function dm(){
    shift
    ./modules/1.Reccon/domain.sh $@
}
function ht(){
    shift
    ./modules/1.Reccon/httpx.sh $@
}
function sc(){
    shift
    ./modules/1.Reccon/scraping.sh $@
}
function ur(){
    shift
    ./modules/1.Reccon/ur.sh $@
}
function dnsa(){
    shift
    ./modules/1.Reccon/dnsa.sh $@
}
function axfr(){
    ./modules/1.Reccon/axfr_filter.sh 
}

function critical(){
    shift
    ./modules/1.Reccon/critical.sh $@
}



case "${option}" in
    dm)  dm "$@";;
    ht)  ht "$@";;
    sc)  sc "$@";;
    ur)  ur "$@";;
    dnsa)  dnsa "$@";;
    axfr)  axfr;;
    cr)  critical "$@";;

    *)
        usage; 
        exit 1 ;;
    \?) usage; >&2
        exit 1 ;;
esac
