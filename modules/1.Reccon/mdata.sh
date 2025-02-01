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

function usage() {
    echo -e "\n${green}[+] mdata module usage :\n\t${yellow}ae mdata [-u listist]${end}"
    exit 1
}

# Usamos getopts en un bucle while para analizar las opciones de línea de comandos
while getopts "u:" option; do
    case "${option}" in
    u) list=${OPTARG} ;;
    *) usage >&2 ;;
    esac
done

if [[ ! -d ./files/ ]]; then
    mkdir ./files 2>/dev/null
fi

if [[ ! -f $list ]]; then
    usage
fi

function extractMetadata() {

    echo -e "\n[+] ${green}Extracting metadata${end}\n"
    mkdir ./metadata/ 2>/dev/null
    filter='0 image filenameiles read| 1 directories scanned|Archived File Name | Byte Order Mark |CPU Architecture |CPU Byte Order |CPU Type |Changed |Column Count |Compressed |Compressed Size |Compression |Create Date |Created |Delimiter |Directory |Duration |ExifTool Version Number  |File Access Date/Time |File Inode Change Date/Time |File Modification Date/Time |File Name |File Permissions |File Size |File Type |File Type Extension |File Version |Flags |Flash Version |Frame Count |Frame Rate |Has XFA |Image Height |Image Size |Image Width |Line Count |Linearized |MIME Encoding |MIME Type |Megapixels|Modify Date|Newlines|Object File Type|Operating System|PDF Version|Packing Method|Page Count|Quoting|Row Count|Uncompressed Size|Warning|Word Count|Zip Bit Flag|Zip CRC|Zip Compressed Size|Zip Compression|Zip File Name|Zip Modify Date|Zip Required Version|Zip Uncompressed Size|Background Color|Bit Depth|Bits Per Pixel|Blue Matrix Column|Blue Tone Reproduction Curve|Blue X|Blue Y|Color Resolution Depth|Color Space Data|Color Type|Connection Space Illuminant|Copyright (en-US)|Filter|Font Family (en-US)|Font Name (en-US)|Font Subfamily (en-US)|Font Subfamily ID (en-US)|GIF Version|Green Matrix Column|Green Tone Reproduction Curve|Green X|Green Y|Has Color Map|Interlace|Media Black Point|Media White Point|Name Table Version (en-US)|Pixel Units|Pixels Per Unit X|Pixels Per Unit Y|Post Script Font Name (en-US)|Primary Platform|Profile CMM Type|Profile Class|Profile Date Time|Red Matrix Column|Red Tone Reproduction Curve|Red X|Red Y|Rendering Intent|Sample Text|Sample Text (en-US)|Vendor URL (en-US)|White Point X|White Point Y|Chromatic Adaptation|Color Planes|Copyright (en-US)|Designer (en-US)|Designer URL (en-US)|Device Attributes|Device Manufacturer|Device Model|Error|Font Family|Font Family (en-US)|Font Name|Font Name (en-US)|Font Subfamily|Font Subfamily (en-US)|Font Subfamily ID|Font Subfamily ID (en-US)|Image Count|Image Length|Make And Model|Manufacturer (en-US)|Name Table Version|Name Table Version (en-US)|Native Display Info|Num Colors|Post Script Font Name (en-US)|PostScript Font Name|Profile Connection Space|Profile Copyright|Profile Creator|Profile Description|Profile File Signature|Profile ID|Profile Version|Vendor URL (en-US)|Video Card Gamma|Xmlns'

    ls ./files/ | xargs -I {} exiftool ./files/{} | sort -u | grep -vE "$filter" >./metadata/metadata.result

    clear
    echo -e "\n[+] ${green}Metadata extracted in ./metadata/ & files saved in ./files/${end}\n"
}

function download() {

    echo -e "\n[+] ${green}Downloading files...${end}\n"
    mx_processes=50
    processes_counter=0

    for url in $(cat $list | grep -E 'pdf|docx|jpg|png|gif|mp3|mp4|csv|ico|svg|woff|js|eot|css|ttf'); do

        if [[ $processes_counter -ge $mx_processes ]]; then
            processes_counter=0
            wait
        fi

        processes_counter=$(($processes_counter + 1))
        filename=$(echo -e "$url" | rev | cut -d '/' -f1 | rev)

        if [[ -e ./$filename ]]; then
            (wget -O "./files/$filename_$filename" $url 2>/dev/null) &
        else
            (wget -O "./files/$filename" $url 2>/dev/null) &
        fi

    done
    wait
}

download
extractMetadata
