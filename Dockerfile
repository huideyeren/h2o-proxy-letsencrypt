FROM alpine:edge
MAINTAINER Naoki OKAMURA <nyarla@thotep.net>

ENV DOCKERGEN_BINARY_URL https://github.com/jwilder/docker-gen/releases/download/0.7.0/docker-gen-alpine-linux-amd64-0.7.0.tar.gz
ENV FOREGO_GO_URL        github.com/ddollar/forego

ENV GOPATH /opt/go

RUN  sh -c '[ -d /opt/go    ] || mkdir -p /opt/go' \
  && sh -c '[ -d /opt/app   ] || mkdir -p /opt/app' \
  && sh -c '[ -d /opt/data  ] || mkdir -p /opt/data'

RUN  sh -c 'echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories' \
  && apk update \
  && apk upgrade \
  && apk add -U h2o certbot go git bzr mercurial py-pip curl bash musl-dev \
  && sh -c 'curl -L "$DOCKERGEN_BINARY_URL" | tar -C /usr/bin -xz && chmod +x /usr/bin/docker-gen' \
  && sh -c 'go get -u -v $FOREGO_GO_URL && mv /opt/go/bin/forego /usr/bin/ && chmod +x /usr/bin/forego' \
  && sh -c 'pip install devcron' \
  && rm -rf $GOPATH \
  && apk del -U go git bzr mercurial curl musl-dev \
  && rm -rf /var/cache/apk/*

ENV DOCKER_HOST unix:///tmp/docker.sock

COPY templates /opt/app/templates
COPY Procfile  /opt/app/Procfile
COPY run       /opt/app/run
COPY crontab   /opt/app/crontab
RUN chmod +x   /opt/app/run

WORKDIR /opt/app

EXPOSE 80 443
ENTRYPOINT ["/bin/sh", "/opt/app/run"]
CMD ["bootstrap"]

