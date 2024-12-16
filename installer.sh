#!/bin/bash

dependencies=0
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"



if [[ "$(whoami)" != root ]];then

    echo -e "\n${red}[!] Are you root ? ${end}\n"
    exit 1
fi


echo -e "${green} \"Automate enum\" require following dependencies:${end}"
echo -e "${purple}\n\t -> batcat${end}"
echo -e "${purple}\n\t -> dnsutils${end}"
echo -e "${purple}\n\t -> whois${end}"
echo -e "${purple}\n\t -> subfinder${end}"
echo -e "${purple}\n\t -> assetfinder${end}"
echo -e "${purple}\n\t -> waybackurls${end}"
echo -e "${purple}\n\t -> urlfinder${end}"
echo -e "${purple}\n\t -> httpx${end}"
echo -e "${purple}\n\t -> moreutils${end}"
echo -e "\n${green} Do you want automate install the missing dependencies? ${yellow}(yes/no)${end}"

read $option

if [[ "$option" -eq "yes" ]] || [[ "$option" -eq "YES" ]]; then

        echo -e "${yellow}\n [+] installing dependencies ${end}"
        /usr/bin/go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
        /usr/bin/go install -v github.com/tomnomnom/assetfinder@latest
        /usr/bin/go install github.com/tomnomnom/waybackurls@latest
        /usr/bin/go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest
        /usr/bin/go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
        /usr/bin/apt -y install bat dnsutils whois moreutils

fi




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
if [[ ! -f /usr/bin/sponge ]]; then
        echo -e "\n${yellow}[!] ${red}\"moreutils\" Is required${green} \n\n\t apt install moreutils\n${end}"
        dependencies=1
fi
if [[ $dependencies -eq 1 ]]; then
    exit 1
fi

if [[ -d /opt/automate-enum/ ]];then

        rm -rf /opt/automate-enum/
fi

rm /usr/bin/ae &>/dev/null

cp -r $(pwd) /opt/automate-enum

if [[ $? -ne 0 ]]; then echo -e "\n ${red}[!] Error in copy to /opt/automate-enum${end}\n"; exit 1 ; fi

sed -i 's/.\/modules\/1.Reccon\//\/opt\/automate-enum\/modules\/1.Reccon\//g' /opt/automate-enum/ae.sh 

if [[ $? -ne 0 ]]; then echo -e "\n ${red}[!] Error updating module reference files${end}\n"; exit 1 ; fi

sed -i 's/.\/wordlist\/payloads.txt/\/opt\/automate-enum\/wordlist\/payloads.txt /g' /opt/automate-enum/modules/1.Reccon/critical.sh

if [[ $? -ne 0 ]]; then echo -e "\n ${red}[!] Error updating module reference files${end}\n"; exit 1 ; fi

ln -s /opt/automate-enum/ae.sh /usr/bin/ae

if [[ $? -ne 0 ]]; then echo -e "\n ${red}[!] Error making symbolic link${end}\n"; exit 1 ; fi

echo -e "\n${green}[+] Installed successfully ! ${end}\n"