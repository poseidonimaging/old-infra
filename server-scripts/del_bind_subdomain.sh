#!/bin/bash

# $Id$
#
# del_bind_subdomain.sh
# Deletes a subdomain in BIND

# TODO: Integrate SVN so that a bad add can be rolled back simply.

if [ $# != 3 ]; then
        echo "Usage: del_bind_subdomain.sh parent subdomain domain"
        exit 1
fi

PARENT="$1"
SUBDOMAIN="$2"
DOMAIN="$3"

# Misc constants
SERVER_IPADDR="65.38.25.234"

# check to see if the zone exists - if not, abort!
if [ ! -f "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" ]; then
        echo "!!! This domain does not exist yet, please create it."
        echo "!!! If it does exist, please verify you aren't putting"
        echo "!!! www before the domain (i.e. it should be specified as"
        echo "!!! poseidonimaing.com)"
        exit 2
fi

# Comment-out the subdomain line (s/^subdomain/; subdomain/)
sed -e 's/^'$SUBDOMAIN'/; deleted - '$SUBDOMAIN'/' "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" > /tmp/out.subdomain1

# To prevent against sed eating things...
if [ $? != 0 ]; then
	echo "!!! sed encountered a fatal error. This script will"
	echo "!!! not continue."
	exit 3
fi

# Update the serial number (thanks anonymous dude from some forum)
gawk -f update_serial.awk /tmp/out.subdomain1 > /tmp/out.subdomain2

# Copy the zone back where it came from.
cp -f /tmp/out.subdomain2 "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"

# Run BIND sanity check
sh /usr/local/posima/bind_sanity_check.sh $DOMAIN $PARENT

echo " * Subdomain $SUBDOMAIN.$DOMAIN added to $PARENT."

# reload named
/etc/init.d/named reload

