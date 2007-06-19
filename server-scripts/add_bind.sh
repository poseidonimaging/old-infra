#!/bin/bash

# $Id$
#
# add_bind.sh
# Add a Domain to BIND

if [ $# != 2 ]; then
	echo "Usage: add_bind.sh domain parent"
	exit 1
fi

DOMAIN="$1"
PARENT="$2"

# check to see if the zone exists - if so, abort!
if [ -f "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone" ]; then
	echo "!!! This domain already exists and cannot be added."
	exit 2
fi

# modify template to insert current date
sed -e 's/__DATE__/'`date +%Y%m%d00`'/g' /usr/local/posima/template.bind > /tmp/out.bind
cp -f "/tmp/out.bind" "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"

# insert domain into include file
sed -e 's/__DOMAIN__/'$DOMAIN'/g' /usr/local/posima/template.bindinc > /tmp/out.bindinc1
sed -e 's/__PARENT__/'$PARENT'/g' /tmp/out.bindinc1 > /tmp/out.bindinc2

cat "/tmp/out.bindinc2" >> "/chroot/dns/etc/bind/$PARENT.inc.conf"

# Perform sanity check
sh /usr/local/posima/bind_sanity_check.sh $DOMAIN $PARENT

echo " * Domain $DOMAIN added to $PARENT."

# reload named
/etc/init.d/named reload
