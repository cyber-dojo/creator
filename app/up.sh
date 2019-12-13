#!/bin/bash

export RUBYOPT='-W2'

rackup \
  --env production \
  --port 4523      \
  --warn           \
    config.ru
