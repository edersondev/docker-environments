# Baixa a imagem do ubuntu
FROM ubuntu:14.04
LABEL maintainer="Ederson Ferreira <ederson.dev@gmail.com>"

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalação dos pacotes
RUN apt-get update && apt-get install -y \
    apache2 \
    php5 \
    php5-cli \
    php5-common \
    php5-gd \
    php5-json \
    php5-ldap \
    php5-pgsql \
    php5-apcu \
    php5-imagick \
    php5-mcrypt \
    php5-xdebug \
    php5-curl \
    curl \
    phpunit \
    nano

# Habilita o modo de reescrita do apache
RUN a2enmod rewrite

ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

VOLUME /var/www/html

# Copia o arquivo de virtualhost
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Install composer
WORKDIR /usr/local/bin/
RUN curl -sS https://getcomposer.org/installer | php
RUN chmod +x composer.phar
RUN mv composer.phar composer
RUN composer self-update

# Set path bin
WORKDIR /root
RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

# Configuração Xdebug
RUN { \
    echo 'xdebug.remote_enable=1'; \
    echo 'xdebug.remote_autostart=1'; \
    echo 'xdebug.remote_port=9000'; \
    echo 'xdebug.remote_connect_back=1'; \
    echo 'xdebug.idekey=vscode'; \
} > /etc/php5/apache2/conf.d/xdebug-conf.ini

RUN { \
    echo 'display_errors = on'; \
    echo '; Get the right number in http://www.bx.com.au/tools/ultimate-php-error-reporting-wizard?php_version=5_3'; \
    echo 'error_reporting = 22527'; \
    echo 'memory_limit = 4096M'; \
    echo 'post_max_size = 200M'; \
    echo 'upload_max_filesize = 200M'; \
    echo 'max_execution_time = 60'; \
    echo 'max_input_time = 120'; \
    echo 'date.timezone = "America/Sao_Paulo"'; \
    echo 'short_open_tag = 1'; \
} > /etc/php5/apache2/conf.d/extra-conf.ini

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Clean
RUN apt-get clean && apt-get autoclean && apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

EXPOSE 80

CMD ["apache2ctl","-D","FOREGROUND"]
