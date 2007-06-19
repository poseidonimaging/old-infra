#!/bin/bash

# $Id$
#
# bind_sanity_check.sh
# Checks the permissions for BIND directories/config files for
# the specified domain/parent
#

if [ $# != 2 ]; then
	echo "Usage: bind_sanity_check.sh domain parent"
	exit 1
fi
	
DOMAIN="$1"
PARENT="$2"

# permissions (rwxrwxr-x)
chmod 775 "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"
chown named:named "/chroot/dns/var/bind/pri/$PARENT/$DOMAIN.zone"

# verify permissions for parent include file
chmod 775 "/chroot/dns/etc/bind/$PARENT.inc.conf"
chown named:named "/chroot/dns/etc/bind/$PARENT.inc.conf"

# double check permissions on the parent folder to make sure recursion is allowed
# (translation: if the directory isn't +x, BIND refuses to enter it)
chmod 777 "/chroot/dns/var/bind/pri/$PARENT"
chown named:named "/chroot/dns/var/bind/pri/$PARENT"

echo " * BIND sanity checks completed"
