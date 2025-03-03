#!/bin/bash

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

output=""
url=""
list=0

function usage() {
  echo -e "\n${green}[+] Url module usage: \n\t${yellow}ae ur [-u url_list/url] -o file\n${end}"
  >&2
}

function exist_url_folder() {

  if [[ ! -d ./URL_ENUM/ ]]; then

    mkdir ./URL_ENUM/
  fi

}

while getopts "u:" option; do
  case "${option}" in
  u) url=${OPTARG} ;;

  o) output=${OPTARG} ;;

  *)
    exit 1
    ;;

  \?)
    usage
    >&2
    exit 1
    ;;
  esac
done

if [[ "$url" == "" ]] || [[ "$url" == " " ]] || [[ "$url" == "\n" ]]; then

  usage
  exit 1
fi

if [[ ! -f $url ]]; then

  exist_url_folder

  echo -e "\n[+] Executing Waybackurls scan..\n"
  (/usr/bin/timeout 60 $HOME/go/bin/waybackurls $url >./ways.tmp) &
  ways_pid=$!
  echo -e "\n[+] Executing Urlfinder scan..\n"
  ($HOME/go/bin/urlfinder -d $url -silent -o ./finder.tmp) &
  ur_pid=$!

  wait $ways_pid
  wait $ur_pid

  cat *.tmp | sort -u >>"./URL_ENUM/${url}_urls"
 # rm *.tmp
  clear
  echo -e "[+] Output saved in ./URL_ENUM/${url}_urls"

elif [[ -f $url ]]; then

  while read $ur; do

    echo -e "\n[+] Executing Waybackurls scan..\n"
    (/usr/bin/timeout 60 $HOME/go/bin/waybackurls $url >./ways.tmp) &
    ways_pid=$!
    echo -e "\n[+] Executing Urlfinder scan..\n"
    ($HOME/go/bin/urlfinder -d $url -silent -o ./finder.tmp) &
    ur_pid=$!

    wait $ways_pid
    wait $ur_pid

    clear

    filename = $(echo -e "$url" | sed -e 's/https:\/\///g' -e 's/\//_/g')
    cat *.tmp | sort -u >"./URL_ENUM/${filename}"
    rm *.tmp

    clear

    wait
    clear

  done <$url
  echo -e "[+] Output saved in multiple files '*_urls'"

else

  usage
  exit 1

fi
