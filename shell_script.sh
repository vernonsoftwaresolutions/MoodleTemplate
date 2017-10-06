#!/bin/bash

#COPY moodle-config.php /var/www/html/config.php

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -sf /bin/true /sbin/initctl
mkdir /var/moodledata
# Let the container know that there is no tty
DEBIAN_FRONTEND=noninteractive

# Database info
echo export DB_PORT_3306_TCP_ADDR=127.0.0.1 >> /etc/environment
echo export DB_ENV_MYSQL_DATABASE=moodle >> /etc/environment
echo export DB_ENV_MYSQL_PASSWORD=moodle >> /etc/environment
echo export DB_ENV_MYSQL_USER=moodle >> /etc/environment
echo export DB_PORT_3306_TCP_PORT=http://192.168.59.103 >> /etc/environment
echo export MOODLE_URL=http://192.168.59.103 >> /etc/environment

#ADD ./foreground.sh /etc/apache2/foreground.sh

apt-get update && \
	apt-get -y install mysql-client pwgen python-setuptools curl git unzip apache2 php5 \
		php5-gd libapache2-mod-php5 postfix wget supervisor php5-pgsql curl libcurl3 \
		libcurl3-dev php5-curl php5-xmlrpc php5-intl php5-mysql git-core && \
	cd /tmp && \
	git clone -b MOODLE_29_STABLE git://git.moodle.org/moodle.git --depth=1 && \
	mv /tmp/moodle/* /var/www/html/ && \
	rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html && \
#	chmod +x /etc/apache2/foreground.sh

# Enable SSL, moodle requires it
a2enmod ssl && a2ensite default-ssl # if using proxy, don't need actually secure connection

echo "placeholder" > /var/moodledata/placeholder
chown -R www-data:www-data /var/moodledata
chmod 777 /var/moodledata

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND