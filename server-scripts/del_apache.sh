#!/bin/bash

# $Id$
#
# del_apache.sh
# Removes a domain from Apache 2.2

if [ $# != 2 ]; then
	echo "Usage: del_apache.sh domain parent"
	exit 1
fi

DOMAIN="$1"
PARENT="$2"

if [ ! -f "/etc/apache2/vhosts.d/$PARENT/$DOMAIN.conf" ]; then
	echo "!!! This virtual host does not exist yet!"
	exit 2
fi

rm -f "/etc/apache2/vhosts.d/$PARENT/$DOMAIN.conf"

echo " * Removed $DOMAIN from Apache"

/etc/init.d/apache2 reload
