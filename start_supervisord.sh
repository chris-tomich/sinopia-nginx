#!/bin/bash

# Check if the container has an nginx.conf file mapped, if not use the default.
if [ -f /etc/nginx/nginx.conf ]; then
    export NGINXCONF=/etc/nginx/nginx.conf
else
    export NGINXCONF=/etc/nginx/nginx-default.conf
fi

# Check if the container has a Sinopia config.yaml file mapped, if not use the default.
if [ -f /var/lib/sinopia/config.yaml ]; then
    export SINOPIACONF=/var/lib/sinopia/config.yaml
else
    export SINOPIACONF=/var/lib/sinopia/config-default.yaml
fi

if ! [ -z "$CERT" ] && ! [ -z "$KEY" ]; then
    CERTLOCATION="\/etc\/nginx\/ssl\/$CERT"
    KEYLOCATION="\/etc\/nginx\/ssl\/$KEY"
    sed -i "s/__NGINX_SSL_CERT__/$CERTLOCATION/g" /etc/nginx/sites-available/default-ssl
    sed -i "s/__NGINX_SSL_CERT_KEY__/$KEYLOCATION/g" /etc/nginx/sites-available/default-ssl
    mv /etc/nginx/sites-available/default-ssl /etc/nginx/sites-available/default
    rm /etc/nginx/sites-available/default-non-ssl
else
    mv /etc/nginx/sites-available/default-non-ssl /etc/nginx/sites-available/default
    rm /etc/nginx/sites-available/default-ssl
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
