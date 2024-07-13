FROM golang:1.20 AS builder

ARG TARGETARCH

ENV GOCRON2_VERSION=1.6.5
ENV GOCRON2_REPO_BASEURL=https://github.com/up9cloud/gocron2
ENV GOCRON2_DOWNLOAD_FILE=gocron2-v${GOCRON2_VERSION}-linux-${TARGETARCH}.tar.gz
ENV GOCRON2_DOWNLOAD_URL=${GOCRON2_REPO_BASEURL}/releases/download/v${GOCRON2_VERSION}/${GOCRON2_DOWNLOAD_FILE}
ENV GOCRON2_NODE_DOWNLOAD_FILE=gocron2-node-v${GOCRON2_VERSION}-linux-${TARGETARCH}.tar.gz
ENV GOCRON2_NODE_DOWNLOAD_URL=${GOCRON2_REPO_BASEURL}/releases/download/v${GOCRON2_VERSION}/${GOCRON2_NODE_DOWNLOAD_FILE}
ENV CERTSTRAP_VERSION=1.3.0
ENV CERTSTRAP_DOWNLOAD_URL=https://github.com/square/certstrap/releases/download/v${CERTSTRAP_VERSION}/certstrap-linux-${TARGETARCH}

WORKDIR /tmp
RUN set -ex; \
    wget ${GOCRON2_DOWNLOAD_URL}; \
    tar zvxf ${GOCRON2_DOWNLOAD_FILE}; \
    wget ${GOCRON2_NODE_DOWNLOAD_URL}; \
    tar zvxf ${GOCRON2_NODE_DOWNLOAD_FILE}; \
    git clone https://github.com/square/certstrap.git c; \
    cd c; \
    git checkout 86891c19509ef6891853e2eb366ca310332db6b8; \
    CGO_ENABLED=0 go build -buildvcs=false -o certstrap github.com/square/certstrap; \
    mv certstrap /tmp/certstrap; \
    cd /tmp; \
    # wget ${CERTSTRAP_DOWNLOAD_URL} -O certstrap; \
    chmod +x certstrap; \
    chown -R root:root .

FROM sstc/headful-chromium:ubuntu-24
RUN set -ex; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    tini \
    iputils-ping \
    dnsutils \
    rsync \
    curl \
    jq \
    ; \
    # In the mean time, install all popular scripting languages
    # curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    #	nodejs \
    #	npm \
    php \
    ruby \
    lua5.4 \
    ; \
    bash --version; \
    perl --version; \
    # python2 --version; \
    python3 --version; \
    node -v; \
    npm -v; \
    php -v; \
    ruby -v; \
    lua -v; \
    apt clean; \
    rm -rf /var/lib/apt/lists/*

# https://npmtrends.com/axios-vs-got-vs-node-fetch-vs-request-vs-superagent
RUN set -e; \
    npm -g install \
    node-fetch

COPY --from=builder /tmp/gocron2 /gocron2/gocron2
COPY --from=builder /tmp/gocron2-node /gocron2/gocron2-node
COPY --from=builder /tmp/certstrap /gocron2/certstrap
COPY run-all.sh /gocron2/run-all.sh
COPY init-cert.sh /gocron2/init-cert.sh

# https://github.com/node-red/node-red-docker/blob/master/docker-custom/Dockerfile.debian
# https://npmtrends.com/n8n-vs-node-red
RUN set -ex; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    bash \
    tzdata \
    curl \
    nano \
    wget \
    git \
    openssl \
    openssh-client \
    ca-certificates \
    ;

RUN set -e; \
    npm i -g --unsafe-perm --no-update-notifier --no-fund --only=production \
    node-red

WORKDIR /app
VOLUME [ "/gocron2/conf", "/gocron2/log", "/gocron2/out", "/nodered", "/app" ]
EXPOSE 5920
EXPOSE 5921
EXPOSE 1880
ENTRYPOINT ["tini", "--"]
CMD ["/gocron2/run-all.sh"]
