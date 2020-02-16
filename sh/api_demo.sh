#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${SH_DIR}/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
display_name() { printf 'Java Countdown, Round 1'; }
tab() { printf '\t'; }
port() { printf 80; }
new_controller() { printf custom; }
old_controller() { printf setup_custom_start_point; }
params_display_name() { echo -n 'display_name=Java%20Countdown%2C%20Round%201'; }
json_display_name() { echo -n '{"display_name":"Java Countdown, Round 1"}'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_identity_returns_JSON_sha()
{
  printf 'API(new) identity returns JSON sha \n'
  printf "$(tab)200 GET  $(new_controller)/sha => $(curly_json GET $(new_controller)/sha)\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_probing_returns_JSON_true_or_false()
{
  printf 'API(new) probing returns JSON true|false \n'
  printf "$(tab)200 GET $(new_controller)/alive? => $(curly_json GET $(new_controller)/alive?)\n"
  printf "$(tab)200 GET $(new_controller)/ready? => $(curly_json GET $(new_controller)/ready?)\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_create_HtmlParams_causes_redirect_302()
{
  local -r data=display_name=Java%20Countdown%2C%20Round%201
  printf "API(new) create(html.params) causes redirect (302)\n"
  printf "$(tab)302 POST HTTP $(new_controller)/create_custom_group => $(curly_params_302 POST $(new_controller)/create_custom_group "$(params_display_name)")\n"
  printf "$(tab)302 POST HTTP $(new_controller)/create_custom_kata  => $(curly_params_302 POST $(new_controller)/create_custom_kata  "$(params_display_name)")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_create_JsonBody_returns_JSON_id()
{
  printf "API(new) create(json.body) returns id\n"
  printf "$(tab)200 POST JSON $(new_controller)/create_custom_group => $(curly_json POST $(new_controller)/create_custom_group "$(json_display_name)")\n"
  printf "$(tab)200 POST JSON $(new_controller)/create_custom_kata  => $(curly_json POST $(new_controller)/create_custom_kata  "$(json_display_name)")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_deprecated_route_params_causes_redirect_302()
{
  printf 'API(deprecated) save(html.params) causes redirect (302)\n'
  printf "$(tab)302 POST $(old_controller)/save_group      => $(curly_params_302 POST $(old_controller)/save_group      "$(params_display_name)")\n"
  printf "$(tab)302 POST $(old_controller)/save_individual => $(curly_params_302 POST $(old_controller)/save_individual "$(params_display_name)")\n"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_deprecated_route_json_returns_id()
{
  printf 'API(deprecated) save(json.body) returns id\n'
  printf "$(tab)200 POST $(old_controller)/save_group_json      => $(curly_json POST $(old_controller)/save_group_json      "$(json_display_name)")\n"
  printf "$(tab)200 POST $(old_controller)/save_individual_json => $(curly_json POST $(old_controller)/save_individual_json "$(json_display_name)")\n"
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

${SH_DIR}/containers_down.sh
