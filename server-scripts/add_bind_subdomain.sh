#!/bin/bash

# add_bind_subdomain.sh
# Add a subdomain to a domain in BIND

if [ $# != 3 ]; then
	echo "Usage: add_bind_subdomain.sh <parent> <subdomain> <domain>"
	exit 1
fi

PARENT="$1"
SUBDOMAIN="$2"
DOMAIN="$3"

# check to see if the zone exists - if not, abort!
if [ ! -f "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" ]; then
	echo "!!! This domain does not exist yet"
	exit 2
fi

# Make a copy of the zone file
cp -f "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" /tmp/out.subdomain

# Add a subdomain line.
echo "$SUBDOMAIN            IN      A       65.38.25.234" >> "/tmp/out.subdomain"

# Update the serial number

# permissions (rw-rw-r--)
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
