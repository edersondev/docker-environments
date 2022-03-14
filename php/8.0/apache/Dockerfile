FROM ubuntu:20.04
LABEL maintainer="Ederson Ferreira <ederson.dev@gmail.com>"

ARG PHP_VERSION=8.0

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ondrej.pgp /root/ondrej.pgp

RUN apt-get update && apt-get install -y --no-install-recommends gnupg \
 && cat /root/ondrej.pgp | apt-key add \
 && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" >> /etc/apt/sources.list.d/ondrej-php.list \
 && echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu focal main" >> /etc/apt/sources.list.d/ondrej-php.list

RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php${PHP_VERSION} \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION} \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-mbstring \
    unzip \
    zip \
    curl \
    nano \
    locales

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8

ENV LANG pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

# Habilita o modo de reescrita do apache
RUN a2enmod rewrite

ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

# Copia o arquivo de virtualhost
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# Install composer
WORKDIR /usr/local/bin/
RUN curl -sS https://getcomposer.org/installer | php
RUN chmod +x composer.phar
RUN mv composer.phar composer

# Set path bin
WORKDIR /root
RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=2'; \
	echo 'opcache.fast_shutdown=1'; \
	echo 'opcache.enable_cli=1'; \
} > /etc/php/${PHP_VERSION}/apache2/conf.d/opcache-recommended.ini

# Configuração Xdebug
RUN { \
    echo 'xdebug.remote_enable=1'; \
    echo 'xdebug.remote_autostart=1'; \
    echo 'xdebug.remote_port=9000'; \
    echo 'xdebug.remote_connect_back=1'; \
} > /etc/php/${PHP_VERSION}/apache2/conf.d/xdebug-conf.ini

RUN { \
    echo 'display_errors = on'; \
    echo '; Get the right number in https://maximivanov.github.io/php-error-reporting-calculator/'; \
    echo 'error_reporting = 22527'; \
    echo 'memory_limit = 4096M'; \
    echo 'post_max_size = 200M'; \
    echo 'upload_max_filesize = 200M'; \
    echo 'max_execution_time = 60'; \
    echo 'max_input_time = 120'; \
    echo 'date.timezone = "America/Sao_Paulo"'; \
} > /etc/php/${PHP_VERSION}/apache2/conf.d/extra-conf.ini

# Clean
RUN apt-get clean && apt-get autoclean && apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

COPY apache2-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-foreground

WORKDIR /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
