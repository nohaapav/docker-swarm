#!/bin/bash

GC='\033[0;32m' #green color
NC='\033[0m' #no color

log() {
        echo -e "${GC}$1${NC}"
}

SWARM_NODES=("node0" "node1")
SWARM_MEMBERS=("master" ${SWARM_NODES[@]})

log "Creating proxy machine..."
docker-machine create --driver virtualbox --virtualbox-memory 512 proxy

# Get consul ip address
CONSUL_IP=$(docker-machine ip proxy)

# Switch to proxy machine 
eval "$(docker-machine env proxy)"

log "Starting consul server..."  
docker run -d -p "8500:8500" -h "consul" gliderlabs/consul-server -server -bootstrap

log "Creating swarm master..."
docker-machine create \
    --driver virtualbox \
    --virtualbox-memory 512 \
    --swarm \
    --swarm-master \
    --swarm-discovery="consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-store=consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    master

for i in "${SWARM_NODES[@]}"; do
	log "Creating swarm $i..."
	docker-machine create \
            --driver virtualbox \
            --virtualbox-memory 512 \
            --swarm \
            --swarm-discovery="consul://$CONSUL_IP:8500" \
            --engine-opt="cluster-store=consul://$CONSUL_IP:8500" \
            --engine-opt="cluster-advertise=eth1:2376" \
	    $i
done

# Switch to swarm manager/master
eval $(docker-machine env --swarm master)

for i in "${SWARM_MEMBERS[@]}"; do
        log "Starting registrator for swarm $i..."
        docker run -d \
                -e constraint:node==$i \
                -v /var/run/docker.sock:/tmp/docker.sock \
                --name=registrator-$i \
                --net=host \
                gliderlabs/registrator \
                consul://$CONSUL_IP:8500
done   

log "Swarm cluster is up!!!"
