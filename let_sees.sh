#!/usr/bin/env bash
#SEES 2.0 otomatize aracı
#Author: Ender Akbaş @endr_akbas	
#Author of SEES: Gökhan Alkan @thegalkan

function start_menu {
	clear
	echo "#################"
	echo "# Let_SEES v1.0 #" 
	echo "#################"
	echo
	echo "Ne verim abime:"
	echo "1. Mail şablonu hazırla"
	echo "2. Ekli mail gönder"
	echo "3. Eksiz mail gönder"
	echo "4. Config dosyası yapılandır"
	echo "5. Çıkış"
	echo
}

function check_file_exists {
	if [ -r ./$1 ]
		then echo OK
	else
		echo "$1 dosyası bulunamadı."
		exit
	fi 
}

#CHOICE 1
function make_mail_list {
	echo "Kaydedilecek dosya adi:"
	read MUSER
	touch $MUSER

	echo "Eposta adreslerinin bulunduğu dosya:"
	read -e LIST
	
	#maillerin olduğu dosya kontrol et
	#check_file_exists $LIST

	echo "Gönderen eposta adresi[info@ornek.com]:"
	read -e EMAIL
	echo "Gönderen ismi[Kevin Mitnick]:"
	read -e NAME
	echo "Eposta başlığı[Acil Toplantı]:"
	read -e SUBJECT

	#mail.user hazırlama
	for line in $(cat $LIST)
	do
		echo $EMAIL:$NAME:$SUBJECT:$line >> $MUSER
	done

	#sondaki exit komutu
	echo "exit" >> $MUSER
	echo "mail.user son hali:" 
	awk '{if (NR==1 && NF==0) next};1' $MUSER #dosyanın başındaki boş satırı siler.
}

#CHOICE 2
function send_att_mail {
 	echo "Yapılandırma dosyası[./config/config.cfg]:"
 	read -e CONFIG
 	check_file_exists $CONFIG

 	echo "Mail şablon dosyası[./config/mail.user]"
 	read -e MUSER
 	check_file_exists $MUSER

 	echo "Eposta içeriğinin bulunduğu dosya[./data/html.text]:"
 	read -e HTML
 	check_file_exists $HTML

 	echo "Ek:"
 	read -e ATT ATT2
 	check_file_exists $ATT
 	check_file_exists $ATT2

 	echo "python ./sees.py --attach $ATT $ATT2 --config_file $CONFIG --mail_user $MUSER --html_file $HTML -v"
 	echo "komutu çalıştırılacak devam edilsin mi?[y/n]"
 	read ANSWER
 	if [[ $ANSWER -eq "y" ]];then
 		yes Y | python ./sees.py --attach $ATT $ATT2 --config_file $CONFIG --mail_user $MUSER --html_file $HTML -v
	else
		exit
	fi
}

#CHOICE 3
function send_mail {
 	echo "Yapılandırma dosyası[config/config.cfg]:"
 	read -e CONFIG
 	check_file_exists $CONFIG

 	echo "Mail.user dosyası[config/mail.user]"
 	read -e MUSER
	check_file_exists $MUSER

 	echo "Eposta içeriğinin bulunduğu dosya[data/html.text]:"
 	read -e HTML
 	check_file_exists $HTML

 	echo "python ./sees.py --text --config_file $CONFIG --mail_user $MUSER --html_file $HTML -v"
 	echo "komutu çalıştırılacak devam edilsin mi?[y/n]"
 	read ANSWER

 	if [[ $ANSWER  = y ]];then
 		yes Y | python ./sees.py --text --config_file $CONFIG --mail_user $MUSER --html_file $HTML -v
	else
		exit
	fi
}

#CHOICE 4
function conf_config {
	echo "Config dosyası[config/config.cfg gibi]"
	read -e CONFIGFILE
	touch ./$CONFIGFILE

	echo "Domain adı[ornek.com]"
	read DOMAIN

	echo "SMTP Sunucu IP'si[1.1.1.1]"
	read IP

	echo "Eposta gönderilme sıklığı[sn][5 veya 3,4 gibi]"
	read TIME

	echo "
[mail]
domain = $DOMAIN

[smtp]
server = $IP
time = $TIME

[log]
type = postfix
log_path = /var/log/mail.log" > $CONFIGFILE

echo "config dosyasının son hali:"
cat $CONFIGFILE

}


start_menu
read CHOICE

if [[ $CHOICE -eq 1 ]]; then #mail.user
	make_mail_list
	echo 

elif [[ $CHOICE -eq 2 ]]; then # ekli mail
	send_att_mail

elif [[ $CHOICE -eq 3 ]]; then # eksiz mail
	send_mail		

elif [[ $CHOICE -eq 4 ]]; then # config dosyası
	conf_config

elif [[ $CHOICE -eq 5 ]]; then # çıkış
	exit

else
	echo "Dayak?"
fi


