#!/bin/bash
set -e

readonly root_dir="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly my_name=creator

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_tests()
{
  local -r coverage_root=/tmp/coverage
  local -r user="${1}"                           # eg nobody
  local -r test_dir="test_${2}"                  # eg test_server
  local -r container_name="test-${my_name}-${2}" # eg test-creator-server

  set +e
  docker exec \
    --user "${user}" \
    --env COVERAGE_ROOT=${coverage_root} \
    "${container_name}" \
      sh -c "/app/test/util/run.sh ${@:3}"
  set -e
  local -r status=$?

  # You can't [docker cp] from a tmpfs,
  # so tar-piping coverage out.
  docker exec \
    "${container_name}" \
    tar Ccf \
      "$(dirname "${coverage_root}")" \
      - "$(basename "${coverage_root}")" \
        | tar Cxf "${root_dir}/app/${test_dir}/" -

  printf "Coverage report copied to app/${test_dir}/coverage/\n"
  return ${status}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
declare server_status=0
run_server_tests()
{
  run_tests nobody server "${*}"
  server_status=$?
}

declare client_status=0
run_client_tests()
{
  run_tests nobody client "${*}"
  client_status=$?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
echo
if [ "${1}" == 'server' ]; then
  shift
  run_server_tests "$@"
elif [ "${1}" == 'client' ]; then
  shift
  run_client_tests "$@"
else
  run_server_tests "$@"
  run_client_tests "$@"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "${server_status}" == '0' ] && [ "${client_status}" == '0' ];  then
  echo All passed
  exit 0
else
  echo
  echo "test-${my_name}-server: status = ${server_status}"
  echo "test-${my_name}-client: status = ${client_status}"
  echo
  exit 42
fi
