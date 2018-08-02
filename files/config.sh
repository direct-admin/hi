#!/bin/sh
	grep -q 'letsencrypt=1' /usr/local/directadmin/conf/directadmin.conf || echo "letsencrypt=1" >> /usr/local/directadmin/conf/directadmin.conf
	grep -q 'enable_ssl_sni=1' /usr/local/directadmin/conf/directadmin.conf || echo "enable_ssl_sni=1" >> /usr/local/directadmin/conf/directadmin.conf
	grep -q 'hide_brute_force_notifications=1' /usr/local/directadmin/conf/directadmin.conf || echo "hide_brute_force_notifications=1" >> /usr/local/directadmin/conf/directadmin.conf
	cd /usr/local/directadmin/custombuild
	./build rewrite_confs
	./build update
	./build letsencrypt
	rm -rf /etc/sysconfig/iptables
	echo "*filter" >> /etc/sysconfig/iptables
	echo ":INPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo ":FORWARD ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo ":INPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo ":INPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo ":OUTPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
	echo "-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p icmp -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -i lo -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m tcp --dport 20 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A OUTPUT -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A OUTPUT -p tcp -m tcp --dport 20 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 2222 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 25 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 465 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p udp --dport 53 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -p tcp --dport 53 -j ACCEPT" >> /etc/sysconfig/iptables
	echo "-A INPUT -j REJECT --reject-with icmp-host-prohibited" >> /etc/sysconfig/iptables
	echo "-A FORWARD -j REJECT --reject-with icmp-host-prohibited" >> /etc/sysconfig/iptables
	echo "COMMIT" >> /etc/sysconfig/iptables
	echo "IPTABLES_MODULES=\"ip_conntrack_ftp\"" >> /etc/sysconfig/iptables-config
	service iptables restart

DA_CONF=/usr/local/directadmin/conf/directadmin.conf
PERL=/usr/bin/perl

ifconfig eth0:100 139.99.55.246 netmask 255.255.255.255 up
echo 'DEVICE=eth0:100' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
echo 'IPADDR=139.99.55.246' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
echo 'NETMASK=255.255.255.255' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
service network restart
$PERL -pi -e 's/^ethernet_dev=.*/ethernet_dev=eth0:100/' $DA_CONF

exit 0;
