FROM alpine:latest
COPY "httpd-foreground.sh" "/"
MAINTAINER samuelsantosdev@gmail.com
#install apache2 and php5.6 with essentials modules
RUN apk add --no-cache apache2 \
    php5-apcu \
    openssl \
    php5-openssl \
    php5-mcrypt \
    php5-mysqli \
    php5-xml \
    php5-enchant \
    php5-apache2 \
    php5-iconv \
    php5-pdo_mysql \
    php5-opcache \
    php5-soap \
    php5-json \
    php5-curl \
    php5-zlib \
    curl \

    #config apache2
    && sed -i 's/^#ServerName www\.example\.com\:80/ServerName 127\.0\.0\.1\:80/' /etc/apache2/httpd.conf \
    && mkdir -p /run/apache2 && chmod +x /httpd-foreground.sh && 
   
    #clear cache apk
    && rm -rf /var/cache/apk/* \

    #rewrite apache2 module
    && sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf \
    && { \
  	echo 'IncludeOptional conf.d/*.conf'; \
	} >> /etc/apache2/httpd.conf

COPY "httpd.conf" "/etc/apache2"
EXPOSE 80
CMD ["/httpd-foreground.sh", "-D", "FOREGROUND"]
