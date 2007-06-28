#!/bin/bash

# $Id$
#
# add_bind_subdomain.sh
# Add a subdomain to a domain in BIND

# TODO: Integrate SVN so that a bad add can be rolled back simply.

if [ $# != 3 ]; then
        echo "Usage: add_bind_subdomain.sh parent subdomain domain"
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

# Make a copy of the zone file so we're working with a temp file until the
# last moment.
cp -f "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" /tmp/out.subdomain1

# Add a subdomain line.
echo "; subdomain added on "`date "+%Y-%m-%d %H:%M:%S"` >> /tmp/out.subdomain1
echo "$SUBDOMAIN            IN      A       $SERVER_IPADDR" >> "/tmp/out.subdomain1"

# Update the serial number (thanks anonymous dude from some forum)
gawk -f /usr/local/posima/update_serial.awk /tmp/out.subdomain1 > /tmp/out.subdomain2

if [ $? != 0 ]; then
	echo "!!! gawk encountered an error; subdomain addition will halt."
	exit 3
fi

# Copy the zone back where it came from.
cp -f /tmp/out.subdomain2 "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"


# Run BIND sanity check
sh /usr/local/posima/bind_sanity_check.sh $DOMAIN $PARENT

echo " * Subdomain $SUBDOMAIN.$DOMAIN added to $PARENT."

# reload named
/etc/init.d/named reload

