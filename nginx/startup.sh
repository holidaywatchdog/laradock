#!/bin/bash

if [ ! -f /etc/nginx/ssl/default.crt ]; then
    openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
    openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"
fi

if [ ! -f /etc/nginx/ssl/hwd.crt ]; then
    openssl req -x509 -out hwd.crt -keyout hwd.key \
      -newkey rsa:2048 -nodes -sha256 \
      -subj '/CN=www.holidaywatchdog.test' -extensions EXT -config <( \
       printf "[dn]\nCN=www.holidaywatchdog.test\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:www.holidaywatchdog.test\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
fi

nginx