#!/usr/bin/env sh

if [ -z $1 ]; then
  echo "Even type cannot be empty!"
  exit 1
fi

curl -X POST https://api.github.com/repos/ghdl/docker/dispatches \
-H "Content-Type: application/json" \
-H 'Accept: application/vnd.github.everest-preview+json' \
-H "Authorization: token ${GHDL_BOT_TOKEN}" \
--data '{"event_type": "$1"}'
