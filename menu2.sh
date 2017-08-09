#!/bin/bash
#
#
# ========================

# Modifikasi Terminal

blue='\e[1;34m'
green='\e[0;23m'
purple='\e[1;35m'
cyan='\e[1;36m'
red='\e[1;31m'
echo -e $green'================================================================================'
echo -e $red[+] $cyan"$HOSTNAME uptime is "$red[+]$cyan;uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
uname -r
uname -v -s
echo -e $red[+]$cyan Today :$red[+]$cyan 
date
echo -e $green'================================================================================'
#Figlet nama
echo -e $green 
figlet -f slant "# Ilham Muhammad #"
echo -e $cyan     '_________________<? WELCOME USER VPS ?>_________________'
echo "  ----------------------"
;
echo "Perintah / Command VPS admin Haris 
@Debian7 ILHAMNET

#Menu

echo -e "* menu      : menampilkan daftar perintah"
echo -e "* usernew   : membuat akun SSH & OpenVPN"
echo -e "* trial     : membuat akun trial"
echo -e "* hapus     : menghapus akun SSH & OpenVPN"
echo -e "* cek       : cek user login"
echo -e "* member    : daftar member SSH & OpenVPN"
echo -e "* resvis    : restart service dropbear, webmin"
echo -e "              squid3, OpenVPN dan SSH"
echo -e "* reboot    : reboot VPS"
echo -e "* speedtest : speedtest VPS"
echo -e "* info      : menampilkan informasi sistem"
echo -e "* about     : info script auto install"
echo -e "* exit      : keluar dari Putty/Connecbot/"
echo -e "              JuiceSSH"
echo -e ""
