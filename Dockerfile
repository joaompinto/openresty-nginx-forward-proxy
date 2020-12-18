#@# vim: set filetype=dockerfile:
FROM alpine:3.12

ENV OPENRESTY_VERSION 1.19.3.1

####
## dependent packages for docker build
####

WORKDIR /tmp

RUN apk update && \
    apk add       \
      bash        \
      perl        \
      alpine-sdk  \
      openssl-dev \
      pcre-dev    \
      zlib-dev

RUN curl -LSs https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -O                                && \
    tar xf openresty-${OPENRESTY_VERSION}.tar.gz                                                                     && \
    cd     openresty-${OPENRESTY_VERSION}                                                                            && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module                                               && \
    ./configure                                                                                                         \
      --prefix=/opt/openresty                                                                                           \
      --add-module=./ngx_http_proxy_connect_module                                                                   && \
    patch -d build/nginx-1.19.3/ -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch        && \
    make -j $(nproc)                                                                                                 && \
    make install                                                                                                     && \
    rm -rf /tmp/*

####
## application deployment
####

WORKDIR /

COPY ./nginx.conf /opt/openresty/nginx/conf
COPY htpasswd /etc/htpasswd
COPY proxy_auth.lua /etc/proxy_auth.lua
EXPOSE 3128

STOPSIGNAL SIGTERM

CMD ["/opt/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
