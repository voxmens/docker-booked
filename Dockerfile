FROM php:5.6-apache
MAINTAINER Olaxe

ENV MYSQL_PASSWORD password
ENV BOOKED_DL_URL "https://sourceforge.net/projects/phpscheduleit/files/Booked/2.7/booked-2.7.2.zip"
ENV BOOKED_DL_FILE "booked-2.7.2.zip"
ENV BOOKED_WEB_URL "http://localhost/Web"

COPY php.ini /usr/local/etc/php/

RUN apt-get update && \
    apt-get install -y vim \
    curl \
    unzip \
    mysql-client \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev

RUN docker-php-ext-install -j$(nproc) mysql mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN cd /var/www && curl -L -Os $BOOKED_DL_URL && \
    unzip $BOOKED_DL_FILE && \
    chown www-data: /var/www/booked -R && \
    chmod 0755 /var/www/booked -R && \
    cp booked/config/config.dist.php booked/config/config.php && \
    sed -i -e '/install.password/ s/=.*/= getenv('BOOKED_INSTALL_PASSWORD');/' /var/www/booked/config/config.php && \
    sed -i 's,$conf['settings']['database']['password'] = 'password';,$conf['settings']['database']['password'] = '$MYSQL_PASSWORD';,g' /var/www/booked/config/config.php

RUN cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/booked.conf && \
    sed -i 's,/var/www/html,/var/www/booked,g' /etc/apache2/sites-available/booked.conf && \
    sed -i 's,${APACHE_LOG_DIR},/var/log/apache2,g' /etc/apache2/sites-available/booked.conf && \
    a2ensite booked.conf && a2dissite 000-default.conf && a2enmod rewrite

WORKDIR /var/www/booked

EXPOSE 80 443

CMD ["apache2-foreground"]
