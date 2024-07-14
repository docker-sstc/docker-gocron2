#/bin/bash

docker build -t gocron2 -f all/Dockerfile \
    --build-arg GOCRON2_VERSION=1.6.5 \
    .
