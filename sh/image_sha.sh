#!/bin/bash
set -e

image_sha()
{
  docker run --rm ${CYBER_DOJO_CREATOR_IMAGE}:latest sh -c 'echo ${SHA}'
}

export image_sha
