# openresty-nginx-forward-proxy

## What is this?

A 'nginx-foward-proxy' is a so simple HTTP proxy server using the nginx.
You can easily build a HTTP proxy server using this.

## Try this container

### Requirement packages

- Docker

### How to use

```
docker run --rm -ti xmartlabs/htpasswd username password > htpasswd
docker build -t nginx-forward-proxy .
docker run --name nginx --publish 3128:3128 -t nginx-forward-proxy
curl -x http://127.0.0.1:3128 https://www.google.pt --proxy-user username:password
```

## Links

- https://github.com/chobits/ngx_http_proxy_connect_module
