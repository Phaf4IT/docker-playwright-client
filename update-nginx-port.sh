#!/bin/bash

if [ -z "$HOST_PORT" ]; then
  echo "No HOST_PORT found. Using default 3000."
  export HOST_PORT=3000
fi

echo "Setup Nginx to go to port $HOST_PORT"
sed "s/\$HOST_PORT/$HOST_PORT/g" /etc/nginx/nginx.conf.tpl > /tmp/nginx.conf && mv /tmp/nginx.conf /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf

echo "Restart Nginx..."
nginx -s reload
