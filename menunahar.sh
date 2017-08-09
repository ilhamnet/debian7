#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

function create_user() {
	useradd -M $uname
	echo "$uname:$pass" | chpasswd
	usermod -e $expdate $uname

	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
	myip2="s/xxxxxxxxx/$myip/g";	
	wget -qO /tmp/client.ovpn "http://sulawesinet.pro/stup/1194-client.conf"
	sed -i 's/remote xxxxxxxxx 1194/remote xxxxxxxxx 443/g' /tmp/client.ovpn
	sed -i $myip2 /tmp/client.ovpn
	echo ""
	echo "========================="
	echo "Host IP : $myip"
	echo "Port    : 443/22/80"
	echo "Squid   : 8080/3128"
	echo "========================="
	echo "Scrip by IlhamMuhammad , gunakan akun dengan bijak"
	echo "========================="
}

function renew_user() {
	echo "New expiration date for $uname: $expdate...";
	usermod -e $expdate $uname
}

function delete_user(){
	userdel $uname
}

function expired_users(){
	cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
	totalaccounts=`cat /tmp/expirelist.txt | wc -l`
	for((i=1; i<=$totalaccounts; i++ )); do
		tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
		username=`echo $tuserval | cut -f1 -d:`
		userexp=`echo $tuserval | cut -f2 -d:`
		userexpireinseconds=$(( $userexp * 86400 ))
		todaystime=`date +%s`
		if [ $userexpireinseconds -lt $todaystime ] ; then
			echo $username
		fi
	done
	rm /tmp/expirelist.txt
}

function not_expired_users(){
    cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
    totalaccounts=`cat /tmp/expirelist.txt | wc -l`
    for((i=1; i<=$totalaccounts; i++ )); do
        tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
        username=`echo $tuserval | cut -f1 -d:`
        userexp=`echo $tuserval | cut -f2 -d:`
        userexpireinseconds=$(( $userexp * 86400 ))
        todaystime=`date +%s`
        if [ $userexpireinseconds -gt $todaystime ] ; then
            echo $username
        fi
    done
	rm /tmp/expirelist.txt
}

function used_data(){
	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`
	myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`
	ifconfig $myint | grep "RX bytes" | sed -e 's/ *RX [a-z:0-9]*/Received: /g' | sed -e 's/TX [a-z:0-9]*/\nTransfered: /g'
}

	clear

	echo "--------------- Selamat datang di Server - IP: $myip ---------------"
	echo "Scrip By      : IlhamMuhammad"
	echo "Facebook       : https://www.facebook.com/Ilham02muhammad"
	echo "WA       : 081360800433"
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

	echo -e "\e[032;1mCPU model:\e[0m $cname"
	echo -e "\e[032;1mNumber of cores:\e[0m $cores"
	echo -e "\e[032;1mCPU frequency:\e[0m $freq MHz"
	echo -e "\e[032;1mTotal amount of ram:\e[0m $tram MB"
	echo -e "\e[032;1mTotal amount of swap:\e[0m $swap MB"
	echo -e "\e[032;1mSystem uptime:\e[0m $up"
	echo "------------------------------------------------------------------------------"
	echo "Apa yang ingin Anda lakukan?"
	echo -e "\e[031;1m 1\e[0m) Buat Akun SSH/OpenVPN (\e[34;1muser-add\e[0m)"
	echo -e "\e[031;1m 2\e[0m) Tambah Masa Aktif Akun SSH/OpenVP (\e[34;1muser-renew\e[0m)"
	echo -e "\e[031;1m 3\e[0m) Hapus Akun SSH/OpenVPN(\e[34;1muser-del\e[0m)"
	echo -e "\e[031;1m 4\e[0m) Daftar User Aktif (\e[34;1muser-active-list\e[0m)"
	echo -e "\e[031;1m 5\e[0m) User yang tidak experied (\e[34;1muser-active-list\e[0m)"
	echo -e "\e[031;1m 6\e[0m) Daftar User Experied (\e[34;1muser-expire-list\e[0m)"
	echo -e "\e[031;1m 7\e[0m) Restart Server (\e[34;1mreboot\e[0m)"
	echo -e "\e[031;1m 8\e[0m) Ubah pasword user (\e[34;1mpassword\e[0m)"
	echo -e "\e[031;1m 9\e[0m) Used data by User (\e[34;1mused-data\e[0m)"
	echo -e "\e[031;1m10\e[0m) Ram Status (\e[34;1mRam-status\e[0m)"
	echo -e "\e[031;1m11\e[0m) Monitor User Login (\e[34;1mMonitor-login\e[0m)"
	echo -e "\e[031;1m12\e[0m) Change openvpn port (\e[34;1mchange-openvpn-port\e[0m)"
	echo -e "\e[031;1m13\e[0m) Change Dropbear port (\e[34;1mchange-dropbear\e[0m)"
	echo -e "\e[031;1m14\e[0m) Change Squid Port (\e[34;1mcange-squid\e[0m)"
	echo -e "\e[031;1m15\e[0m) Restart dropbear (\e[34;1merestart-dropbear\e[0m)"
	echo -e "\e[031;1m16\e[0m) Restart Openvpn saja (\e[34;1mrestart-openvpn\e[0m)"
	echo -e "\e[031;1m17\e[0m) Ubah pasword user experied  (\e[34;1mchange-pas-experied\e[0m)"
	echo -e "\e[031;1m18\e[0m) Speedtest VPS server (\e[34;1mCek-speedttes-vps\e[0m)"
	echo -e "\e[031;1m19\e[0m) tendang (\e[34;1mtendang-user-nakal\e[0m)"
	echo -e "\e[031;1m20\e[0m) Generate Akun trial (\e[34;1mTrial\e[0m)"
	echo ""
	echo -e "\e[031;1m x\e[0m) Exit Metu alias keluar"
	echo ""
	read -p "Masukkan pilihan anda, kemudian tekan tombol ENTER: " option1
	case $option1 in
        1)
            echo "Buat akun ssh vpn"
            buatakun
            echo "buat akun done"
            ;;
        2)
            read -p "Enter username to renew: " uname
            read -p "Enter expiry date (YYYY-MM-DD): " expdate
            renew_user
            ;;
        3)
            read -p "Enter username to be removed: " uname
            delete_user
            ;;		
		4)
            user-list
            ;;
		5)
			not_expired_users
			;;
		6)
			expired_users
			;;		
		7)
			reboot
			;;	
		8)
			passwd
			;;
		9)
			used_data
			;;
		10)
		    free -h | grep -v + > /tmp/ramcache
            cat /tmp/ramcache | grep -v "Swap"
              ;;
       11)
               monssh
	          ;;
		12)	
            echo "What OpenVPN port would you like  to change to?"
            read -p "Port: " -e -i 1194 PORT
            sed -i "s/port [0-9]*/port $PORT/" /etc/openvpn/1194.conf
            service openvpn restart
            echo "OpenVPN Updated : Port $PORT"
			;;
		13)	
            echo "What Dropbear port would you like to change to?"
            read -p "Port: " -e -i 443 PORT
            sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$PORT/" /etc/default/dropbear
            service dropbear restart
            echo "Dropbear Updated : Port $PORT"
			;;
        14)	
            echo "What Squid3 port would you like to change to?"
            read -p "Port: " -e -i 8080 PORT
            sed -i "s/http_port [0-9]*/http_port $PORT/" /etc/squid3/squid.conf
            service squid3 restart
            echo "echo "Squid3 Updated : Port $PORT""
			;;			
        15)
            echo "Servie dropbear .................tunggu yah xixiixxii"
            service dropbear restart
            echo "Service done ..Script by IlhamMuhammad"
            ;;
        16)	
            echo "Service Openvpn restart .................tunggu yah xixiixxii"
            service openvpn restart
            echo "Restart openvpn selesai @Script By IlhamMuhammad"
			;;	
        17)	
            echo "Reset pas user experied"
            ./user-experied
            echo "Nex script...."
			;;	
        18)	
            echo "SPeed Tes server"
            ./speedtest.py --share
            echo "Hasil Speed tes diatas script by IlhamMuhammad"
			;;	
        19)	
            echo "Tendang user nakal"
            tendang
            echo "tendang user nakal done"
			;;	
        20)	
            echo "generate akun trial"
            trial
            echo "Generate done"
			;;	
        21)
            ;;		
        x)
            ;;
        *) echo invalid option;;
    esac
