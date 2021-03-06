#!/bin/bash

source logger.sh

SWARM_MANAGERS=("manager0" "manager1" "manager2")
SWARM_WORKERS=("worker0" "worker1" "worker2")

SWARM_LEADER=true
SWARM_LEADER_IP=()
SWARM_MANAGER_TOKEN=()
SWARM_WORKER_TOKEN=()

for i in "${SWARM_MANAGERS[@]}"; do
        log "Creating $i machine..."
        docker-machine create --driver virtualbox --virtualbox-memory 512 $i
        eval "$(docker-machine env $i)"

        if $SWARM_LEADER ;
        then
        docker swarm init --advertise-addr $(docker-machine ip $i)
        SWARM_MANAGER_TOKEN=$(docker swarm join-token manager -q)
        SWARM_WORKER_TOKEN=$(docker swarm join-token worker -q)
        SWARM_LEADER_IP=$(docker-machine ip $i) 
        SWARM_LEADER=false
        else
        docker swarm join --token $SWARM_MANAGER_TOKEN $SWARM_LEADER_IP:2377
        fi
done

for i in "${SWARM_WORKERS[@]}"; do
        log "Creating $i machine..."
        docker-machine create --driver virtualbox --virtualbox-memory 512 $i
        eval "$(docker-machine env $i)"
        docker swarm join --token $SWARM_WORKER_TOKEN $SWARM_LEADER_IP:2377
done

log "Swarm cluster is running with given info:"
log "Manager token: $SWARM_MANAGER_TOKEN"
log "Worker token: $SWARM_WORKER_TOKEN"
log "Current manager leader: $SWARM_LEADER_IP:2377"
