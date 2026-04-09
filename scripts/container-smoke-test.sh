#!/usr/bin/env bash
set -Eeuo pipefail

image_ref="${1:?usage: scripts/container-smoke-test.sh <image-ref>}"
container_name="openclaw-ci-smoke-test"

cleanup() {
  docker rm -f "${container_name}" >/dev/null 2>&1 || true
}

trap cleanup EXIT

docker run --rm --entrypoint bash "${image_ref}" -c '
  set -Eeuo pipefail

  node --version
  python3 --version
  brew --version
  git --version
  jq --version

  python3 - <<'\''PY'\''
import dateutil
import et_xmlfile
import numpy
import openpyxl
import pandas
import scipy
import seaborn
import six

print("python-deps-ok")
PY

  node dist/index.js --help >/dev/null
'

docker run -d --name "${container_name}" -e HOME=/home/node "${image_ref}" \
  node dist/index.js gateway --allow-unconfigured >/dev/null

for _ in {1..30}; do
  if [[ "$(docker inspect -f '{{.State.Running}}' "${container_name}")" != "true" ]]; then
    docker logs "${container_name}"
    exit 1
  fi

  if docker logs "${container_name}" 2>&1 | grep -Fq "[gateway] ready"; then
    exit 0
  fi

  sleep 1
done

docker logs "${container_name}"
exit 1
