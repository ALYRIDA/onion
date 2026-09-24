#!/bin/bash

# ft_onion startup script - simplified

echo "Starting Nginx..."
nginx

echo "Starting SSH..."
/usr/sbin/sshd

echo "Starting Tor..."
su -s /bin/bash -c 'tor' debian-tor &

# Keep container running
sleep infinity
