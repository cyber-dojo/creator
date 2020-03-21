#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$(dirname "${0}")" && pwd )"
source "${SH_DIR}/ip_address.sh"
source "${SH_DIR}/versioner_env_vars.sh"
export $(versioner_env_vars)
readonly IP_ADDRESS="$(ip_address)" # slow

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
main()
{
  "${SH_DIR}/build_images.sh"
  "${SH_DIR}/containers_up.sh" api-demo
  echo; demo
  "${SH_DIR}/containers_down.sh"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo()
{
  demo_new_route__probing
  demo_new_route__probing_non_JSON
  demo_new_route__create
  demo_old_route__create
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route__probing()
{
  echo 'API:new probing'
  curl_json_body_200 GET "$(new_controller)/alive?"
  curl_json_body_200 GET "$(new_controller)/ready?"
  curl_json_body_200 GET "$(new_controller)/sha"
  echo
}

demo_new_route__probing_non_JSON()
{
  echo 'API:new probing (non JSON)'
  curl_200 GET "$(new_controller)/alive?"
  curl_200 GET "$(new_controller)/ready?"
  curl_200 GET "$(new_controller)/sha"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_new_route__create()
{
  echo 'API:new create...'
  curl_json_body_200 POST "$(new_controller)/group_create_custom" "$(json_display_names)"
  curl_json_body_200 POST "$(new_controller)/kata_create_custom"  "$(json_display_name)"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo_old_route__create()
{
  echo 'API:old save...'
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
curl_200()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg creator/ready
  curl  \
    --fail \
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
json_display_name() { json display_name "$(display_name)"; }
json_display_names() { echo -n "{\"display_names\":[\"$(display_name)\"]}"; }
json() { echo -n "{\"${1}\":\"${2}\"}"; }
display_name() { echo -n 'Java Countdown, Round 1'; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
main
