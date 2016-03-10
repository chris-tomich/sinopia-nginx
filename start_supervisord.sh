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

# Check whether the default site config has been created yet. If it hasn't then build both it and the dhparam.pem.
# As this is building dhparam.pem the first time it is run, it will take quite a long time to start the first time.
if ! [ -f /etc/nginx/sites-available/default ]; then
    if ! [ -z "$CERT" ] && ! [ -z "$KEY" ]; then
        openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
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
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
