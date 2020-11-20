#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
echo_versioner_env_vars()
{
  local -r sha=$(git_commit_sha)
  local -r tag="${sha:0:7}"
  docker run --rm cyberdojo/versioner:latest
  echo CYBER_DOJO_CREATOR_SHA="$(get_image_sha)"
  echo CYBER_DOJO_CREATOR_TAG="$(get_image_tag)"
  echo CYBER_DOJO_CREATOR_CLIENT_IMAGE=cyberdojo/client
  echo CYBER_DOJO_CREATOR_CLIENT_PORT=9999
  echo CYBER_DOJO_CREATOR_CLIENT_USER=nobody
  echo CYBER_DOJO_CREATOR_SERVER_USER=nobody

  echo CYBER_DOJO_MODEL_SHA=d1a1882130f5aeda064d8c073bda98a385076a16
  echo CYBER_DOJO_MODEL_TAG=d1a1882
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_sha()
{
  echo "$(cd "${ROOT_DIR}" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_tag()
{
  local -r sha="$(get_image_sha)"
  echo "${sha:0:7}"
}
