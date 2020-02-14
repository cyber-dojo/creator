#!/bin/bash
set -e

ip_address()
{
  if [ -n "${DOCKER_MACHINE_NAME:-}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    printf localhost
  fi
}
