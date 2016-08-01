#!/bin/bash

GC='\033[0;32m' #green color
NC='\033[0m' #no color

function log { echo -e "${GC}$1${NC}"; }

log "Removing swarm managers..."
docker-machine ls -q --filter name=manager* | xargs docker-machine rm -y

log "Removing swarm workers..."
docker-machine ls -q --filter name=worker* | xargs docker-machine rm -y
