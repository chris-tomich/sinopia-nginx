FROM ubuntu:latest

MAINTAINER Chris Tomich "chris.tomich@oystr.co"

RUN apt-get update
RUN apt-get install -y supervisor git build-essential wget nginx
RUN update-rc.d -f nginx remove

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD default /etc/nginx/sites-available/default
ADD default /etc/nginx/sites-enabled/default

VOLUME ["/etc/nginx"]

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

ADD config.yaml /var/lib/sinopia/config.yaml

VOLUME ["/var/lib/sinopia"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80 443
