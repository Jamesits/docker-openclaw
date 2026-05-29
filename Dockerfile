FROM ghcr.io/openclaw/openclaw:2026.5.27

# apt packages
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    procps \
    curl \
    git \
    jq \
    sudo \
    python3-pip python3-six python3-numpy python3-openpyxl python3-et-xmlfile python3-dateutil python3-pandas python3-scipy python3-seaborn \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=0:0 rootfs_overrides/. /
RUN chmod 0440 /etc/sudoers.d/*

# Homebrew
USER root
ENV HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1
# bypass check_run_command_as_root
RUN touch /.dockerenv \
    && CI=1 NONINTERACTIVE=1 bash -Eeuxc "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && rm /.dockerenv
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# reset env
USER node
WORKDIR /app

# plugins
# Note: feishu is already preinstalled
# RUN node dist/index.js plugins install @openclaw/feishu
