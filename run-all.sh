#!/bin/bash

/gocron2/gocron2 web &
/gocron2/gocron2-node -allow-root &
npx -g node-red --userDir /nodered &
wait -n
exit $?
