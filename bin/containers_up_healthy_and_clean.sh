
# - - - - - - - - - - - - - - - - - - -
server_up_healthy_and_clean()
{
  export SERVICE_NAME=creator
  export CONTAINER_NAME="${CYBER_DOJO_CREATOR_SERVER_CONTAINER_NAME}"
  export CONTAINER_PORT="${CYBER_DOJO_CREATOR_PORT}"
  docker compose up --detach "${SERVICE_NAME}"
  exit_non_zero_unless_healthy
}

# - - - - - - - - - - - - - - - - - - -
client_up_healthy_and_clean()
{
  if [ "${1:-}" != 'server' ]; then
    export SERVICE_NAME=client
    export CONTAINER_NAME="${CYBER_DOJO_CREATOR_CLIENT_CONTAINER_NAME}"
    export CONTAINER_PORT="${CYBER_DOJO_CREATOR_CLIENT_PORT}"
    docker compose up --detach nginx
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
  docker ps --filter health=healthy --format '{{.Names}}' | grep -q "${CONTAINER_NAME}"
}

# - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  docker logs "${CONTAINER_NAME}" 2>&1
}
