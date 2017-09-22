#!/bin/bash

chmod +x ./shell_script.sh

dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

ENV DEBIAN_FRONTEND noninteractive

apt-get update
apt-get -y upgrade

apt-get -y install mysql-server mysql-client pwgen python-setuptools curl git unzip

apt-get -y install apache2 postfix wget supervisor vim curl libcurl3 libcurl3-dev
apt-get -y install php php-mysql php-xml php-curl php-zip php-gd php-xmlrpc php-soap php-mbstring php-intl

echo 'extension=zip.so' >> /etc/php/7.0/apache2/php.ini

apt-get -y install openssh-server
mkdir -p /var/run/sshd

mkdir -p /var/run/apache2
mkdir -p /var/lock/apache2

mkdir -p /var/run/mysqld
chown mysql /var/run/mysqld

sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

easy_install supervisor
add ./start.sh /start.sh
add ./foregound.sh /etc/apache2/foreground.sh
add ./supervisord.conf /etc/supervisord.conf

add https://download.moodle.org/download.php/direct/stable32/moodle-latest-32.tgz /var/www/moodle-latest.tgz
cd /var/www; tar zxvf moodle-latest.tgz; mv /var/www/moodle /var/www/html
chown -R www-data:www-data /var/www/html/moodle
mkdir /var/moodledata
schown -R www-data:www-data /var/moodledata; chmod 777 /var/moodledata
chmod 755 /start.sh /etc/apache2/foreground.sh

expose 22 80
CMD ["/bin/bash", "/start.sh"]