#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${0}")/.." && pwd)"
source "${ROOT_DIR}/sh/augmented-docker-compose.sh"
source "${ROOT_DIR}/sh/ip_address.sh"
readonly IP_ADDRESS=$(ip_address) # slow
export NO_PROMETHEUS=true

# - - - - - - - - - - - - - - - - - - - - - -
wait_briefly_until_ready()
{
  local -r port="${1}"
  local -r container_name="${2}"
  local -r max_tries=20
  printf "Waiting until ${container_name} is ready"
  for _ in $(seq ${max_tries}); do
    if curl_ready ${port}; then
      printf '.OK\n'
      return
    else
      printf .
      sleep 0.1
    fi
  done
  printf 'FAIL\n'
  echo "not ready after ${max_tries} tries"
  if [ -f "$(ready_filename)" ]; then
    ready_response
  fi
  docker logs ${container_name}
  exit 42
}

# - - - - - - - - - - - - - - - - - - -
curl_ready()
{
  local -r port="${1}"
  local -r path=ready?
  local -r url="http://${IP_ADDRESS}:${port}/${path}"
  rm -f "$(ready_filename)"
  curl \
    --fail \
    --output $(ready_filename) \
    --request GET \
    --silent \
    "${url}"
  [ "$?" == '0' ] && [ "$(ready_response)" == '{"ready?":true}' ]
}

# - - - - - - - - - - - - - - - - - - -
ready_response()
{
  cat "$(ready_filename)"
}

# - - - - - - - - - - - - - - - - - - -
ready_filename()
{
  printf /tmp/curl-creator-ready-output
}

# - - - - - - - - - - - - - - - - - - -
strip_known_warning()
{
  local -r log="${1}"
  local -r pattern="${2}"
  local -r warning=$(printf "${log}" | grep --extended-regexp "${pattern}")
  local -r stripped=$(printf "${log}" | grep --invert-match --extended-regexp "${pattern}")
  if [ "${log}" != "${stripped}" ]; then
    >&2 echo "SERVICE START-UP WARNING: ${warning}"
  fi
  echo "${stripped}"
}

# - - - - - - - - - - - - - - - - - - -
exit_if_unclean()
{
  local -r container_name="${1}"
  local log=$(docker logs "${container_name}" 2>&1)

  #Thin warnings...
  #local -r shadow_warning="server.rb:(.*): warning: shadowing outer local variable - filename"
  #log=$(strip_known_warning "${log}" "${shadow_warning}")
  #local -r mismatched_indent_warning="application(.*): warning: mismatched indentations at 'rescue' with 'begin'"
  #log=$(strip_known_warning "${log}" "${mismatched_indent_warning}")

  local -r line_count=$(echo -n "${log}" | grep --count '^')
  printf "Checking ${container_name} started cleanly..."
  # 3 lines on Thin (Unicorn=6, Puma=6)
  #Thin web server (v1.7.2 codename Bachmanity)
  #Maximum connections set to 1024
  #Listening on 0.0.0.0:4536, CTRL+C to stop
  if [ "${line_count}" == '6' ]; then
    echo OK
  else
    echo FAIL
    echo_docker_log "${container_name}" "${log}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  local -r container_name="${1}"
  local -r log="${2}"
  echo "[docker logs ${container_name}]"
  echo '<docker_log>'
  echo "${log}"
  echo '</docker_log>'
}

# - - - - - - - - - - - - - - - - - - -
container_up_ready_and_clean()
{
  local -r port="${1}"
  local -r service_name="${2}"
  local -r container_name="test-${service_name}"
  container_up "${service_name}"
  wait_briefly_until_ready "${port}" "${container_name}"
  exit_if_unclean "${container_name}"
}

# - - - - - - - - - - - - - - - - - - -
container_up()
{
  local -r service_name="${1}"
  printf '\n'
  augmented_docker_compose \
    up \
    --detach \
    --force-recreate \
    "${service_name}"
}

# - - - - - - - - - - - - - - - - - - -

if [ "${1:-}" == 'api-demo' ]; then
  container_up nginx
  wait_briefly_until_ready ${CYBER_DOJO_CREATOR_PORT} creator-server
  exit 0
fi

if [ "${1:-}" == 'server' ]; then
  container_up_ready_and_clean ${CYBER_DOJO_CREATOR_PORT}        creator-server
else
  container_up_ready_and_clean ${CYBER_DOJO_CREATOR_CLIENT_PORT} creator-client
fi
