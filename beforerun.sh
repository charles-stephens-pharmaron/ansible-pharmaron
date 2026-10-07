#!/bin/bash

set -e

source /opt/ansible-pharmaron/bws.env

eval "$(ssh-agent -s)"

ssh-add <(
    bws secret get \
      --access-token "$BWS_ACCESS_TOKEN" \
      -o json \
      8f5c8064-5333-4396-8cf4-b4dc0107f4a0 \
      | jq -r '.value'
)

ssh-add -l