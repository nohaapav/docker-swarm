#!/bin/bash

source ../logger.sh

MANAGER_IP=$(docker-machine ip manager0)

log "Test IPVS LB:"
for i in {1..6}; do curl http://$MANAGER_IP; done

log "Test VIP DNS RR:"
for i in {1..6}; do curl http://$MANAGER_IP/redirect/service; done
