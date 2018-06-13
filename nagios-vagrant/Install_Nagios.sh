#!/bin/bash

#Install Nagios Core
 
#Install prereqs
apt-get update
apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.0 libgd2-xpm-dev
 
#Download source
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz
tar xzf nagioscore.tar.gz
 
#Compile
cd /tmp/nagioscore-nagios-4.3.4/
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
 
#Create user and group
useradd nagios
usermod -a -G nagios www-data
 
#Install binaries
make install
 
 
#Install Service
make install-init
update-rc.d nagios defaults
 
 
#Install commandmode
make install-commandmode
 
 
#Install sample config
make install-config
 
#Install apache config
make install-webconf
a2enmod rewrite
a2enmod cgi
 
#Configure Firewall
ufw allow Apache
ufw reload
 
#Setup nagiosadmin user account
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
 
 
##Install Nagios Plugins
 
#install prereqs
apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext
 
#Download source
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz

#Compile and install
cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install
 

