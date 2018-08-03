#!/bin/sh
OS=`uname`;
DA_CONF=/usr/local/directadmin/conf/directadmin.conf

cd /root || exit
wget -O /root/da.sh http://fpt.ovh/files/da.sh
chmod 777 /root/da.sh
echo "Performing DirectAdmin Installation..."
sleep 5;
./da.sh
sleep 5;

if [ ! -s $DA_CONF ]; then
	echo "Error Installing Directadmin. Please Try Rebuild OS Then Install."
	exit 0;
fi
rm -rf /root/da.sh

	wget -O /root/config.sh http://fpt.ovh/files/config.sh
	wget -O /opt/update.sh http://fpt.ovh/files/update.sh
	chmod 777 /root/config.sh
	chmod 777 /opt/update.sh
	sh /opt/update.sh
	echo "Configuring The Network Card For Directadmin..."
	sleep 5;
	./config.sh
	sleep 5;
	rm -rf /root/config.sh
	service directadmin restart
	clear
	
rm -rf /root/da.sh
rm -rf /root/setup.sh
cd /usr/local/directadmin/scripts || exit
SERVERIP=`cat ./setup.txt | grep ip= | cut -d= -f2`;
USERNAME=`cat ./setup.txt | grep adminname= | cut -d= -f2`;
PASSWORD=`cat ./setup.txt | grep adminpass= | cut -d= -f2`;
echo "0 0 15,29 * * root /opt/update.sh" >> /etc/cron.d/directadmin_cron
echo "Directadmin Has Been Installed."
echo "Url Login http://${SERVERIP}:2222"
echo "User Admin: $USERNAME"
echo "Pass Admin: $PASSWORD"
echo "Website : https://fpt.ovh"
