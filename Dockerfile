#
# Generic Docker image to host a PHP application.
#
# This is mostly a plain PHP application, with Mod CAS added to support
# The Dartmouth WebAuth system.
#
# Update apache/app.conf to customize the CAS settings for your application
#
# Environment variables passed into the docker RUN command that begin with
# PHP_ will be copied into the apache configuration file and set as
# environment vars for the PHP environment.  The PHP_ prefix is stripped, so 
# for example if you pass in an environment variable PHP_DB_PASSWORD, that
# will end up as a "SetEnv DB_PASSWORD xyz" and will be available within PHP
# as $_SERVER['DB_PASSWORD']
#

FROM php:7.2-apache

# Add mod_cas
RUN apt-get update && apt-get install -y \
  libapache2-mod-auth-cas

# Copy over the apache conf files
COPY apache/ /etc/apache2/conf-enabled/

# Copy over PHP settings
COPY php/php.ini /usr/local/etc/php/

# Copy over bin scripts
COPY bin/ /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/propagate_environment.pl

# Copy over your application
COPY webapp/ /var/www/html/

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

# make CustomLog (access log) go to stdout instead of files
# and ErrorLog to stderr
RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
        s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
        s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
' '{}' ';'

RUN a2enmod auth_cas

# Run our custom startup script
CMD ["startup.sh"]

