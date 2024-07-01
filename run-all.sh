#!/bin/bash

./gocron2 web &
./gocron2-node -allow-root &
wait -n
exit $?
