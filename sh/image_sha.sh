#!/bin/bash -Eeu

image_sha()
{
  docker run --rm ${CYBER_DOJO_CREATOR_IMAGE}:latest sh -c 'echo ${SHA}'
}
