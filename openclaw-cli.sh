#!/usr/bin/env bash
set -Eeuo pipefail
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

exec docker compose exec -it openclaw-gateway node dist/index.js "$@"
