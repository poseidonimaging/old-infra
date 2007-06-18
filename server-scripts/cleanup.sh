#!/bin/bash

# cleanup.sh
# Removes out.* files from /tmp

rm -rf /tmp/out.bind
rm -rf /tmp/out.bindinc1
rm -rf /tmp/out.bindinc2
rm -rf /tmp/out.apache1
rm -rf /tmp/out.apache2

echo " * Cleaned up..."
