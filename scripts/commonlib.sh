#!/bin/bash

yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}
