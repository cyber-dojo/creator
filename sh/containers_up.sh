#!/bin/bash -Eeu

source "${SH_DIR}/augmented_docker_compose.sh"
source "${SH_DIR}/ip_address.sh"
readonly IP_ADDRESS=$(ip_address) # slow

# - - - - - - - - - - - - - - - - - - -
containers_up()
{
  top_container_up nginx
  wait_briefly_until_ready client
  copy_in_saver_test_data
}

# - - - - - - - - - - - - - - - - - - -
top_container_up()
{
  local -r service_name="${1}"
  printf '\n'
  augmented_docker_compose \
    up \
    --detach \
    --force-recreate \
      "${service_name}"
}

# - - - - - - - - - - - - - - - - - - - - - -
wait_briefly_until_ready()
{
  local -r service_name="${1}"
  local -r max_tries=40
  printf "Waiting until ${service_name} is ready"
  for n in $(seq ${max_tries}); do
    if curl_ready "${service_name}"; then
      printf '.OK\n'
      return
    else
      printf ".${n}"
      sleep 0.2
    fi
  done
  printf 'FAIL\n'
  echo "not ready after ${max_tries} tries"
  if [ -f "$(ready_filename)" ]; then
    ready_response
  fi
  local -r container_name=$(service_container ${service_name})
  docker logs ${container_name}
  exit 42
}

# - - - - - - - - - - - - - - - - - - -
curl_ready()
{
  local -r service_name="${1}"
  local -r path='ready?'
  local -r url="http://${IP_ADDRESS}:80/${service_name}/${path}"
  rm -f "$(ready_filename)"
  curl \
    --fail \
    --output $(ready_filename) \
    --request GET \
    --silent \
    "${url}"

  local -r status=$?
  [ "${status}" == '0' ] && [ "$(ready_response)" == '{"ready?":true}' ]
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
exit_if_unclean()
{
  local -r container_name="test-${1}"
  local log=$(docker logs "${container_name}" 2>&1)

  #Thin warnings...
  #local -r shadow_warning="server.rb:(.*): warning: shadowing outer local variable - filename"
  #log=$(strip_known_warning "${log}" "${shadow_warning}")
  #local -r mismatched_indent_warning="application(.*): warning: mismatched indentations at 'rescue' with 'begin'"
  #log=$(strip_known_warning "${log}" "${mismatched_indent_warning}")

  local -r line_count=$(echo -n "${log}" | grep --count '^')
  printf "Checking ${container_name} started cleanly..."
  # 3 lines on Thin (Unicorn=6, Puma=6)
  # Thin web server (v1.7.2 codename Bachmanity)
  # Maximum connections set to 1024
  # Listening on 0.0.0.0:4536, CTRL+C to stop
  if [ "${line_count}" == '6' ]; then
    echo OK
  else
    echo FAIL
    echo_docker_log "${container_name}" "${log}"
    exit 42
  fi
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
copy_in_saver_test_data()
{
  local -r SRC_PATH=${ROOT_DIR}/test/data/cyber-dojo
  local -r SAVER_CID=$(docker ps --filter status=running --format '{{.Names}}' | grep "saver")
  local -r DEST_PATH=/cyber-dojo
  # You cannot docker cp to a tmpfs, so tar-piping instead...
  cd ${SRC_PATH} \
    && tar -c . \
    | docker exec -i ${SAVER_CID} tar x -C ${DEST_PATH}
}
