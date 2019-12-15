#!/bin/bash
set -e

ip_address()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
readonly IP_ADDRESS=$(ip_address)
readonly PORT=4523
readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
export $(docker run --rm cyberdojo/versioner:latest sh -c 'cat /app/.env')
"${SH_DIR}/build_docker_images.sh"
"${SH_DIR}/docker_containers_up.sh"

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json()
{
  local -r TYPE=${1}
  local -r ROUTE=${2}
  # TODO: get real manifest from custom-start-points
  curl  \
    --data '{"manifest":{}}' \
    --fail \
    --header 'Accept: application/json' \
    --silent \
    -X ${TYPE} \
    "http://${IP_ADDRESS}:${PORT}/${ROUTE}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_api()
{
  printf "\n"
  printf "API\n"
  printf "\t200 GET  /alive? => $(curl_json GET alive?)\n"
  printf "\t200 GET  /ready? => $(curl_json GET ready?)\n"
  printf "\t200 GET  /sha    => $(curl_json GET sha)\n"
  printf "\t200 POST /create_group => $(curl_json POST create_group)\n"
  printf "\t200 POST /create_kata  => $(curl_json POST create_kata)\n"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
open_alive_in_browser()
{
  printf "\n"
  open "http://${IP_ADDRESS}:${PORT}/alive?"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_api
open_alive_in_browser
