FROM ghcr.io/openclaw/openclaw:2026.3.1

# apt packages
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    procps \
    curl \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Homebrew
USER node
WORKDIR /home/linuxbrew
ENV HOMEBREW_NO_ANALYTICS=1
RUN NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# fix permissions
USER root
RUN chown -R node:node /home/node /home/linuxbrew

# reset env
USER node
WORKDIR /app

# plugins
RUN node dist/index.js plugins install @openclaw/feishu
