#!/usr/bin/env bash

. /etc/profile.d/vagrant.sh

BENCH_HOME=${BENCH_HOME:-/home/vagrant}
BENCH_NAME=${BENCH_NAME:-erpnext-bench}
BENCH_GIT=${BENCH_GIT:-https://github.com/frappe/bench}
MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:-root}
FRAPPE_SITE=${FRAPPE_SITE:-erpnext.local}
FRAPPE_ADMIN_PWD=${FRAPPE_ADMIN_PWD:-admin}
ERPNEXT_GIT=${ERPNEXT_GIT:-https://github.com/frappe/erpnext.git}
APT_INSTALL=${APT_INSTALL:-yes}


apt_install() {

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "postfix postfix/mailname string `hostname`"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password root"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password root"

# install mariadb
sudo apt-get update

sudo apt-get install -y software-properties-common python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu precise main'
sudo apt-get update

# install dependencies
sudo apt-get install python-dev python-setuptools build-essential python-mysqldb git ntp vim screen htop mariadb-server mariadb-common libmariadbclient-dev libxslt1.1 libxslt1-dev redis-server libssl-dev libcrypto++-dev postfix nginx supervisor python-pip fontconfig libxrender1 libxext6 xfonts-75dpi xfonts-base -y

echo "Installing wkhtmltopdf"
wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-precise-i386.deb
dpkg -i wkhtmltox-0.12.2.1_linux-precise-i386.deb

# nodejs
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs

# bs
sudo apt-get install -y language-pack-bs

# setup mariadb conf
config="
[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
[mysql]
default-character-set = utf8mb4
"
echo "$config" > /etc/mysql/conf.d/barracuda.cnf
sudo service mysql restart
# mysqladmin -u root password root

}

[ "$APT_INSTALL" == "yes" ] && apt_install


su vagrant << EOF

whoami

cd $BENCH_HOME
echo BENCH_HOME=$BENCH_HOME, BENCH_GIT=$BENCH_GIT, APT_INSTALL=$APT_INSTALL, FRAPPE_GIT=$FRAPPE_GIT, pwd=$(pwd)
git clone $BENCH_GIT bench-repo
sudo pip install -e bench-repo

echo "Installing erpnext-bench"

cd $BENCH_HOME
bench init $BENCH_NAME
cd $BENCH_HOME/$BENCH_NAME
bench get-app erpnext $ERPNEXT_GIT

bench new-site $FRAPPE_SITE --mariadb-root-password $MYSQL_ROOT_PWD --admin-password $FRAPPE_ADMIN_PWD
bench use $FRAPPE_SITE
bench install-app erpnext

bench setup socketio
bench setup supervisor
bench setup nginx
bench setup redis-async-broker
bench setup redis-cache
bench setup procfile --with-watch

EOF

echo "Installed"
echo "To start console session run:  'vagrant ssh', then go to $BENCH_HOME/$BENCH_NAME and run bench start"
echo "When then bench is started, run browser session on host: http://localhost:8080" 

