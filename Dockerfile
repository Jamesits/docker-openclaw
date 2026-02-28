FROM ghcr.io/openclaw/openclaw:2026.2.26

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    procps \
    curl \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

ENV HOMEBREW_NO_ANALYTICS=1
RUN NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/node/.bashrc \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/node/.profile \
    && chown -R node:node /home/linuxbrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright
RUN node /app/node_modules/playwright-core/cli.js install --with-deps chromium

RUN chown -R node:node /home/node
USER node
