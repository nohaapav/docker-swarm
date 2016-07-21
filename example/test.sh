#!/bin/bash

docker run --rm --net=example_back-tier busybox wget -q -O- http://manager:8080
