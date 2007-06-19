#!/bin/bash

# $Id$
#
# add_apache.sh
# Adds a domain to Apache 2.2

if [ $# != 3 ]; then
	echo "Usage: add_apache.sh domain parent docroot"
	exit 1
fi

DOMAIN="$1"
PARENT="$2"
DOCROOT="$3"

if [ -f "/etc/apache2/vhosts.d/$PARENT/$DOMAIN.conf" ]; then
	echo "!!! This virtual host already exists and cannot be re-added."
	exit 2
fi

# modify template
sed -e 's/__DOMAIN__/'$DOMAIN'/g' /usr/local/posima/template.apache > /tmp/out.apache1
sed -e 's#__DOCROOT__#'$DOCROOT'#g' /tmp/out.apache1 > /tmp/out.apache2

cp -f "/tmp/out.apache2" "/etc/apache2/vhosts.d/$PARENT/$DOMAIN.conf"

echo " * Apache configured for $DOMAIN under $PARENT"

/etc/init.d/apache2 reload
