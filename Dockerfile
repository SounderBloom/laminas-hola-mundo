FROM php:8.3-apache

LABEL maintainer="getlaminas.org" \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.name="Laminas MVC Skeleton" \
    org.label-schema.url="https://docs.getlaminas.org/mvc/" \
    org.label-schema.vcs-url="https://github.com/laminas/laminas-mvc-skeleton"

# Actualizar paquetes
RUN apt-get update

# Habilitar mod_rewrite y configurar document root a /public
RUN a2enmod rewrite \
    && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
    && mv /var/www/html /var/www/public

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer

#
# PHP Extensions
#

# zip
RUN apt-get install --yes git zlib1g-dev libzip-dev \
    && docker-php-ext-install zip

# intl
RUN apt-get install --yes libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Directorio de trabajo
WORKDIR /var/www

# Copiar el proyecto al contenedor
COPY . /var/www

# Copiar entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Render usa el puerto 10000
EXPOSE 10000

ENTRYPOINT ["docker-entrypoint.sh"]
