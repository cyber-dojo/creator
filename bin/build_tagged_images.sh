#!/usr/bin/env bash
set -Eeu

readonly my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${my_dir}/lib.sh"
source "${my_dir}/remove_old_images.sh"
source "${my_dir}/echo_env_vars.sh"
exit_non_zero_unless_installed docker
export $(echo_env_vars)

#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  if [ "${CI:-}" == 'true' ]; then
    # In the CI workflow the image is built by a Github Action (secure-docker-build)
    # and the tests run against that downloaded image. Building it here instead would
    # test a different image to the one being attested and deployed.
    stderr "In CI workflow, image must be built with Github Action"
    exit_non_zero
  fi
  remove_old_images
  build_images
  tag_images_to_latest
  check_embedded_env_var
}

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  docker compose build --build-arg COMMIT_SHA="$(git_commit_sha)" \
    creator client nginx_stub
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag "${CYBER_DOJO_CREATOR_IMAGE}:$(image_tag)"        "${CYBER_DOJO_CREATOR_IMAGE}:latest"
  docker tag "${CYBER_DOJO_CREATOR_CLIENT_IMAGE}:$(image_tag)" "${CYBER_DOJO_CREATOR_CLIENT_IMAGE}:latest"
  echo
  echo "  echo CYBER_DOJO_CREATOR_SHA=$(git_commit_sha)"
  echo "  echo CYBER_DOJO_CREATOR_TAG=$(image_tag)"
  echo
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(sha_in_image)" ]; then
    stderr "unexpected env-var inside image $(image_name):$(image_tag)"
    stderr "expected: 'SHA=$(git_commit_sha)'"
    stderr "  actual: 'SHA=$(sha_in_image)'"
    exit_non_zero
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_CREATOR_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  echo "${CYBER_DOJO_CREATOR_SHA}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  echo "${CYBER_DOJO_CREATOR_TAG}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
sha_in_image()
{
  docker run --rm --platform linux/amd64 "$(image_name):$(image_tag)" sh -c 'echo -n ${SHA}'
}

