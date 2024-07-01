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

WORKDIR /gocron2
COPY --from=builder /tmp/gocron2 /gocron2/gocron2
COPY --from=builder /tmp/gocron2-node /gocron2/gocron2-node
COPY --from=builder /tmp/certstrap /gocron2/certstrap
COPY run-all.sh /gocron2/run-all.sh
COPY init-cert.sh /gocron2/init-cert.sh

VOLUME [ "/gocron2/conf", "/gocron2/log", "/gocron2/out", "/app" ]
EXPOSE 5920
EXPOSE 5921
ENTRYPOINT ["tini", "--"]
CMD ["/gocron2/run-all.sh"]
