# docker-gocron2

## Usage

> One container: gocron2 and gocron2-node are in the same container

```bash
# Up gocron2 and gocron2-node
docker run -d --rm \
  -v /path/to/conf:/gocron2/conf \
  -v /path/to/log:/gocron2/log \
  -v /my/task-scripts:/app \
  -p 5920:5920 \
  sstc/gocron2

# Open 127.0.0.1:5920 to install
```

> One host: gocron2 and gocron2-node are in the different containers, but on the same host

```bash
# Up gocron2
docker run -d --name gocron2 \
  -v /path/to/conf:/gocron2/conf \
  -v /path/to/log:/gocron2/log \
  --net host \
  sstc/gocron2:server

# Up gocron2-node
docker run -d --name gocron2-node \
  -v /path/to/my-task-scripts:/app \
  --net host \
  sstc/gocron2 /gocron2/gocron2-node -allow-root

# Open 127.0.0.1:5920 to install
```

> Multiple nodes with certs

```bash
# Create certs for main node (we mount conf/ to out/, because certs will output to out/)
docker run --rm \
  -v /path/to/conf:/gocron2/out \
  sstc/gocron2 ./init-cert.sh

# Create certs for worker nodes
docker run --rm \
  -v /path/to/conf:/gocron2/out \
  sstc/gocron2 ./init-cert.sh 1.2.3.4

# Configure main node: add those to /path/to/conf/app.ini
#   enable_tls = true
#   ca_file    = /gocron2/conf/Root_CA.crt
#   cert_file  = /gocron2/conf/127.0.0.1.crt
#   key_file   = /gocron2/conf/127.0.0.1.key

# Up main node
docker run -d --name gocron2 \
  -v /path/to/conf:/gocron2/conf \
  -v /path/to/log:/gocron2/log \
  -p 5920:5920 \
  sstc/gocron2:server

# Copy cert files in /path/to/conf for the worker nodes

# Up all worker nodes
docker run -d --name gocron2-node \
  -v /path/to/conf:/gocron2/conf \
  -v /path/to/my-task-scripts:/app \
  -p 5921:5921 \
  sstc/gocron2 gocron2-node -allow-root \
  -enable-tls \
  -ca-file /gocron2/conf/Root_CA.crt \
  -cert-file /gocron2/conf/1.2.3.4.crt \
  -key-file /gocron2/conf/1.2.3.4.key

# Open 127.0.0.1:5920 to install
```
