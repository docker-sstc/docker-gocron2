#!/bin/bash

./gocron web &
./gocron-node -allow-root &
wait -n
exit $?
