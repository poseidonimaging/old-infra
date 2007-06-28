#!/bin/bash

# $Id$
#
# svn_dns_chroot.sh
# Copies files from the DNS chroot to SVN
# The WC is ~/dns-chroot/ by default.

# Set the working copy path here. Do not use a trailing slash.
WC_PATH="/root/dns-chroot"

cp -f /chroot/dns/etc/bind/*.conf "$WC_PATH/etc/bind/"
cp -f -R /chroot/dns/var/bind/* "$WC_PATH/var/bind/"
svn commit "$WC_PATH" -m "Automatic DNS chroot update"

