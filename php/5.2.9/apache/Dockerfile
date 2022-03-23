FROM ubuntu:20.04
LABEL maintainer="Ederson Ferreira <ederson.dev@gmail.com>"

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG LIB_OPENSSL=openssl-0.9.8b

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    autoconf \
    libtool \
    bison \
    re2c \
    libbz2-dev \
    libreadline-dev \
    libfreetype-dev \
    libxpm-dev \
    nano

COPY httpd-2.2.9.tar.gz /tmp
COPY zlib-1.2.11.tar.gz /tmp
COPY ${LIB_OPENSSL}.tar.gz /tmp
COPY php-5.2.9.tar.gz /tmp
COPY libpng-1.2.56.tar.gz /tmp
COPY libxml2-2.6.32.tar.gz /tmp
COPY curl-7.16.0.tar.gz /tmp
COPY postgresql-8.1.23.tar.gz /tmp
COPY libmcrypt-2.5.8.tar.gz /tmp

WORKDIR /tmp

RUN tar -xf zlib-1.2.11.tar.gz && cd zlib-1.2.11 && ./configure --prefix=/usr/local && make && make install && make clean
RUN tar -xf libxml2-2.6.32.tar.gz && cd libxml2-2.6.32 && ./configure && make && make install && make clean
RUN tar -xf libpng-1.2.56.tar.gz && cd libpng-1.2.56 && ./configure && make && make install && make clean

RUN tar -xf ${LIB_OPENSSL}.tar.gz && cd ${LIB_OPENSSL} && \
    ./config \
    -fPIC \
    no-gost \
    no-shared \
    no-zlib \
    no-asm \
    && make depend && make && make install_sw && make clean

RUN tar -xf curl-7.16.0.tar.gz && cd curl-7.16.0 && \
    ./configure \
    --with-ssl=/usr/local/ssl \
    && make && make install && make clean
    
RUN tar -xf postgresql-8.1.23.tar.gz && cd postgresql-8.1.23 && ./configure && make && make install && make clean
RUN tar -xf libmcrypt-2.5.8.tar.gz && cd libmcrypt-2.5.8 && ./configure && make && make install && make clean

RUN tar -xf httpd-2.2.9.tar.gz && cd httpd-2.2.9 && ./configure \
    --enable-rewrite \
    --enable-so \
    --enable-vhost-alias \
    && make && make install && make clean

RUN ln -s /usr/local/apache2/bin/apachectl /usr/bin/apachectl

RUN ln -s /usr/lib/x86_64-linux-gnu/libXpm.a /usr/lib/libXpm.a

RUN tar -xf php-5.2.9.tar.gz && cd php-5.2.9 && ./configure \
    --disable-all \
    --with-apxs2=/usr/local/apache2/bin/apxs \
    --with-gd \
    --with-openssl-dir=/usr/local/ssl \
    --with-openssl \
#    --with-ssl=/usr/local/ssl \
    --with-system-ciphers \
#    --with-libdir=/lib/x86_64-linux-gnu \
    --with-pgsql \
    --with-pdo-pgsql \
    --with-zlib \
    --with-curl \
    --with-curlwrappers \
    --with-ttf \
    --with-freetype-dir \
    --with-xpm-dir \
#    --with-ldap \
    --with-mime-magic \
    --with-xmlrpc \
#    --with-tidy \
    --with-mcrypt \
    --with-bz2 \
    --with-gettext \
    --with-pcre-regex \
    --enable-mbstring \
    --enable-soap \
    --enable-calendar \
    --enable-bcmath \
    --enable-exif \
    --enable-ftp \
    --enable-shmop \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
#    --enable-wddx \
    --enable-zip \
    --enable-dba \
    --enable-libxml \
    --enable-ctype \
    --enable-session \
    --enable-json \
    --enable-filter \
    --enable-xml \
    --enable-dom \
    --enable-simplexml \
    && make && find -type f -name '*.a' -delete && make install && make clean

# Copia o arquivo de conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

# Clean
RUN apt-get remove --purge -y \
    build-essential \
    autoconf \
    libtool \
    bison \
    re2c \
    libreadline-dev
RUN apt-get autoclean && apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /usr/local/apache2/htdocs

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
