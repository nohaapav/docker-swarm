#!/bin/bash

GC='\033[0;32m' #green color
NC='\033[0m' #no color

log() {
	echo -e "${GC}$1${NC}"
}

log "Removing proxy machine..."
docker-machine ls -q --filter name=proxy | xargs docker-machine rm -y

log "Removing swarm cluster..."
docker-machine ls -q --filter swarm=master | xargs docker-machine rm -y
