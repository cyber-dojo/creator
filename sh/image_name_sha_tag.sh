#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

image_name()
{
  echo "${CYBER_DOJO_CREATOR_IMAGE}"
}

image_sha()
{
  echo "${CYBER_DOJO_CREATOR_SHA}"
}

image_tag()
{
  echo "${CYBER_DOJO_CREATOR_TAG}"
}

sha_in_image()
{
  docker run --rm $(image_name):$(image_tag) sh -c 'echo -n ${SHA}'
}
