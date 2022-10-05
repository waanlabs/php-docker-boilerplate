FROM ubuntu:latest
LABEL author=Waan<admin@waan.email>
LABEL version=1.0.0

# Sudo user password from environment variable
ARG sudo_passwd

RUN apt update && \
    apt install -y sudo

# Creating a sudo user is recommended.
# Change user(waan) to your prefereance.
#
# RUN adduser --disabled-password --gecos "" waan && \
#     usermod -aG sudo waan && \
#     echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
# To add a sudo user with password, use the following command.
RUN adduser --disabled-password --gecos "" waan && \
    usermod -aG sudo waan && \
    echo  "waan:${sudo_passwd}" | sudo -S chpasswd 

RUN apt install -y tzdata && \
    echo "America/New_York" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

USER waan

RUN echo ${sudo_passwd} | sudo -S apt install -y software-properties-common && \ 
    echo ${sudo_passwd} | sudo -S LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    echo ${sudo_passwd} | sudo -S apt update

RUN echo ${sudo_passwd} | sudo -S apt install -y \
    php8.1 \
    php8.1-xml \
    php8.1-curl \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-zip \
    apache2 \
    curl

RUN echo ${sudo_passwd} | sudo -S a2enmod rewrite
RUN echo ${sudo_passwd} | sudo -S a2enmod php8.1

ADD runtime/apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN echo ${sudo_passwd} | sudo -S sh -c "echo 'ServerName localhost' >> /etc/apache2/apache2.conf"


# Comment out the following line if you want to use compose volumes.
# Using compose volumes is recommeded for development environment.
# ADD source folder to container is recommeded for production.
#
# Ex-
# volumes:
#   - ./services/webapp:/var/www:rw
# in docker-compose.yml
#
# ADD services/webapp /var/www

RUN echo ${sudo_passwd} | sudo -S chown www-data:www-data -R /var/www/

WORKDIR /var/www
RUN echo ${sudo_passwd} | sudo -S rm -rf html/

RUN echo ${sudo_passwd} | sudo -S php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    echo ${sudo_passwd} | sudo -S php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    echo ${sudo_passwd} | sudo -S php -r "unlink('composer-setup.php');" 

ADD runtime/start-script.sh /
RUN echo ${sudo_passwd} | sudo -S chmod +x /start-script.sh

EXPOSE 80

# Entrypoint of the application is set to start.sh
# You can include additional commands to start.sh using bash scripting.
CMD ["/start-script.sh"]
