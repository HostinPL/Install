if [ `getconf LONG_BIT` -ne "32" ]; 
then
      installpack="apache2 php5 mysql-server php5-mysql php5-gd libssh2-php openssh-server python3 screen wget unzip mc phpmyadmin ia32-libs openjdk-7-jre sudo proftpd mysql-client mysql-workbench curl php5-curl"
else
     installpack="apache2 php5 mysql-server php5-mysql php5-gd libssh2-php openssh-server python3 screen wget unzip mc phpmyadmin openjdk-7-jre sudo proftpd mysql-client mysql-workbench curl php5-curl"
fi
dpkg --add-architecture i386
apt-get update
export DEBIAN_FRONTEND=noninteractive;apt-get --allow-unauthenticated -y -q install $installpack
cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
cd /tmp && wget -q -O - https://raw.githubusercontent.com/Amet13/ddos-deflate/master/install.sh | bash && cd /root

rm /var/www/index.html
wget https://github.com/HostinPL/HostinPL/archive/master.zip
mv master.zip hostinpl-2.zip
wget https://github.com/HostinPL/Daemon/archive/master.zip
mv master.zip hostplcp.zip
unzip hostplcp.zip -d /home/
unzip hostinpl-2.zip -d /var/www/
cd /var/www/HostinPL-master/
mv * /var/www/
cd /home/Daemon-master
mv * /home/
rm hostplcp.zip
rm hostinpl-2.zip
chmod 700 /home/cp
chmod 700 /home/cp/gameservers.py
chmod 777 /var/www/application/config.php
chmod 777 /var/www/avatar
chmod 777 /var/www/tmp
groupadd gameservers
ln -s /usr/share/phpmyadmin /var/www/phpmyadmin


dlinapass=10
rootmysqlpass=`base64 -w $dlinapass /dev/urandom | head -n 1`
mysqladmin -uroot password $rootmysqlpass
echo "create database hostin" | mysql -uroot -p$rootmysqlpass
mysql hostin -uroot -p$rootmysqlpass < /var/www/hostinpl.sql

a2enmod rewrite
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/sites-enabled/000-default
sed -i 's/# DefaultRoot/DefaultRoot/g' /etc/proftpd/proftpd.conf
sudo sh -c "echo 'DenyGroups gameservers' >> /etc/ssh/sshd_config"
service apache2 restart
service proftpd restart
service ssh restart

for i in `seq 1 100`;
do
   echo 
done

echo " " | mysql -uroot -p$rootmysqlpass


ROOTMYSQL=$rootmysqlpass
sed -i "s/parol/${ROOTMYSQL}/g" /var/www/application/config.php
IP=`ifconfig eth0 | grep "inet addr" | head -n 1 | cut -d : -f 2 | cut -d " " -f 1`
sed -i "s/domen.ru/${IP}/g" /var/www/application/config.php
sed -i 's/# DefaultRoot/DefaultRoot/g' /etc/proftpd/proftpd.conf
sed -i 's/LoadModule mod_tls_memcache.c/#LoadModule mod_tls_memcache.c/g' /etc/proftpd/modules.conf
sed -i 's/300/20/g' /usr/local/ddos-deflate/ddos-deflate.conf
sed -i 's/600/300/g' /usr/local/ddos-deflate/ddos-deflate.conf
sed -i 's/CUSTOM_PORTS=NO/CUSTOM_PORTS=":80|:443:|:53|:21"/g' /usr/local/ddos-deflate/ddos-deflate.conf
chmod -R 777 /var/www/*
sudo sh -c "echo 'www-data ALL=NOPASSWD: ALL' >> /etc/sudoers"
sudo sh -c "echo 'DenyGroups gameservers' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'export LANG=C.UTF-8' >> /etc/default/locale"

info="Установка пройдена успешно!\n
--------------------------------------------------\n
Данные для входа в панель:\n
URL: http://$IP/\n
--------------------------------------------------\n
--------------------------------------------------\n
Данные от PHPmyadmin:\n
Адрес: http://$IP/phpmyadmin/\n
Пользователь: root\n
Пароль: $rootmysqlpass\n
База: hostin\n
--------------------------------------------------\n
Спасибо за покупки панели HostinPL v.5.4\n
-------------------vk.com/hosting_rus-----------\n"
echo $info