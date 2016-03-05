FROM lkwg82/h2o-http2-server
MAINTAINER Naoki OKAMURA <nyarla@thotep.net>

ENV SHOREMAN_URL    https://raw.githubusercontent.com/chrismytton/shoreman/master/shoreman.sh
ENV LETSENCRYPT_URL https://raw.githubusercontent.com/lukas2511/letsencrypt.sh/master/letsencrypt.sh
ENV DOCKER_GEN_URL  https://github.com/jwilder/docker-gen/releases/download/0.7.0/docker-gen-alpine-linux-amd64-0.7.0.tar.gz
ENV CLOUDFLARE_URL  https://raw.githubusercontent.com/kappataumu/letsencrypt-cloudflare-hook/master/hook.py

RUN apk update && apk upgrade \
  # Installing dependences for letsencrypt \
  && apk add -U \
    bash \
    curl \
    grep \
    libffi \
    python \
    py-cffi \
    py-cryptography \
    py-enum34 \
    py-idna \
    py-ipaddress \
    py-ndg_httpsclient \
    py-asn1 \
    py-cparser \
    py-openssl \
    py-requests \
    py-six \
    # listing of installed packages after installed dependences \
    && grep ^P /lib/apk/db/installed | sed -e 's/^P//g' | sort >/tmp/deps \
  # Installing build dependences for letsencrypt \
  && apk add -U \
    build-base \
    diffutils \
    py-pip \
    python-dev \
    tar \
    # listing of installed packages after installed build dependences \
    && grep ^P /lib/apk/db/installed | sed -e 's/^P//g' | sort >/tmp/build \
  # Installing letsencrypt.sh and cloudflare hook \
  && curl -L -o /usr/local/bin/letsencrypt $LETSENCRYPT_URL \
    && chmod +x /usr/local/bin/letsencrypt \
  && curl -L -o /usr/local/bin/letsencrypt-cloudflare $CLOUDFLARE_URL \
    && chmod +x /usr/local/bin/letsencrypt-cloudflare \
  && pip install --upgrade pip \
  && pip install -U dnspython future tld wheel \
  # Installing forego and docker-gen \
  && curl -L -o /usr/local/bin/shoreman $SHOREMAN_URL \
    && chmod +x /usr/local/bin/shoreman \
  && curl -L $DOCKER_GEN_URL | tar -C /usr/local/bin -zx \
    && chmod + /usr/local/bin/docker-gen \
  # Uninstall unnecessary packages \
  && diff /tmp/deps /tmp/build | grep -e '^+[^+]' | sed -e 's/+//g' | xargs -n1 apk del 

RUN mkdir -p  /etc/h2o \
              /var/run/h2o \
              /var/log/h2o \
              /opt/app \
              /opt/data \
              /opt/web

COPY . /opt/app/
RUN chmod +x /opt/app/run 
WORKDIR /opt/app

ENV DOCKER_HOST unix:///tmp/docker.sock

ARG EMAIL
ENV EMAIL ${EMAIL:-}

ARG AGREEMENT
ENV AGREEMENT ${AGREEMENT:-no}

ARG CF_EMAIL 
ENV CF_EMAIL ${CF_EMAIL:-$EMAIL}

ARG CF_KEY 
ENV CF_KEY ${CF_KEY:-}

ENTRYPOINT [ "/opt/app/run" ]
CMD [ "bootstrap" ]
