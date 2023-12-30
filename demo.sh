#!/usr/bin/env bash
set -Eeu

repo_root() { git rev-parse --show-toplevel; }

# SC2155 shellcheck says to not combine EXPORT and VAR assignment"
SH_DIR="$(repo_root)/sh"
export SH_DIR

source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up_healthy_and_clean.sh"
source "${SH_DIR}/copy_in_saver_test_data.sh"
source "${SH_DIR}/echo_versioner_env_vars.sh"
source "${SH_DIR}/remove_old_images.sh"

# shellcheck disable=SC2046
export $(echo_versioner_env_vars)

readonly IP_ADDRESS=localhost

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo()
{
  echo
  curl_json_body_200 GET alive
  curl_json_body_200 GET ready
  curl_json_body_200 GET sha
  echo
  curl_200 assets/app.css 'Content-Type: text/css'
  curl_200 assets/app.js  'Content-Type: application/javascript'
  echo
  curl_200 home   'Content-Type: text/html'

  curl_200 choose_problem 'Content-Type: text/html'
  curl_200 choose_custom_problem 'Content-Type: text/html'
  curl_200 choose_ltf?exercise_name=Fizz%20Buzz 'Content-Type: text/html'
  curl_200 choose_type?exercise_name=Fizz%20Buzz\&language_name=Bash%2C%20bats 'Content-Type: text/html'

  # curl_json_body_200 POST enter.json {"exercise_name":"Fizz Buzz", "language_name":"Bash, bats", "type":"group"}
  # curl_json_body_200 POST enter.json {"exercise_name":"Fizz Buzz", "language_name":"Bash, bats", "type":"kata"}
  curl_200 enter    'Content-Type: text/html'
  #curl_200 avatar?id=ID   'Content-Type: text/html'
  #curl_200 reenter?id=ID  'Content-Type: text/html'
  #curl_200 full?id=ID     'Content-Type: text/html'
  curl_200 full     'Content-Type: text/html'
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
  echo "$(tab)GET ${route} => 200 ...|${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_CREATOR_PORT}"; }
log_filename() { echo -n /tmp/creator.log; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
remove_old_images
build_tagged_images
server_up_healthy_and_clean
client_up_healthy_and_clean "$@"
copy_in_saver_test_data
api_demo
if [ "${1:-}" = '--no-browser' ]; then
  containers_down
else
  open "http://${IP_ADDRESS}"
fi
