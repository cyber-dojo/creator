#!/bin/bash
set -e

image_name()
{
  echo "${CYBER_DOJO_CREATOR_IMAGE}"
}

export image_name
