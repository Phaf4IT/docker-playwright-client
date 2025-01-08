#!/bin/bash

if [ -n "$WS_PATH" ]; then
  echo "Instellen van wsPath naar $WS_PATH"
  jq ".wsPath = \"$WS_PATH\"" playwright.json > tmp.json && mv tmp.json playwright.json
else
  echo "Geen wsPath ingesteld, verwijderen uit de config"
  jq 'del(.wsPath)' playwright.json > tmp.json && mv tmp.json playwright.json
fi
cat playwright.json

if [ -z "$HOST_PORT" ]; then
  export HOST_PORT=3000
fi

sed "s/\$HOST_PORT/$HOST_PORT/g" /etc/nginx/nginx.conf > /tmp/nginx.conf && mv /tmp/nginx.conf /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf

echo "Start Nginx"
nginx -g "daemon off;"&

npx playwright launch-server --browser chromium --config playwright.json
