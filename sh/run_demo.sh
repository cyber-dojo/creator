#!/bin/bash -Ee

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${SH_DIR}/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
manifest_slow()
{
  local -r port="${CYBER_DOJO_CUSTOM_START_POINTS_PORT}"
  local -r display_name='Java Countdown, Round 1'
  echo $(curl \
    --data "{\"name\":\"${display_name}\"}" \
    --fail \
    --header 'Content-type: application/json' \
    --silent \
    -X GET \
      "http://${IP_ADDRESS}:${port}/manifest")
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json()
{
  local -r port="${CYBER_DOJO_CREATOR_PORT}"
  local -r type="${1}"  # eg GET
  local -r route="${2}" # eg ready?
  local -r data="${3}"
  curl  \
    --data "${data}" \
    --fail \
    --header 'Content-type: application/json' \
    --silent \
    -X ${type} \
      "http://${IP_ADDRESS}:${port}/${route}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_api()
{
  local -r manifest=$(manifest_slow)
  printf 'API\n'
  printf "\t200 GET  /alive?       => $(curl_json GET alive?)\n"
  printf "\t200 GET  /ready?       => $(curl_json GET ready?)\n"
  printf "\t200 GET  /sha          => $(curl_json GET sha)\n"
  printf "\t200 POST /create_group => $(curl_json POST create_group "${manifest}")\n"
  printf "\t200 POST /create_kata  => $(curl_json POST create_kata  "${manifest}")\n"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
${SH_DIR}/build_images.sh
${SH_DIR}/containers_up.sh
printf '\n'
demo_api
printf '\n'
${SH_DIR}/containers_down.sh
