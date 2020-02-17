#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${SH_DIR}/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { printf 80; }
old_controller() { printf setup_custom_start_point; }
new_controller() { printf creator; }
url_display_name() { echo -n 'display_name=Java%20Countdown%2C%20Round%201'; }
json_display_name() { echo -n '{"display_name":"Java Countdown, Round 1"}'; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_identity_returns_JSON_sha()
{
  printf 'API(new) identity returns JSON sha \n'
  curl_json_body GET "$(new_controller)/sha"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_probing_returns_JSON_boolean()
{
  printf 'API(new) probing returns JSON true|false \n'
  curl_json_body GET "$(new_controller)/alive"
  curl_json_body GET "$(new_controller)/ready"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_create_URL_Params_causes_redirect_302()
{
  local -r data=display_name=Java%20Countdown%2C%20Round%201
  printf "API(new) create(url.params) causes redirect (302)\n"
  curl_url_params_302 POST "$(new_controller)/create_custom_group" "$(url_display_name)"
  curl_url_params_302 POST "$(new_controller)/create_custom_kata"  "$(url_display_name)"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route_create_JSON_Body_returns_JSON_id()
{
  printf "API(new) create(json.body) returns id\n"
  curl_json_body POST "$(new_controller)/create_custom_group" "$(json_display_name)"
  curl_json_body POST "$(new_controller)/create_custom_kata"  "$(json_display_name)"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_old_route_create_URL_params_causes_redirect_302()
{
  printf 'API(deprecated) save(url.params) causes redirect (302)\n'
  curl_url_params_302 POST "$(old_controller)/save_group"      "$(url_display_name)"
  curl_url_params_302 POST "$(old_controller)/save_individual" "$(url_display_name)"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_old_route_create_JSON_Body_returns_id()
{
  printf 'API(deprecated) save(json.body) returns id\n'
  curl_json_body POST "$(old_controller)/save_group_json"      "$(json_display_name)"
  curl_json_body POST "$(old_controller)/save_individual_json" "$(json_display_name)"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg creator/ready?
  local -r json="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'
  printf "$(tab)${type} ${route} 200 => "
  curl  \
    --data "${json}" \
    --fail \
    --header "Accept: application/json" \
    --request ${type} \
    --silent \
      "http://${IP_ADDRESS}:$(port)/${route}"
  printf '\n'
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_url_params_302()
{
  local -r log=/tmp/creator.log
  local -r type=${1}     # eg GET|POST
  local -r route=${2}    # eg setup_custom_start_point/save_individual
  local -r params=${3:-} # eg display_name=Java%20Countdown%2C%20Round%201
  printf "$(tab)${type} ${route} 302 => "
  curl \
    --fail \
    --header 'Accept: text/html' \
    --request ${type} \
    --silent \
    --verbose \
    "http://${IP_ADDRESS}:$(port)/${route}?${params}" \
    > ${log} 2>&1

  grep --quiet 302 ${log}                   # eg HTTP/1.1 302 Moved Temporarily
  local -r location=$(grep Location ${log}) # eg Location: http://192.168.99.100/kata/group/mzCS1h
  printf "${location}\n"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
${SH_DIR}/build_images.sh
${SH_DIR}/containers_up.sh demo

demo_new_route_identity_returns_JSON_sha
demo_new_route_probing_returns_JSON_boolean
demo_new_route_create_URL_Params_causes_redirect_302
demo_new_route_create_JSON_Body_returns_JSON_id

demo_old_route_create_URL_params_causes_redirect_302
demo_old_route_create_JSON_Body_returns_id

${SH_DIR}/containers_down.sh
