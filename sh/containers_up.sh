#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
source ${ROOT_DIR}/sh/ip_address.sh
readonly IP_ADDRESS=$(ip_address)

# - - - - - - - - - - - - - - - - - - - - - -
wait_briefly_until_ready()
{
  local -r port="${1}"
  local -r name="${2}"
  local -r max_tries=10
  printf "Waiting until ${name} is ready"
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
  docker logs ${name}
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
    --silent \
    -X GET \
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
  printf /tmp/curl-custom-ready-output
}

# - - - - - - - - - - - - - - - - - - -
exit_unless_clean()
{
  local -r name="${1}"
  local -r docker_log=$(docker logs "${name}" 2>&1)
  local -r line_count=$(echo -n "${docker_log}" | grep --count '^')
  printf "Checking ${name} started cleanly..."
  # 3 lines on Thin (Unicorn=6, Puma=6)
  #Thin web server (v1.7.2 codename Bachmanity)
  #Maximum connections set to 1024
  #Listening on 0.0.0.0:4536, CTRL+C to stop
  if [ "${line_count}" == '3' ]; then
    printf 'OK\n'
  else
    printf 'FAIL\n'
    echo_docker_log "${name}" "${docker_log}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  local -r name="${1}"
  local -r docker_log="${2}"
  echo "[docker logs ${name}]"
  echo '<docker_log>'
  echo "${docker_log}"
  echo '</docker_log>'
}

# - - - - - - - - - - - - - - - - - - -
container_up_ready_and_clean()
{
  local -r port="${1}"
  local -r service_name="${2}"
  local -r container_name="test-${service_name}"
  container_up "${port}" "${service_name}"
  wait_briefly_until_ready "${port}" "${container_name}"
  exit_unless_clean "${container_name}"
}

# - - - - - - - - - - - - - - - - - - -
container_up()
{
  local -r port="${1}"
  local -r service_name="${2}"
  local -r container_name="test-${service_name}"
  printf '\n'
  docker-compose \
    --file "${ROOT_DIR}/docker-compose.yml" \
    up \
    --detach \
    --force-recreate \
      "${service_name}"
}

# - - - - - - - - - - - - - - - - - - -
export NO_PROMETHEUS=true
container_up_ready_and_clean ${CYBER_DOJO_CREATOR_PORT} creator-server
