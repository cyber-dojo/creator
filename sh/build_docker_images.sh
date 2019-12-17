#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

export SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

build_image()
{
  printf "\n"
  docker-compose \
    --file "${ROOT_DIR}/docker-compose.yml" \
    build \
    "${1}"
}

build_image creator-server
