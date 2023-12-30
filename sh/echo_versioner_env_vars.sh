
echo_versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_CREATOR_SHA="$(git_commit_sha)"
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
