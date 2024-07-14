FROM golang:1.20 AS builder

ARG TARGETARCH
ARG GOCRON2_VERSION

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

FROM scratch

WORKDIR /gocron2
COPY --from=builder /tmp/gocron2 /gocron2/gocron2

VOLUME [ "/gocron2/conf", "/gocron2/log", "/gocron2/out" ]
EXPOSE 5920
CMD [ "/gocron2/gocron2", "web" ]
