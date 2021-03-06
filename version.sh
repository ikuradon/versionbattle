#!/bin/bash

function get_version() {
  DOMAIN=$1
  LINK="https://$DOMAIN/about/more"
  VER_LAW=$(curl -m 10 -s $LINK | grep -E "<strong>[0-9]\.[0-9]\.[0-9]</strong>" $PAGE)
  VER=$(echo $VER_LAW | sed -r 's/.*>([0-9\.]+).*/\1/')
  if [ -n "$VER" ]; then
    echo "$VER $DOMAIN"
  fi
}

export -f get_version

if [ -f instances.list ]; then
  xargs -n1 -P0 -I % bash -c "get_version $INSTANCE %" < instances.list > results.list
else
  curl -s https://instances.mastodon.xyz/instances.json | jq -r '.[].name' > .instances.list
  xargs -n1 -P0 -I % bash -c "get_version $INSTANCE %" < .instances.list
  rm -f .instances.list
fi
