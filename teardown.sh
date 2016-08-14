#!/bin/bash

source logger.sh

log "Removing swarm managers..."
docker-machine ls -q --filter name=manager* | xargs docker-machine rm -y

log "Removing swarm workers..."
docker-machine ls -q --filter name=worker* | xargs docker-machine rm -y
