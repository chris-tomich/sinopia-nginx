FROM ubuntu:latest

MAINTAINER Chris Tomich "chris.tomich@oystr.co"

RUN apt-get update && apt-get install -y supervisor git build-essential wget nginx
RUN update-rc.d -f nginx remove
RUN rm -f /etc/nginx/nginx.conf

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx-default.conf /etc/nginx/nginx-default.conf
ADD default /etc/nginx/sites-available/default

VOLUME ["/etc/nginx/nginx.conf"]
VOLUME ["/etc/nginx/sites-available"]

WORKDIR /tmp
RUN wget https://nodejs.org/dist/v4.3.2/node-v4.3.2.tar.gz
RUN mkdir node
RUN tar xzf node-v4.3.2.tar.gz --strip-components=1 -C ./node

WORKDIR /tmp/node
RUN ./configure
RUN make
RUN make install

WORKDIR /var/lib
RUN npm install -g sinopia
RUN mkdir sinopia
RUN mkdir sinopia/storage

ADD config-default.yaml /var/lib/sinopia/config-default.yaml

VOLUME ["/var/lib/sinopia/htpasswd"]
VOLUME ["/var/lib/sinopia/config.yaml"]
VOLUME ["/var/lib/sinopia"]
VOLUME ["/var/lib/sinopia/storage"]

ADD start_supervisord.sh /start_supervisord.sh
RUN chmod 755 /start_supervisord.sh

CMD ["/start_supervisord.sh"]

EXPOSE 80 443
