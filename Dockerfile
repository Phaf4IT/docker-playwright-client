FROM node:18-bullseye

WORKDIR /ms-playwright

RUN apt-get update && apt-get install -y \
  jq \
  nginx \
  curl \
  locales

RUN npm init -y \
    && npm install playwright@latest \
    && npx playwright install --with-deps chromium

EXPOSE 9222
EXPOSE 80

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "nl_NL.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen nl_NL.UTF-8 en_US.UTF-8 de_DE.UTF-8

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chmod 644 /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf.tpl
COPY update-nginx-port.sh /usr/local/bin/update-nginx-port
RUN chmod +x /usr/local/bin/update-nginx-port

COPY playwright.json ./

CMD ["/entrypoint.sh"]