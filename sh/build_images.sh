#!/bin/bash -Eeu

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${MY_DIR}/augmented_docker_compose.sh"
source "${MY_DIR}/versioner_env_vars.sh"
source "${MY_DIR}/image_sha.sh"
export $(versioner_env_vars)

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  export COMMIT_SHA="$(git_commit_sha)"
  augmented_docker_compose build
  unset COMMIT_SHA
  assert_equal SHA "$(git_commit_sha)" "$(image_sha)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${MY_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
assert_equal()
{
  local -r name="${1}"
  local -r expected="${2}"
  local -r actual="${3}"
  if [ "${expected}" != "${actual}" ]; then
    echo "ERROR: unexpected ${name} inside image"
    echo "expected: ${name}='${expected}'"
    echo "  actual: ${name}='${actual}'"
    exit 42
  fi
}
