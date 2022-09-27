#!/usr/bin/sh

echo ${PASSWD} | sudo -S /usr/sbin/apachectl -D FOREGROUND
