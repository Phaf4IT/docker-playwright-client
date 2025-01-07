FROM node:18-bullseye

WORKDIR /ms-playwright

RUN apt-get update && apt-get install -y jq

COPY playwright.json ./

RUN npm init -y \
    && npm install playwright@latest \
    && npx playwright install --with-deps chromium

EXPOSE 9222

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]