FROM node:lts@sha256:bb20cf73b3ad7212834ec48e2174cdcb5775f6550510a5336b842ae32741ce6c

LABEL "com.github.actions.name"="Puppeteer Headful"
LABEL "com.github.actions.description"="A GitHub Action / Docker image for Puppeteer, the Headful Chrome Node API"
LABEL "com.github.actions.icon"="layout"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/mujo-code/puppeteer-headful"
LABEL "homepage"="https://github.com/mujo-code/puppeteer-headful"
LABEL "maintainer"="Jacob Lowe"

# Chrome for Testing keeps --load-extension support (removed from branded stable in 137+).
# Bump when upgrading; check https://googlechromelabs.github.io/chrome-for-testing/
ARG CHROME_VERSION=149.0.7827.155

RUN apt-get update \
    && apt-get install -y wget unzip xvfb --no-install-recommends \
    && wget -q "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip" -O /tmp/chrome.zip \
    && unzip /tmp/chrome.zip -d /opt \
    && rm /tmp/chrome.zip \
    && apt-get update \
    && while read pkg; do apt-get satisfy -y --no-install-recommends "${pkg}"; done < /opt/chrome-linux64/deb.deps \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROME_FOR_TESTING_PATH=/opt/chrome-linux64/chrome

COPY README.md /

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Chrome refuses to load unpacked extensions when running as root.
USER node

ENTRYPOINT ["/entrypoint.sh"]
