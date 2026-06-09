#!/usr/bin/env bash
set -Eeu

# Brings up a full, working cyber-dojo demo: creator + web (and the services
# they route to) behind the REAL cyber-dojo nginx, so you can create a
# group/kata in creator and then edit it in web.
#
# The client/selenium tests instead use the cut-down nginx_stub (see
# docker-compose.yml) because the real nginx rate-limits /creator/.
#
# Usage: bin/demo.sh [--no-browser]

repo_root() { git rev-parse --show-toplevel; }
readonly BIN_DIR="$(repo_root)/bin"
source "${BIN_DIR}/copy_in_saver_test_data.sh"
source "${BIN_DIR}/curlers.sh"
source "${BIN_DIR}/echo_env_vars.sh"
source "${BIN_DIR}/lib.sh"

# Suppress "requested image's platform does not match host platform" warnings on Apple Silicon
export DOCKER_DEFAULT_PLATFORM=linux/amd64
# shellcheck disable=SC2046
export $(echo_env_vars)

export CYBER_DOJO_NGINX_HOST_PORT="${CYBER_DOJO_NGINX_HOST_PORT:-80}"

compose()
{
  docker --log-level=ERROR compose \
    --file "$(repo_root)/docker-compose.yml" \
    --file "$(repo_root)/docker-compose.demo.yml" \
    "$@"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
# A quick smoke-test of the creator server's endpoints/pages.
# These curl the creator server DIRECTLY on its published port (via
# curlers.sh -> http://localhost:${CYBER_DOJO_CREATOR_PORT}), NOT through
# nginx. That is deliberate and correct: the real nginx rate-limits
# /creator/ (zone=creator_choose, 60r/m burst 10), and this burst of GETs
# would trip a 429. Going straight to creator bypasses the rate-limit.
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

# - - - - - - - - - - - - - - - - - - - - - - -
exit_non_zero_unless_installed docker

# Tear down any previous demo (also frees host port 80 if a test left the stub up).
compose down --remove-orphans 2>/dev/null || true

# Build creator from local source (its Dockerfile compiles the assets).
compose build --build-arg COMMIT_SHA="$(git_commit_sha)" creator

# Bringing up the real nginx cascades (via depends_on) to web, creator,
# differ, dashboard and the services they need - ie the full demo stack.
# --wait blocks until the containers are healthy (creator etc. have a
# HEALTHCHECK) so the api_demo curls below don't race the booting servers.
compose up --detach --wait --wait-timeout 180 nginx

copy_in_saver_test_data
api_demo

if [ "${1:-}" = '--no-browser' ]; then
  compose down --remove-orphans
else
  open "http://localhost:${CYBER_DOJO_NGINX_HOST_PORT}"
fi
