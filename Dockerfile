# renovate: datasource=github-tags packageName=openclaw/openclaw versioning=semver-coerced
ARG OPENCLAW_VERSION="2026.3.31"

FROM ghcr.io/openclaw/openclaw:$OPENCLAW_VERSION

# apt packages
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    procps \
    curl \
    git \
    jq \
    python3-pip python3-six python3-numpy python3-openpyxl python3-et-xmlfile python3-dateutil python3-pandas python3-scipy python3-seaborn \
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
# Note: feishu is already preinstalled
# RUN node dist/index.js plugins install @openclaw/feishu
