FROM node:18-bullseye

WORKDIR /ms-playwright

RUN apt-get update && apt-get install -y \
  jq \
  nginx \
  curl

RUN npm init -y \
    && npm install playwright@latest \
    && npx playwright install --with-deps chromium

EXPOSE 9222
EXPOSE 80

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chmod 644 /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf

COPY playwright.json ./

CMD ["/entrypoint.sh"]