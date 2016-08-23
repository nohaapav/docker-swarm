#!/bin/bash

docker network create --driver overlay backend-tier

docker service create \
  --network backend-tier \
  --replicas 3 \
  --name manager \
  --publish 80:8080/tcp \
  nohaapav/napp

docker service create \
  --network backend-tier \
  --replicas 3 \
  --name service \
  nohaapav/napp
