#!/bin/bash -Eeu

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${MY_DIR}/augmented_docker_compose.sh"

containers_down()
{
  augmented_docker_compose \
    down \
    --remove-orphans \
    --volumes
}
