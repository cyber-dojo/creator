#!/bin/bash -Eeu

export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SH_DIR="${ROOT_DIR}/sh"
source "${SH_DIR}/versioner_env_vars.sh"
source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up.sh"
source "${SH_DIR}/ip_address.sh"
source "${SH_DIR}/image_name_sha_tag.sh"
export $(versioner_env_vars)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
html_demo()
{
  build_tagged_images
  containers_up api-demo
  api_demo
  if [ "${1:-}" == '--no-browser' ]; then
    containers_down
  else
    open "http://${IP_ADDRESS}:80/creator/choose_problem"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo()
{
  echo
  echo API
  curl_json_body_200 alive
  curl_json_body_200 ready
  curl_json_body_200 sha
  echo
  curl_200           assets/app.css 'Content-Type: text/css'
  echo
  curl_200           group_custom_choose exercise
  curl_200           kata_custom_choose exercise
  echo
  curl_params_302    group_custom_create "$(url_custom_param)"
  curl_params_302    kata_custom_create  "$(url_custom_param)"
  echo
  curl_200           group_exercise_choose our
  curl_200           kata_exercise_choose  my
  echo
  curl_200            group_language_choose our "$(url_exercise_param)"
  curl_200            kata_language_choose  my  "$(url_exercise_param)"
  echo
  curl_url_params_302 group_language_create "$(url_exercise_param)" "$(url_language_param)"
  curl_url_params_302 kata_language_create  "$(url_exercise_param)" "$(url_language_param)"
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r route="${1}"  # eg ready
  curl  \
    --data '' \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(log_filename)")
  echo "$(tab)GET ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r route="${1}"   # eg kata_choose
  local -r pattern="${2}" # eg exercise
  curl  \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(grep "${pattern}" "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_params_302()
{
  local -r route="${1}"  # eg kata_create
  local -r params="${2}" # eg "display_name=Java Countdown, Round 1"
  curl  \
    --data-urlencode "${params}" \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 302 "$(log_filename)" # eg HTTP/1.1 302 Moved Temporarily
  local -r result=$(grep Location "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 302 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_url_params_302()
{
  local -r route="${1}"          # eg group_create
  local -r exercise_param="${2}" # eg "exercise_name":"Fizz Buzz"
  local -r language_param="${3}" # eg "languages_names":["Java, JUnit"]
  curl  \
    --data-urlencode "${exercise_param}" \
    --data-urlencode "${language_param}" \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 302 "$(log_filename)" # eg HTTP/1.1 302 Moved Temporarily
  local -r result=$(grep Location "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 302 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_CREATOR_PORT}"; }

url_custom_param() { url_param display_name "$(custom_name)"; }
custom_name() { echo -n 'Java Countdown, Round 1'; }

url_exercise_param()  { url_param exercise_name "$(exercise_name)"; }
exercise_name() { echo -n 'Fizz Buzz'; }

url_language_param()  { url_param language_name "$(language_name)"; }
language_name() { echo -n 'Java, JUnit'; }

url_param() { echo -n "${1}=${2}"; }

tab() { printf '\t'; }
log_filename() { echo -n /tmp/creator.log; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
html_demo "$@"
