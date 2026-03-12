# OpenClaw Container Auto Builder

![Works - On My Machine](https://img.shields.io/badge/Works-On_My_Machine-2ea44f)
![Project Status - Feature Complete](https://img.shields.io/badge/Project_Status-Feature_Complete-2ea44f)
[![Docker Image Version](https://img.shields.io/docker/v/jamesits/openclaw?label=Docker%20Hub&sort=semver)](http://hub.docker.com/r/jamesits/openclaw)

Differences to the official image:
- Preinstalled some programs as instructed by [the doc](https://docs.openclaw.ai/install/docker#power-user-%2F-full-featured-container-opt-in)
- No need to run extra container for the command line
- External headless Chromium

# Usage

## First Time Setup

Copy `.env.example` to `.env` and fill

```shell
# create deployment directories
docker compose up -d
# If running with root
sudo chown -R 1000:1000 ./deployment/home
# If running with rootless Docker - substitite the UID/GID with your subuid/subgid mapping. E.g. using `user:100000:65536`
sudo chown -R 100999:100999 ./deployment/home
# Restart the container so that it stops the crash loop and we are able to configure it
docker compose restart

# enable control UI
./openclaw-cli.sh setup
./openclaw-cli.sh config set env.shellEnv.enabled true
./openclaw-cli.sh config set gateway.bind lan
./openclaw-cli.sh config set gateway.controlUi.allowedOrigins[0] http://localhost:18789
docker compose restart

# Visit http://localhost:18789
# Go to Control -> Overview, fill in Gateway Token, click Connect until it asks for pairing

# Pairing
./openclaw-cli.sh devices list
./openclaw-cli.sh devices approve <request_uuid>
```

## Setup models

```shell
./openclaw-cli.sh config set agents.defaults.model.primary openrouter/anthropic/claude-opus-4.6
```

## Setup Browser

Commands are provided as-is. You cannot set this by the command line configure tool because of an idiotic and useless check. Just edit the JSON config yourself.

```shell
./openclaw-cli.sh config set browser.enabled true
./openclaw-cli.sh config set browser.defaultProfile chrome
./openclaw-cli.sh config set browser.profiles.chrome "#00AA00"
./openclaw-cli.sh config set browser.profiles.chrome.cdpUrl http://"$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$(docker compose ps -q chromium)" | head -n 1)":9222
```

Validation:
```shell
./openclaw-cli.sh browser status
```
Expect `running: true`.

## Maintenance

OpenClaw shell / command line tool:
```shell
./openclaw-cli.sh <command> [args...]
```

View logs:
```shell
docker compose logs -f
```

Edit the config file:
```shell
sudo vim deployment/home/.openclaw/openclaw.json
```

Restarting:
```shell
docker compose restart
```

# Notes

OpenClaw's code quality is very low and most of its features are untested. If it breaks one day, keep calm and enjoy our brave new world.

OpenClaw (including its codebase, plugins and what it allows an agent to do) is insecure. Docker is not a proper security defense against it. This container is only provided for the ease of deployment and does not imply any security enhancement.
