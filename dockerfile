FROM alpine:3.19

RUN apk update && apk add --no-cache \
    curl \
    wget \
    git \
    bash \
    zip \
    unzip \
    openssl \
    ca-certificates \
    libc6-compat \
    autoconf \
    gcc \
    g++ \
    make \
    libaio \
    libnsl \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache \
    php82 \
    php82-fpm \
    php82-cli \
    php82-json \
    php82-mbstring \
    php82-xml \
    php82-xmlwriter \
    php82-xmlreader \
    php82-pdo \
    php82-pdo_mysql \
    php82-pdo_pgsql \
    php82-tokenizer \
    php82-fileinfo \
    php82-curl \
    php82-zip \
    php82-bcmath \
    php82-ctype \
    php82-dom \
    php82-session \
    php82-openssl \
    php82-phar \
    php82-dev \
    php82-pear

RUN ln -sf /usr/bin/php82 /usr/bin/php

RUN mkdir -p /opt/oracle && \
    cd /tmp && \
    wget -O instantclient-basic.zip "https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-basic-linux.x64-21.3.0.0.0.zip" && \
    wget -O instantclient-sdk.zip "https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-sdk-linux.x64-21.3.0.0.0.zip" && \
    cd /opt/oracle && \
    unzip /tmp/instantclient-basic.zip && \
    unzip /tmp/instantclient-sdk.zip && \
    mv instantclient_21_3 instantclient && \
    rm /tmp/instantclient-*.zip && \
    cd /opt/oracle/instantclient && \
    ln -sf libclntsh.so.21.1 libclntsh.so && \
    ln -sf libocci.so.21.1 libocci.so

ENV ORACLE_HOME=/opt/oracle/instantclient
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient:/usr/lib
ENV PATH=$ORACLE_HOME:$PATH

RUN echo "instantclient,/opt/oracle/instantclient" | pecl install oci8-3.3.0 && \
    echo "extension=oci8.so" > /etc/php82/conf.d/20-oci8.ini

RUN php -m | grep oci8

RUN apk add --no-cache nodejs npm

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN npm install -g vercel

RUN composer global require laravel/installer

ENV PATH="/root/.composer/vendor/bin:$PATH"

WORKDIR /workspace

RUN adduser -D -s /bin/bash devuser && \
    chown -R devuser:devuser /workspace

USER devuser

SHELL ["/bin/bash", "-c"]

EXPOSE 3000 8000 8080 5173

CMD ["/bin/bash"]