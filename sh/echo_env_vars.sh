
repo_root() { git rev-parse --show-toplevel; }

echo_env_vars()
{
  local -r commit_sha="$(cd "$(repo_root)" && git rev-parse HEAD)"
  local -r image_tag="${commit_sha:0:7}"

  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_CREATOR_SHA="${commit_sha}"
  echo CYBER_DOJO_CREATOR_TAG="${image_tag}"
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
