#!/usr/bin/bash
sudo /usr/sbin/apachectl -D FOREGROUND

# Use sudo composer install in start-script.sh (no output),
# or docker exec -it webapp /bin/bash -c "cd /var/www && composer install" (output) 
# after the build.
