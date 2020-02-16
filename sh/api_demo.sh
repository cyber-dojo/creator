#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${SH_DIR}/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo()
{
  local -r display_name='Java Countdown, Round 1'
  printf 'API\n'
  printf "\t200 GET  /sha    => $(curl_json GET sha)\n"
  printf "\t200 GET  /alive? => $(curl_json GET alive?)\n"
  printf "\t200 GET  /ready? => $(curl_json GET ready?)\n"
  printf "\t200 POST /create_custom_group => $(curl_json POST create_custom_group "${display_name}")\n"
  printf "\t200 POST /create_custom_kata  => $(curl_json POST create_custom_kata  "${display_name}")\n"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json()
{
  # NB: currently sends display_name for all curls.
  # This will fail if creator checks its arguments completely
  # (eg as differ does using keyword-args and double-splat)
  local -r port="${CYBER_DOJO_CREATOR_PORT}"
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg ready?
  local -r data="${3:-}" # eg 'Java Countdown, Round 1'
  curl  \
    --data "{\"display_name\":\"${data}\"}" \
    --fail \
    --header 'Content-type: application/json' \
    --silent \
    -X ${type} \
      "http://${IP_ADDRESS}:${port}/${route}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
${SH_DIR}/build_images.sh
${SH_DIR}/containers_up.sh server
printf '\n'
api_demo
printf '\n'
#${SH_DIR}/containers_down.sh
