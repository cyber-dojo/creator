#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${0}")/.." && pwd)"
source "${ROOT_DIR}/sh/creator-docker-compose.sh"

creator_docker_compose \
  down \
  --remove-orphans \
  --volumes
