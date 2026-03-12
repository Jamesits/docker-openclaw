#!/usr/bin/env bash
set -Eeuo pipefail
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

docker compose down
docker compose up -d

# Reset the CDP URL, since the IP address of the Chromium container may have changed.
./openclaw-cli.sh config set browser.profiles.chrome.cdpUrl http://"$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$(docker compose ps -q chromium)" | head -n 1)":9222
docker compose restart openclaw-gateway
