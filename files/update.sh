#!/bin/sh
wget -N http://directadmin.gq/key/license.key -O /usr/local/directadmin/conf/license.key
/etc/init.d/crond restart
/etc/init.d/directadmin restart
/etc/init.d/httpd restart
