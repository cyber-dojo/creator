
# - - - - - - - - - - - - - - - - - - -
server_up_healthy_and_clean()
{
  export SERVICE_NAME=creator
  docker compose up --detach "${SERVICE_NAME}"
  exit_non_zero_unless_healthy
}

# - - - - - - - - - - - - - - - - - - -
client_up_healthy_and_clean()
{
  if [ "${1:-}" != 'server' ]; then
    export SERVICE_NAME=client
    docker compose up --detach nginx_stub
    exit_non_zero_unless_healthy
  fi
}

# - - - - - - - - - - - - - - - - - - -
exit_non_zero_unless_healthy()
{
  echo
  local -r MAX_TRIES=50
  printf "Waiting until %s is healthy" "${SERVICE_NAME}"
  for _ in $(seq ${MAX_TRIES})
  do
    if healthy; then
      echo; echo "${SERVICE_NAME} is healthy."
      return
    else
      printf .
      sleep 0.1
    fi
  done
  echo; echo "${SERVICE_NAME} not healthy after ${MAX_TRIES} tries."
  echo_docker_log
  echo
  exit_non_zero
}

# - - - - - - - - - - - - - - - - - - -
healthy()
{
  # Containers are no longer given fixed names (so concurrent demos/tests in
  # sibling repos do not collide), so resolve the service's container id by
  # its compose project+service label - see service_container in lib.sh.
  local -r cid="$(service_container "${SERVICE_NAME}")"
  [ -n "${cid}" ] && \
    docker ps --filter health=healthy --format '{{.ID}}' | grep -q "${cid}"
}

# - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  docker logs "$(service_container "${SERVICE_NAME}")" 2>&1
}
