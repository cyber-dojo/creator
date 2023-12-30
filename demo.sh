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
source "${SH_DIR}/curlers.sh"
source "${SH_DIR}/echo_versioner_env_vars.sh"
source "${SH_DIR}/remove_old_images.sh"

# shellcheck disable=SC2046
export $(echo_versioner_env_vars)

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

  curl_200 enter    'Content-Type: text/html'
  #TODO: get IDs from copied-in-saver-data
  #curl_200 avatar?id=ID   'Content-Type: text/html'
  #curl_200 reenter?id=ID  'Content-Type: text/html'
  #curl_200 full?id=ID     'Content-Type: text/html'
  curl_200 full     'Content-Type: text/html'
  echo
}

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
  open "http://localhost"
fi
