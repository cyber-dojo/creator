#!/usr/bin/env bash
set -Eeu

repo_root() { git rev-parse --show-toplevel; }

# SC2155 shellcheck says to not combine EXPORT and VAR assignment"
SH_DIR="$(repo_root)/sh"
export SH_DIR

source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up_healthy_and_clean.sh"
source "${SH_DIR}/curlers.sh"
source "${SH_DIR}/echo_versioner_env_vars.sh"
source "${SH_DIR}/remove_old_images.sh"

# shellcheck disable=SC2046
export $(echo_versioner_env_vars)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
create_full_kata()
{
  curl_json_body_200 POST create.json \
    '{"exercise_name":"Fizz Buzz", "language_name":"Bash, bats", "type":"group"}'

  local -r json=$(tail -n 1 "$(curl_log_filename)") # eg {"route":"/creator/enter?id=K4n72X","id":"K4n72X"}
  local -r gid=$(jq ".id" <<< "${json}")       # eg "K4n72X"   Note: already quoted
  echo "gid=${gid}"

  for _ in {1..64}; do
    curl_json_body_200 POST enter.json "{\"id\":${gid}}"
  done
  echo "gid=${gid}"
  # TODO: tar pipe /cyber-dojo out of saver container
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
remove_old_images
build_tagged_images
server_up_healthy_and_clean
client_up_healthy_and_clean "$@"
create_full_kata
