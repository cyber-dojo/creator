#!/usr/bin/env bash
set -Eeu

repo_root() { git rev-parse --show-toplevel; }

# SC2155 shellcheck says to not combine EXPORT and VAR assignment"
SH_DIR="$(repo_root)/sh"
export SH_DIR

source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up_healthy_and_clean.sh"
source "${SH_DIR}/echo_versioner_env_vars.sh"
source "${SH_DIR}/remove_old_images.sh"

# shellcheck disable=SC2046
export $(echo_versioner_env_vars)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
create_full_kata()
{
  curl_json_body_200 POST create.json \
    '{"exercise_name":"Fizz Buzz", "language_name":"Bash, bats", "type":"group"}'

  local -r json=$(tail -n 1 "$(log_filename)") # eg {"route":"/creator/enter?id=K4n72X","id":"K4n72X"}
  local -r gid=$(jq ".id" <<< "${json}")       # eg "K4n72X"
  echo "gid=${gid}"

  # TODO: enter 64 times
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg creator/ready
  local -r json="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'
  curl  \
    --fail \
    --data "${json}" \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request "${type}" \
    --silent \
    --verbose \
      "http://localhost:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)"             # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(log_filename)") # eg {"sha":"78c19640aa43ea214da17d0bcb16abed420d7642"}
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_CREATOR_PORT}"; }
log_filename() { echo -n /tmp/creator.log; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
#remove_old_images
#build_tagged_images
#server_up_healthy_and_clean
#client_up_healthy_and_clean "$@"
create_full_kata
