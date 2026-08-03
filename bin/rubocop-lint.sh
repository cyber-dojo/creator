#!/usr/bin/env bash
set -Eeu

# Runs rubocop and writes its results as junit xml, so CI attests structured
# results rather than a log plus a compliant flag computed in bash.

export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rm -rf "${ROOT_DIR}/reports/rubocop" &> /dev/null || true
mkdir -p "${ROOT_DIR}/reports/rubocop"

DOCKER_CLI_HINTS=false docker run \
  --rm \
  --volume "${ROOT_DIR}/reports/rubocop/:/reports/" \
  --volume "${ROOT_DIR}:/app" \
  cyberdojo/rubocop \
  --raise-cop-error \
  --format=progress \
  --format=junit \
  --out=/reports/junit.xml
