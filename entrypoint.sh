#!/bin/bash

# Stel de gewenste taal in via omgevingsvariabele LANGUAGE
if [ -n "$LANGUAGE" ]; then
  echo "Instellen van de locale naar $LANGUAGE"
  case $LANGUAGE in
    "nl")
      export LANG=nl_NL.UTF-8
      export LC_ALL=nl_NL.UTF-8
      ;;
    "en")
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      ;;
    "de")
      export LANG=de_DE.UTF-8
      export LC_ALL=de_DE.UTF-8
      ;;
    *)
      echo "Onbekende taal, standaard nl_NL ingesteld."
      export LANG=nl_NL.UTF-8
      export LC_ALL=nl_NL.UTF-8
      ;;
  esac
else
  echo "Geen taal ingesteld, gebruik de standaard nl_NL"
  export LANG=nl_NL.UTF-8
  export LC_ALL=nl_NL.UTF-8
fi

# Zorg ervoor dat de locale goed wordt doorgegeven naar Playwright
export LANG
export LC_ALL

# Controleer of de juiste locale is ingesteld
echo "Locale is ingesteld op $LANG"

# Als er een wsPath is, pas de config aan
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
