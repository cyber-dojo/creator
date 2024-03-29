#!/usr/bin/env bash
set -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
echo_versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_CREATOR_SHA="$(get_image_sha)"
  echo CYBER_DOJO_CREATOR_TAG="$(get_image_tag)"
  #
  echo CYBER_DOJO_CREATOR_CLIENT_IMAGE=cyberdojo/client
  echo CYBER_DOJO_CREATOR_CLIENT_PORT=9999
  #
  echo CYBER_DOJO_CREATOR_CLIENT_USER=nobody
  echo CYBER_DOJO_CREATOR_SERVER_USER=nobody
  #
  echo CYBER_DOJO_CREATOR_CLIENT_CONTAINER_NAME=test_creator_client
  echo CYBER_DOJO_CREATOR_SERVER_CONTAINER_NAME=test_creator_server
}

# - - - - - - - - - - - - - - - - - - - - - - - -
root_dir()
{
  git rev-parse --show-toplevel
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_sha()
{
  echo "$(cd "$(root_dir)" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_tag()
{
  local -r sha="$(get_image_sha)"
  echo "${sha:0:7}"
}
