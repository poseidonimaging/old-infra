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
cp -f "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" /tmp/out.subdomain

# Add a subdomain line.
echo "$SUBDOMAIN            IN      A       $SERVER_IPADDR" >> "/tmp/out.subdomain1"

# Update the serial number (thanks anonymous dude from some forum)
gawk -f update_serial.awk /tmp/out.subdomain1 > /tmp/out.subdomain2

# Copy the zone back where it came from.
cp -f /tmp/out.subdomain2 "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"


# TODO: move this to a script (bind_sanity_check.sh?)

# permissions (rwxrwxr-x)
chmod 775 "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"
chown named:named "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"

# verify permissions for parent include file
chmod 775 "/chroot/dns/etc/bind/$PARENT.inc.conf"
chown named:named "/chroot/dns/etc/bind/$PARENT.inc.conf"

# double check permissions on the parent folder to make sure recursion is allowed
chmod 777 "/chroot/dns/var/bind/pri/$PARENT"
chown named:named "/chroot/dns/var/bind/pri/$PARENT"

echo " * Subdomain $SUBDOMAIN.$DOMAIN added to $PARENT."

# reload named
/etc/init.d/named reload

