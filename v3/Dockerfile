# Varnish based on https://github.com/mobulum/docker-varnish

# Use phusion/baseimage as base image
FROM phusion/baseimage:latest
MAINTAINER Robin Mofakham "robin@mofakham.co.uk"

ARG varnish_ver=3.0.7
RUN echo ${varnish_ver}

# standard repo update and clean
RUN apt-get update && apt-get clean

#########################################
# NEED TO INSTALLL FROM SOURCE - REPL NO LONGER EXISTS!!
#########################################
# http://varnish-cache.org/docs/trunk/installation/install_source.html
# https://varnish-cache.org/releases/rel2.1.5.html

# install useful tools and dependencies
RUN apt-get install \
    git wget nano \
    make \
    automake \
    autotools-dev \
    libedit-dev \
    libjemalloc-dev \
    libncurses-dev \
    libpcre3-dev \
    libtool \
    pkg-config \
    python3-docutils \
    python3-sphinx -y

# Build legacy versions from source as is required since varnish deprecated repo.varnish-cache.org
RUN wget http://varnish-cache.org/_downloads/varnish-${varnish_ver}.tgz
RUN mkdir -p /opt/varnish && tar -xzf varnish-${varnish_ver}.tgz -C /opt/varnish --strip-components=1
WORKDIR /opt/varnish
RUN sh autogen.sh
RUN sh configure
RUN make
RUN make install
WORKDIR /

# Varnish will now be installed in /usr/local.
# The varnishd binary is in /usr/local/sbin/varnishd.
# To make sure that the necessary links and caches of the most recent shared libraries are found, run sudo ldconfig.

# install varnish libvmod-throttle
RUN git clone https://github.com/nand2/libvmod-throttle.git /opt/libvmod-throttle
RUN cd /opt/libvmod-throttle && ./autogen.sh
RUN cd /opt/libvmod-throttle && ./configure VARNISHSRC=/opt/varnish
RUN cd /opt/libvmod-throttle && make -j3
RUN cd /opt/libvmod-throttle && make install

ENV LISTEN_ADDR 0.0.0.0
ENV LISTEN_PORT 8080

ENV BACKEND_ENV_PORT 5000
ENV BACKEND_PORT_5000_TCP_ADDR 0.0.0.0

ENV TELNET_ADDR 0.0.0.0
ENV TELNET_PORT 6083
ENV CACHE_SIZE 25MB
ENV THROTTLE_LIMIT 150req/30s
ENV VCL_FILE /etc/varnish/default.vcl
ENV GRACE_TTL 30s
ENV GRACE_MAX 1h

ADD config/default.vcl.source /etc/varnish/default.vcl.source
RUN ldconfig

# Create a runit entry for your app
RUN mkdir /etc/service/varnish
ADD bin/reload.sh /etc/service/varnish/reload
ADD bin/run.sh /etc/service/varnish/run
RUN chown root /etc/service/varnish/reload
RUN chown root /etc/service/varnish/run
RUN chmod +x /etc/service/varnish/reload
RUN chmod +x /etc/service/varnish/run
RUN chmod 777 /etc/container_environment

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8080
EXPOSE 6083

CMD ["/sbin/my_init"]