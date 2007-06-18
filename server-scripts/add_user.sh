#!/bin/bash

# add_user.sh
# Adds a user to this server using certain defaults.

if [ $# != 1 ]; then
	echo "Usage: add_user.sh username"
	exit 1
fi

username=$1

useradd -d /home/$username -m -n -s /bin/bash $username
passwd $username
