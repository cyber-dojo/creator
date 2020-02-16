#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${SH_DIR}/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
display_name() { printf 'Java Countdown, Round 1'; }
tab() { printf '\t'; }
port() { printf 80; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_api()
{
  local -r controller=custom
  local -r data='{"display_name":"Java Countdown, Round 1"}'
  printf 'API (JSON)\n'
  printf "$(tab)200 GET  ${controller}/sha    => $(curl_json GET ${controller}/sha)\n"
  printf "$(tab)200 GET  ${controller}/alive? => $(curl_json GET ${controller}/alive?)\n"
  printf "$(tab)200 GET  ${controller}/ready? => $(curl_json GET ${controller}/ready?)\n"
  printf '\n'
  printf "$(tab)200 POST ${controller}/create_custom_group => $(curl_json POST ${controller}/create_custom_group "${data}")\n"
  printf "$(tab)200 POST ${controller}/create_custom_kata  => $(curl_json POST ${controller}/create_custom_kata  "${data}")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_deprecated_api()
{
  local -r controller=setup_custom_start_point
  local -r data='{"display_name":"Java Countdown, Round 1"}'
  printf "Deprecated API (nginx redirect)\n"

  printf "$(tab)302 POST HTTP ${controller}/save_individual => $(curl_http_302 POST ${controller}/save_individual)\n"
  printf "$(tab)302 POST HTTP ${controller}/save_group      => $(curl_http_302 POST ${controller}/save_group)\n"
  printf '\n'
  printf "$(tab)200 POST JSON ${controller}/save_individual_json => $(curl_json POST ${controller}/save_individual_json "${data}")\n"
  printf "$(tab)200 POST JSON ${controller}/save_group_json      => $(curl_json POST ${controller}/save_group_json      "${data}")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json()
{
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg custom/ready?
  local -r data="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'
  curl  \
    --data "${data}" \
    --fail \
    --header 'Content-type: application/json' \
    --silent \
    -X ${type} \
      "http://${IP_ADDRESS}:$(port)/${route}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_http_302()
{
  local -r type=${1}  # eg GET|POST
  local -r route=${2} # eg setup_custom_start_point/save_individual
  local -r log=/tmp/creator.log
  curl \
    --fail \
    --header 'Accept: text/html' \
    --silent \
    -X ${type} \
    "http://${IP_ADDRESS}:$(port)/${route}?display_name=Java%20Countdown%2C%20Round%201"
    #> ${log} 2>&1

  #grep --quiet 302 ${log}                   # eg HTTP/1.1 302 Moved Temporarily
  #local -r location=$(grep Location ${log}) # eg Location: http://192.168.99.100/kata/edit/mzCS1h
  #printf "kata${location#*kata}"            # eg /kata/edit/mzCS1h
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
${SH_DIR}/build_images.sh
${SH_DIR}/containers_up.sh demo
demo_api
demo_deprecated_api
#${SH_DIR}/containers_down.sh
