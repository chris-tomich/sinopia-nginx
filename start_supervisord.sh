#!/bin/bash

# Check if the container has an nginx.conf file mapped, if not use the default.
if [ -f /etc/nginx/nginx.conf ]
then
    export NGINXCONF=/etc/nginx/nginx.conf
else
    export NGINXCONF=/etc/nginx/nginx-default.conf
fi

# Check if the container has a Sinopia config.yaml file mapped, if not use the default.
if [ -f /var/lib/sinopia/config.yaml ]
then
    export SINOPIACONF=/var/lib/sinopia/config.yaml
else
    export SINOPIACONF=/var/lib/sinopia/config-default.yaml
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
