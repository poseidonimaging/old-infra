#!/bin/bash

# Installs activeCollab for user $1
# with domain $2 and prefix $3

if [ $# != 3 ]; then
	echo "Usage: install_activecollab.sh <user> <domain> <table_prefix>"
	exit 1
fi

# Variables
INSTUSER="$1"
DOMAIN="$2"
TABLEPREFIX="$3"
PASSWORD="KTJW0E3gCjvDwGf6vA6hw"

# Prep install dir

if [ -d "/home/$INSTUSER/$DOMAIN" ]; then
	echo "!!! This activeCollab installation already exists."
	exit 2
fi

mkdir "/home/$INSTUSER/$DOMAIN"

# Copy activeCollab

cp -r /var/www/localhost/htdocs/activecollab/* "/home/$INSTUSER/$DOMAIN/"
cp /var/www/localhost/htdocs/activecollab/.htaccess "/home/$INSTUSER/$DOMAIN/"

# Configure activeCollab.
sed -e 's/__PREFIX__/$TABLEPREFIX/g' "/home/$INSTUSER/$DOMAIN/config/config.php" > /tmp/out.ac_conf1
sed -e 's#__URL__#http://$DOMAIN/#g' /tmp/out.ac_conf1 > /tmp/out.ac_conf2

# Move config file
rm -f "/home/$INSTUSER/$DOMAIN/config/config.php"
cp /tmp/out.ac_conf2 "/home/$INSTUSER/$DOMAIN/config/config.php"

# Permissions
chown -R $INSTUSER:$INSTUSER "/home/$INSTUSER/$DOMAIN/"
chmod -R 774 "/home/$INSTUSER/$DOMAIN/"

# SQL
sed -e 's/ac0/$TABLEPREFIX/g' "/home/$INSTUSER/$DOMAIN/config/posima_activecollab.sql" > /tmp/out.ac_sql

echo " * Copying SQL tables..."

# Copy into MySQL
mysql -u posima --password=$PASSWORD posima_activecollab < /tmp/out.ac_sql

echo " * Successfully installed activeCollab for $DOMAIN"
