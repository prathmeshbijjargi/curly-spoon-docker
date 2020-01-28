FROM ubuntu:16.04
MAINTAINER Prathmesh Bijjargi <prathmeshbijjargi@gmail.com>

# Environments vars
ENV TERM=xterm

RUN apt-get update
RUN apt-get -y upgrade

# Packages installation
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install software-properties-common
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install php7.2 \
      php7.2-fpm \
      php7.2-gd \
      php7.2-cli \
      php7.2-json \
      php7.2-mbstring \
      php7.2-xml \
      php7.2-xsl \
      php7.2-zip \
      php7.2-soap \
      php7.2-mongodb \
      php7.2-curl \
      php7.2-imagick \
      php7.2-zmq \
      php7.2-simplexml \	
      apt-transport-https \
      git \
      nano \
      vim \
      curl \
      lynx-cur

RUN apt-get update

# Install supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install supervisor
RUN mkdir -p /var/log/supervisor

# Install nginx (full)
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx

# Composer install
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# PHP conf
ADD config/php/php.ini /etc/php/7.2/fpm/php.ini

# Copy website Nginx config file
COPY config/nginx/jtdev.conf /etc/nginx/sites-available/default

# Supervisor conf
ADD config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add phpinfo script for INFO purposes
RUN echo "<?php phpinfo();" >> /var/www/html/index.php

WORKDIR /var/www/html/

# Create socker
RUN mkdir -p /run/php

# Volume
VOLUME /var/www/html

# Ports: nginx
EXPOSE 80

COPY  config/crontab/crontab /etc/cron.d/cron-task
RUN chmod 0644 /etc/cron.d/cron-task

CMD ["/usr/bin/supervisord"]
