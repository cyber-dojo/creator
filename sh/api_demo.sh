#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$(dirname "${0}")" && pwd )"
source "${SH_DIR}/versioner_env_vars.sh" # for build-image
export $(versioner_env_vars)
source "${SH_DIR}/ip_address.sh" # slow
readonly IP_ADDRESS="$(ip_address)"

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
main()
{
  "${SH_DIR}/build_images.sh"
  "${SH_DIR}/containers_up.sh" demo
  echo; demo
  "${SH_DIR}/containers_down.sh"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo()
{
  demo_new_route__identity_returns_JSON_sha
  demo_new_route__probing_returns_JSON_boolean
  demo_new_route__create_JSON_Body_returns_JSON_id
  demo_old_route__create_JSON_Body_returns_id
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route__identity_returns_JSON_sha()
{
  echo 'API(new) identity returns JSON sha'
  curl_json_body_200 GET "$(new_controller)/sha"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route__probing_returns_JSON_boolean()
{
  echo 'API(new) probing returns JSON true|false'
  curl_json_body_200 GET "$(new_controller)/alive?"
  curl_json_body_200 GET "$(new_controller)/ready?"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route__create_JSON_Body_returns_JSON_id()
{
  echo 'API(new) create... returns JSON id'
  curl_json_body_200 POST "$(new_controller)/create_custom_group" "$(json_display_name)"
  curl_json_body_200 POST "$(new_controller)/create_custom_kata"  "$(json_display_name)"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_old_route__create_JSON_Body_returns_id()
{
  echo 'API(old) save... returns JSON id'
  curl_json_body_200 POST "$(old_controller)/save_group_json"      "$(json_display_name)"
  curl_json_body_200 POST "$(old_controller)/save_individual_json" "$(json_display_name)"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg creator/ready
  local -r json="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'
  curl  \
    --data "${json}" \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "${log}" 2>&1

  grep --quiet 200 "${log}"             # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "${log}") # eg {"sha":"78c19640aa43ea214da17d0bcb16abbd420d7642"}
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { printf 80; }
new_controller() { echo -n creator; }
old_controller() { echo -n setup_custom_start_point; }
json_display_name() { echo -n '{"display_name":"Java Countdown, Round 1"}'; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
main
