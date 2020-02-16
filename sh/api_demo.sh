#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${SH_DIR}/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
display_name() { printf 'Java Countdown, Round 1'; }
tab() { printf '\t'; }
port() { printf 80; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_identity_returns_JSON_sha()
{
  local -r controller=custom
  printf 'API(new) identity returns JSON sha \n'
  printf "$(tab)200 GET  ${controller}/sha    => $(curly_json GET ${controller}/sha)\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_probing_returns_JSON_true_or_false()
{
  local -r controller=custom
  printf 'API(new) probing returns JSON true|false \n'
  printf "$(tab)200 GET ${controller}/alive? => $(curly_json GET ${controller}/alive?)\n"
  printf "$(tab)200 GET ${controller}/ready? => $(curly_json GET ${controller}/ready?)\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_create_HtmlParams_causes_redirect_302()
{
  local -r controller=custom
  local -r data=display_name=Java%20Countdown%2C%20Round%201
  printf "API(new) create(html.params) causes redirect (302)\n"
  printf "$(tab)302 POST HTTP ${controller}/create_custom_group => $(curly_params_302 POST ${controller}/create_custom_group "${data}")\n"
  printf "$(tab)302 POST HTTP ${controller}/create_custom_kata  => $(curly_params_302 POST ${controller}/create_custom_kata  "${data}")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_create_JsonBody_returns_JSON_id()
{
  local -r controller=custom
  local -r data='{"display_name":"Java Countdown, Round 1"}'
  printf "API(new) create(json.body) returns id\n"
  printf "$(tab)200 POST JSON ${controller}/create_custom_group => $(curly_json POST ${controller}/create_custom_group "${data}")\n"
  printf "$(tab)200 POST JSON ${controller}/create_custom_kata  => $(curly_json POST ${controller}/create_custom_kata  "${data}")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_deprecated_route_params_causes_redirect_302()
{
  local -r controller=setup_custom_start_point
  local -r data=display_name=Java%20Countdown%2C%20Round%201
  printf 'API(deprecated) save(html.params) causes redirect (302)\n'
  printf "$(tab)302 POST ${controller}/save_group      => $(curly_params_302 POST ${controller}/save_group      "${data}")\n"
  printf "$(tab)302 POST ${controller}/save_individual => $(curly_params_302 POST ${controller}/save_individual "${data}")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_deprecated_route_json_returns_id()
{
  local -r controller=setup_custom_start_point
  local -r data='{"display_name":"Java Countdown, Round 1"}'
  printf 'API(deprecated) save(json.body) returns id\n'
  printf "$(tab)200 POST ${controller}/save_group_json      => $(curly_json POST ${controller}/save_group_json      "${data}")\n"
  printf "$(tab)200 POST ${controller}/save_individual_json => $(curly_json POST ${controller}/save_individual_json "${data}")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curly_json()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg custom/ready?
  local -r data="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'
  curl  \
    --data "${data}" \
    --fail \
    --header "Accept: application/json" \
    --request ${type} \
    --silent \
      "http://${IP_ADDRESS}:$(port)/${route}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curly_params_302()
{
  local -r log=/tmp/creator.log
  local -r type=${1}   # eg GET|POST
  local -r route=${2}  # eg setup_custom_start_point/save_individual
  local -r data=${3:-} # eg display_name=Java%20Countdown%2C%20Round%201
  curl \
    --fail \
    --header 'Accept: text/html' \
    --request ${type} \
    --silent \
    --verbose \
    "http://${IP_ADDRESS}:$(port)/${route}?${data}" \
    > ${log} 2>&1

  grep --quiet 302 ${log}                   # eg HTTP/1.1 302 Moved Temporarily
  local -r location=$(grep Location ${log}) # eg Location: http://192.168.99.100/kata/group/mzCS1h
  printf "${location}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
${SH_DIR}/build_images.sh
${SH_DIR}/containers_up.sh demo

demo_new_route_identity_returns_JSON_sha
demo_new_route_probing_returns_JSON_true_or_false
demo_new_route_create_HtmlParams_causes_redirect_302
demo_new_route_create_JsonBody_returns_JSON_id

demo_deprecated_route_params_causes_redirect_302
demo_deprecated_route_json_returns_id

#${SH_DIR}/containers_down.sh
