# Varnish based on https://github.com/mobulum/docker-varnish

# Use phusion/baseimage as base image
FROM phusion/baseimage:0.9.9
#18.04=0.11
#14.04=0.9.18
#12.04=0.9.9
MAINTAINER Robin Mofakham "robin@mofakham.co.uk"

ARG varnish_ver=2.1.5
RUN echo ${varnish_ver}

# standard repo update and clean
RUN apt-get update && apt-get clean

#########################################
# NEED TO INSTALLL FROM SOURCE - REPL NO LONGER EXISTS!!
#########################################
# http://varnish-cache.org/docs/trunk/installation/install_source.html
# http://varnish-cache.org/_downloads/varnish-2.1.5.tgz

# install useful tools and dependencies
RUN apt-get install \
    git wget nano \
    autotools-dev \
    make \
    automake \
    #automake1.9 \
    libtool \
    autoconf \
    libncurses-dev \
    xsltproc \
    groff-base \
    libpcre3-dev \
    pkg-config -y



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

ENV LISTEN_ADDR 0.0.0.0
ENV LISTEN_PORT 8080

ENV BACKEND_ENV_PORT 5000
ENV BACKEND_PORT_5000_TCP_ADDR 0.0.0.0

ENV TELNET_ADDR 0.0.0.0
ENV TELNET_PORT 6083
ENV CACHE_SIZE 25MB
ENV VCL_FILE /etc/varnish/default.vcl
ENV GRACE_TTL 30s
ENV GRACE_MAX 1h

ADD config/default.vcl.source /etc/varnish/default.vcl.source

RUN ldconfig
# Create a runit entry for your app
RUN mkdir /etc/service/varnish
ADD bin/reload.sh etc/service/varnish/reload
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