
#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  build_images
  tag_images_to_latest
  check_embedded_env_var
}

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  if ! on_ci ; then
    echo "Not on CI so building all"
    docker compose build --build-arg COMMIT_SHA="$(git_commit_sha)" \
      creator client nginx
  else
    echo "On CI so building all except creator"
    docker compose build --build-arg COMMIT_SHA="$(git_commit_sha)" \
      client nginx
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag "${CYBER_DOJO_CREATOR_IMAGE}:$(image_tag)"        "${CYBER_DOJO_CREATOR_IMAGE}:latest"
  docker tag "${CYBER_DOJO_CREATOR_CLIENT_IMAGE}:$(image_tag)" "${CYBER_DOJO_CREATOR_CLIENT_IMAGE}:latest"
  echo
  echo "echo CYBER_DOJO_CREATOR_SHA=$(git_commit_sha)"
  echo "echo CYBER_DOJO_CREATOR_TAG=$(image_tag)"
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
  docker run --rm "$(image_name):$(image_tag)" sh -c 'echo -n ${SHA}'
}
