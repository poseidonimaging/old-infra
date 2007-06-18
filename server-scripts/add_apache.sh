#!/bin/bash

# add_apache.sh
# Adds a domain to Apache 2.2

if [ $# != 3 ]; then
	echo "Usage: add_apache.sh domain parent docroot"
	exit 1
fi

domain="$1"
parent="$2"
docroot="$3"

if [ -f "/etc/apache2/vhosts.d/$parent/$domain.conf" ]; then
	echo "!!! This virtual host already exists and cannot be re-added."
	exit 2
fi

# modify template
sed -e 's/__DOMAIN__/'$domain'/g' /usr/local/posima/template.apache > /tmp/out.apache1
sed -e 's#__DOCROOT__#'$docroot'#g' /tmp/out.apache1 > /tmp/out.apache2

cp -f "/tmp/out.apache2" "/etc/apache2/vhosts.d/$parent/$domain.conf"

echo " * Apache configured for $domain under $parent"

/etc/init.d/apache2 reload
