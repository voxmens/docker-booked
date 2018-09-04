FROM php:5.6-apache
MAINTAINER Olaxe

ENV BOOKED_DL_URL "https://sourceforge.net/projects/phpscheduleit/files/Booked/2.7/booked-2.7.2.zip"
ENV BOOKED_DL_FILE "booked-2.7.2.zip"
ENV BOOKED_APP_TITLE "Booked Scheduler"
ENV BOOKED_DEFAULT_TIMEZONE "America/Chicago"
ENV BOOKED_ALLOW_SELF_REGISTRATION "true"
ENV BOOKED_ADMIN_EMAIL "admin@example.com"
ENV BOOKED_ADMIN_EMAIL_NAME "Booked Administrator"
ENV BOOKED_ENABLE_EMAIL "true"
ENV BOOKED_DEFAULT_LANGUAGE "en_us"
ENV BOOKED_WEB_URL "http://localhost/Web"
ENV BOOKED_HOME_URL "$BOOKED_WEB_URL/dashboard.php"
ENV BOOKED_DATABASE_TYPE "mysql"
ENV BOOKED_DATABASE_USER "booked_user"
ENV BOOKED_DATABASE_PASSWORD "password"
ENV BOOKED_DATABASE_HOSTSPEC "ttmysqldb"
ENV BOOKED_DATABASE_NAME "bookedscheduler"
ENV BOOKED_PHPMAILER_MAILER "mail"
ENV BOOKED_PHPMAILER_SMTP_HOST ""
ENV BOOKED_PHPMAILER_SMTP_PORT "25"
ENV BOOKED_PHPMAILER_SMTP_SECURE ""
ENV BOOKED_PHPMAILER_SMTP_AUTH "true"
ENV BOOKED_PHPMAILER_SMTP_USERNAME ""
ENV BOOKED_PHPMAILER_SMTP_PASSWORD ""
ENV BOOKED_PHPMAILER_SENDMAIL_PATH "/usr/sbin/sendmail"
ENV BOOKED_PHPMAILER_SMTP_DEBUG "false"
ENV BOOKED_INSTALL_PASSWORD ""
ENV BOOKED_API_ENABLED "true"
ENV BOOKED_EMAIL_DEFAULT_FROM_ADDRESS = ""
ENV BOOKED_EMAIL_DEFAULT_FROM_NAME = ""
ENV BOOKED_CREDITS_ENABLED = "false"
ENV BOOKED_CREDITS_ALLOW_PURCHASE = "false"

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
    cp booked/config/config.dist.php booked/config/config.php
RUN sed -i -e '/app.title/ s/=.*/= getenv('BOOKED_APP_TITLE');/' /var/www/booked/config/config.php
RUN sed -i -e '/default.timezone/ s/=.*/= getenv('BOOKED_DEFAULT_TIMEZONE');/' /var/www/booked/config/config.php
RUN sed -i -e '/allow.self.registration/ s/=.*/= getenv('BOOKED_ALLOW_SELF_REGISTRATION');/' /var/www/booked/config/config.php
RUN sed -i -e '/admin.email/ s/=.*/= getenv('BOOKED_ADMIN_EMAIL');/' /var/www/booked/config/config.php
RUN sed -i -e '/admin.email.name/ s/=.*/= getenv('BOOKED_ADMIN_EMAIL_NAME');/' /var/www/booked/config/config.php
RUN sed -i -e '/enable.email/ s/=.*/= getenv('BOOKED_ENABLE_EMAIL');/' /var/www/booked/config/config.php
RUN sed -i -e '/default.language/ s/=.*/= getenv('BOOKED_DEFAULT_LANGUAGE');/' /var/www/booked/config/config.php
RUN sed -i -e '/script.url/ s/=.*/= getenv('BOOKED_WEB_URL');/' /var/www/booked/config/config.php
RUN sed -i -e '/home.url/ s/=.*/= getenv('BOOKED_HOME_URL');/' /var/www/booked/config/config.php
RUN sed -i -e '/logout.url/ s/=.*/= getenv('BOOKED_WEB_URL');/' /var/www/booked/config/config.php
RUN sed -i -e '/database'\''s\]\['\''type/ s/=.*/= getenv('BOOKED_DATABASE_TYPE');/' /var/www/booked/config/config.php
RUN sed -i -e '/database'\''s\]\['\''user/ s/=.*/= getenv('BOOKED_DATABASE_USER');/' /var/www/booked/config/config.php
RUN sed -i -e '/database'\''s\]\['\''password/ s/=.*/= getenv('BOOKED_DATABASE_PASSWORD');/' /var/www/booked/config/config.php
RUN sed -i -e '/database'\''s\]\['\''hostspec/ s/=.*/= getenv('BOOKED_DATABASE_HOSTSPEC');/' /var/www/booked/config/config.php
RUN sed -i -e '/database'\''s\]\['\''name/ s/=.*/= getenv('BOOKED_DATABASE_NAME');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''mailer/ s/=.*/= getenv('BOOKED_PHPMAILER_MAILER');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.host/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_HOST');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.port/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_PORT');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.secure/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_SECURE');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.auth/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_AUTH');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.username/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_USERNAME');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.password/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_PASSWORD');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''sendmail.path/ s/=.*/= getenv('BOOKED_PHPMAILER_SENDMAIL_PATH');/' /var/www/booked/config/config.php
RUN sed -i -e '/phpmailer'\''s\]\['\''smtp.debug/ s/=.*/= getenv('BOOKED_PHPMAILER_SMTP_DEBUG');/' /var/www/booked/config/config.php
RUN sed -i -e '/install.password/ s/=.*/= getenv('BOOKED_INSTALL_PASSWORD');/' /var/www/booked/config/config.php
RUN sed -i -e '/api.enabled/ s/=.*/= getenv('BOOKED_API_ENABLED');/' /var/www/booked/config/config.php
RUN sed -i -e '/email'\''s\]\['\''default.from.address/ s/=.*/= getenv('BOOKED_EMAIL_DEFAULT_FROM_ADDRESS');/' /var/www/booked/config/config.php
RUN sed -i -e '/email'\''s\]\['\''default.from.name/ s/=.*/= getenv('BOOKED_EMAIL_DEFAULT_FROM_NAME');/' /var/www/booked/config/config.php
RUN sed -i -e '/credits'\''s\]\['\''enable/ s/=.*/= getenv('BOOKED_CREDITS_ENABLED');/' /var/www/booked/config/config.php
RUN sed -i -e '/credits'\''s\]\['\''allow.purchase/ s/=.*/= getenv('BOOKED_CREDITS_ALLOW_PURCHASE');/' /var/www/booked/config/config.php
RUN cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/booked.conf && \
    sed -i 's,/var/www/html,/var/www/booked,g' /etc/apache2/sites-available/booked.conf && \
    sed -i 's,${APACHE_LOG_DIR},/var/log/apache2,g' /etc/apache2/sites-available/booked.conf && \
    a2ensite booked.conf && a2dissite 000-default.conf && a2enmod rewrite

WORKDIR /var/www/booked

EXPOSE 80 443

CMD ["apache2-foreground"]
