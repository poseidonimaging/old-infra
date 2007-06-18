#!/bin/bash

# add_posima.sh
# Adds a Posima domain

echo "Add A Posima Domain"
echo "==================="
echo ""
echo -n "Domain Name > "
read domain
if [ "$domain" == "" ]; then
	echo ""
	echo "No domain entered, exiting."
	exit 1
fi
echo -n "Really add $domain? (y/n)"
read verify
if [ "$verify" == "y" ]; then
	# add to bind
	/usr/local/posima/add_bind.sh $domain posima

	# prep home folder stuff
	mkdir /home/posima/$domain
	chown posima:apache /home/posima/$domain
	chmod 774 /home/posima/$domain
	
	# add to apache
	/usr/local/posima/add_apache.sh $domain posima /home/posima/$domain

	# cleanup
	/usr/local/posima/cleanup.sh

	echo "Done."
else
	echo "You didn't say 'y', exiting."
fi
