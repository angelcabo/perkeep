#!/bin/sh

set -e

if [ "$1" = "server" ]; then
  chown -R keepy:keepy /etc/perkeep /var/perkeep
  exec su-exec keepy:keepy ./bin/perkeepd
else
  exec "$@"
fi