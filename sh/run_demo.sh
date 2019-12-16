#!/bin/bash
set -e

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
ip_address_slow()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}
readonly IP_ADDRESS=$(ip_address_slow)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
manifest_slow()
{
  local -r PORT=4526 # custom-start-points
  local -r DISPLAY_NAME='Java Countdown, Round 1'
  echo $(curl \
    --data "{\"name\":\"${DISPLAY_NAME}\"}" \
    --fail \
    --header 'Content-type: application/json' \
    --silent \
    -X GET \
      "http://${IP_ADDRESS}:${PORT}/manifest")
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
export $(docker run --rm cyberdojo/versioner:latest sh -c 'cat /app/.env')

build_and_bring_up()
{
  "${SH_DIR}/build_docker_images.sh"
  "${SH_DIR}/docker_containers_up.sh"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
bring_down()
{
  "${SH_DIR}/docker_containers_down.sh"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json()
{
  local -r PORT=4523
  local -r TYPE="${1}"
  local -r ROUTE="${2}"
  local -r DATA="${3}"
  curl  \
    --data "${DATA}" \
    --fail \
    --header 'Content-type: application/json' \
    --silent \
    -X ${TYPE} \
      "http://${IP_ADDRESS}:${PORT}/${ROUTE}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_api()
{
  local -r MANIFEST=$(manifest_slow)
  printf "API\n"
  printf "\t200 GET  /alive?       => $(curl_json GET alive?)\n"
  printf "\t200 GET  /ready?       => $(curl_json GET ready?)\n"
  printf "\t200 GET  /sha          => $(curl_json GET sha)\n"
  printf "\t200 POST /create_group => $(curl_json POST create_group "${MANIFEST}")\n"
  printf "\t200 POST /create_kata  => $(curl_json POST create_kata  "${MANIFEST}")\n"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
build_and_bring_up
printf "\n"
demo_api
printf "\n"
bring_down
