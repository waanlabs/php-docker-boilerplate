FROM ubuntu:latest
LABEL author=Waan<admin@waan.email>
LABEL version=1.0.0

# Creating a sudo user is recommended.
RUN apt update && \
    apt install -y sudo

# Change user(waan) to your prefereance.
# 
# echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# will allow sudo without password.
#
# RUN adduser --disabled-password --gecos "" waan && \
#    adduser waan sudo && \
#    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
# To add a sudo user with password, use the following command.
RUN adduser --disabled-password --gecos "" waan && \
    usermod -aG sudo waan && \
    echo  "waan:${PASSWD}" | sudo -S chpasswd 

RUN apt install -y tzdata && \
    echo "America/New_York" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

USER waan

RUN echo ${PASSWD} | sudo -S apt install -y software-properties-common && \
    echo ${PASSWD} | sudo -S LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    echo ${PASSWD} | sudo -S apt update

RUN echo ${PASSWD} | sudo -S apt install -y \
    php8.1 \
    php8.1-xml \
    php8.1-curl \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-zip \
    apache2 \
    curl

RUN echo ${PASSWD} | sudo -S a2enmod rewrite
RUN echo ${PASSWD} | sudo -S a2enmod php8.1

ADD runtime/apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN echo ${PASSWD} | sudo -S sh -c "echo 'ServerName localhost' >> /etc/apache2/apache2.conf"

# Comment out the following line if you want to use composer volumes.
# Using composer volumes is recommeded for development environment.
# ADD source folder to container is recommeded for production.
#
# Ex-
# volumes:
#   - ./services/webapp:/var/www:rw
#
# in docker-compose.yml
# ADD services/webapp /var/www

RUN echo ${PASSWD} | sudo -S chown www-data:www-data -R /var/www/

WORKDIR /var/www
RUN echo ${PASSWD} | sudo -S rm -rf html/

# #RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer && \
## sudo composer install

ADD runtime/start.sh /
RUN echo ${PASSWD} | sudo -S chmod +x /start.sh

EXPOSE 80

# Entrypoint of the application is set to start.sh
# You can include additional commands to start.sh using bash scripting.
CMD ["/start.sh"]
