FROM php:8.1-fpm-buster
LABEL maintainer="Ederson Ferreira <ederson.dev@gmail.com>"

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    zip \
    curl \
    nano \
    locales \
    libonig-dev \
    zlib1g-dev \
    libpng-dev \
    libcurl4-openssl-dev

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8

ENV LANG pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

RUN docker-php-ext-install bcmath mbstring gd curl opcache

RUN pecl install xdebug && docker-php-ext-enable xdebug

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
} >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# # Configuração Xdebug
RUN { \
    echo 'xdebug.client_host=host.docker.internal'; \
    echo 'xdebug.idekey=VSCODE'; \
    echo 'xdebug.mode=develop,debug'; \
} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN { \
    echo 'display_errors=on'; \
    echo '; Get the right number in https://maximivanov.github.io/php-error-reporting-calculator/'; \
    echo 'error_reporting=22527'; \
    echo 'memory_limit=4096M'; \
    echo 'post_max_size=200M'; \
    echo 'upload_max_filesize=200M'; \
    echo 'max_execution_time=60'; \
    echo 'max_input_time=120'; \
    echo 'date.timezone="America/Sao_Paulo"'; \
} > /usr/local/etc/php/conf.d/extra-conf.ini

# Clean
RUN apt-get clean && apt-get autoclean && apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

CMD ["php-fpm"]
