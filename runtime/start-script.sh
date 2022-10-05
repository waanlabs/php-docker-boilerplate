#!/usr/bin/sh

echo ${SUDO_PASSWD} | sudo -S /usr/sbin/apachectl -D FOREGROUND
echo ${SUDO_PASSWD} | sudo -S composer install
