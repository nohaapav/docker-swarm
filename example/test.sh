#!/bin/bash

source ../logger.sh

MANAGER_IP=$(docker-machine ip manager0)

log "Test round-robin DNS:"
for i in {1..6}; do curl http://$MANAGER_IP; done

log "Test DNS service discovery:"
for i in {1..6}; do curl http://$MANAGER_IP/redirect/serviceB; done
