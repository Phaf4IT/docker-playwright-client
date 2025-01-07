#!/bin/bash

if [ -n "$WS_PATH" ]; then
  echo "Instellen van wsPath naar $WS_PATH"
  jq ".wsPath = \"$WS_PATH\"" playwright.json > tmp.json && mv tmp.json playwright.json
else
  echo "Geen wsPath ingesteld, verwijderen uit de config"
  jq 'del(.wsPath)' playwright.json > tmp.json && mv tmp.json playwright.json
fi
cat playwright.json

npx playwright launch-server --browser chromium --config playwright.json
