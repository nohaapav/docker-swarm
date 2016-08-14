#!/bin/bash

docker network create --driver overlay backend-tier

docker service create \
  --replicas 3 \
  --name serviceA \
  --network backend-tier \
  -p 80:8080 \
  nohaapav/app

docker service create \
  --replicas 3 \
  --name serviceB \
  --network backend-tier \
  nohaapav/app
