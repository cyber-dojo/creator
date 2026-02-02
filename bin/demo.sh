#!/usr/bin/env bash
set -Eeu

repo_root() { git rev-parse --show-toplevel; }
BIN_DIR="$(repo_root)/bin"
source "${BIN_DIR}/build_tagged_images.sh"
source "${BIN_DIR}/containers_down.sh"
source "${BIN_DIR}/containers_up_healthy_and_clean.sh"
source "${BIN_DIR}/copy_in_saver_test_data.sh"
source "${BIN_DIR}/curlers.sh"
source "${BIN_DIR}/echo_env_vars.sh"
source "${BIN_DIR}/lib.sh"
source "${BIN_DIR}/remove_old_images.sh"

# shellcheck disable=SC2046
export $(echo_env_vars)

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
  echo
  curl_200 enter    'Content-Type: text/html'
  curl_200 avatar?id=5rTJv5   'Content-Type: text/html'
  curl_200 reenter?id=5U2J18  'Content-Type: text/html'
  curl_200 full?id=k5ZTk0     'Content-Type: text/html'
  echo
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
remove_old_images
build_tagged_images
server_up_healthy_and_clean
client_up_healthy_and_clean "$@"  # Brings up nginx
copy_in_saver_test_data
api_demo
if [ "${1:-}" = '--no-browser' ]; then
  containers_down
else
  open "http://localhost"
fi
