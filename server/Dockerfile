FROM alpine:3.20 AS builder

ENV GOCRON2_VERSION=1.6.2
ENV GOCRON2_REPO_BASEURL=https://github.com/up9cloud/gocron2
ENV GOCRON2_DOWNLOAD_FILE=gocron2-v${GOCRON2_VERSION}-linux-amd64.tar.gz
ENV GOCRON2_DOWNLOAD_URL=${GOCRON2_REPO_BASEURL}/releases/download/v${GOCRON2_VERSION}/${GOCRON2_DOWNLOAD_FILE}
ENV GOCRON2_NODE_DOWNLOAD_FILE=gocron2-node-v${GOCRON2_VERSION}-linux-amd64.tar.gz
ENV GOCRON2_NODE_DOWNLOAD_URL=${GOCRON2_REPO_BASEURL}/releases/download/v${GOCRON2_VERSION}/${GOCRON2_NODE_DOWNLOAD_FILE}
ENV CERTSTRAP_VERSION=1.3.0
ENV CERTSTRAP_DOWNLOAD_URL=https://github.com/square/certstrap/releases/download/v${CERTSTRAP_VERSION}/certstrap-linux-amd64

WORKDIR /tmp
RUN set -ex; \
    wget ${GOCRON2_DOWNLOAD_URL}; \
    tar zvxf ${GOCRON2_DOWNLOAD_FILE}; \
    wget ${GOCRON2_NODE_DOWNLOAD_URL}; \
    tar zvxf ${GOCRON2_NODE_DOWNLOAD_FILE}; \
	wget ${CERTSTRAP_DOWNLOAD_URL} -O certstrap; \
	chmod +x certstrap; \
	chown -R root:root .

FROM scratch

WORKDIR /gocron2
COPY --from=builder /tmp/gocron2 /gocron2/gocron2

VOLUME [ "/gocron2/conf", "/gocron2/log", "/gocron2/out" ]
EXPOSE 5920
CMD [ "/gocron2/gocron2", "web" ]
