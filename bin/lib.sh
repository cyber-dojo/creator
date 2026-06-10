
exit_non_zero_unless_installed()
{
  for dependent in "$@"
  do
    printf "Checking %s is installed..." "${dependent}"
    if ! installed "${dependent}" ; then
      stderr "${dependent} is not installed"
      exit_non_zero
    else
      echo It is
    fi
  done
}

installed()
{
  local -r dependent="${1}"
  if hash "${dependent}" 2> /dev/null; then
    true
  else
    false
  fi
}

stderr()
{
  local -r message="${1}"
  >&2 echo "ERROR: ${message}"
}

exit_non_zero()
{
  exit 42
}

repo_root()
{
  git rev-parse --show-toplevel
}

service_container()
{
  # Echo the container id of the given docker-compose service within this
  # repo's project. The project is COMPOSE_PROJECT_NAME (set by bin/demo.sh),
  # defaulting to creator so the saver/test helpers also work against a plain
  # test run, where Compose derives the same project name from the repo
  # directory.
  local -r service="${1}"
  docker ps \
    --filter "label=com.docker.compose.project=${COMPOSE_PROJECT_NAME:-creator}" \
    --filter "label=com.docker.compose.service=${service}" \
    --format '{{.ID}}'
}

git_commit_sha()
{
  cd "$(repo_root)" && git rev-parse HEAD
}

get_image_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}

on_ci()
{
  [ -n "${CI:-}" ]
}

write_test_evidence_json()
{
  {
    echo '{ "server": '
    cat "$(repo_root)/test/server/reports/coverage.json"
    if [ "${1:-}" != 'server' ]; then
      echo ', "client": '
      cat "$(repo_root)/test/client/reports/coverage.json"
    fi
    echo '}'
  } | jq . > "$(test_evidence_json_path)"
}

test_evidence_json_path()
{
  echo "$(repo_root)/test/evidence.json"
}
