FROM quay.io/letsencrypt/letsencrypt:latest
MAINTAINER Naoki OKAMURA (Nyarla) <nyarla@thotep.net>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf automake cmake ninja-build mruby libmruby-dev build-essential checkinstall pkg-config python-sphinx libcunit1-dev libtool nettle-dev wget && \
    rm -rf /var/lib/apt/lists/*

RUN [ -d /usr/local/src ] || mkdir -p /usr/local/src
WORKDIR /usr/local/src

RUN git clone --depth=1 https://github.com/libuv/libuv && \
    cd libuv && \
        sh autogen.sh && \
        ./configure && \
        make && \
        make install

RUN git clone --depth=1 https://github.com/tatsuhiro-t/wslay && \
    cd wslay && \
        autoreconf -i && \
        automake && \
        autoconf && \
        ./configure && \
        make && \
        make install

RUN git clone --depth=1 --recursive https://github.com/h2o/h2o && \
    cd h2o && \
        cmake -G 'Ninja' -DWITH_BUNDLED_SSL=off . && \
        ninja && \
        ninja install

RUN wget -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego && \
        chmod u+x /usr/local/bin/forego

ARG DOCKER_GEN_VERSION
ENV DOCKER_GEN_VERSION ${DOCKER_GEN_VERSION:-0.4.3}
RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
        tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
        rm docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN mkdir -p /etc/h2o /var/run/h2o/ /var/log/h2o/
COPY h2o.conf /etc/h2o/h2o.conf

RUN [ -d /data    ] || mkdir -p /data

RUN [ -d /opt/app ] || mkdir -p /opt/app
COPY . /opt/app/
WORKDIR /opt/app/

ENV DOCKER_HOST unix:///tmp/docker.sock

ARG EMAIL
ENV EMAIL ${EMAIL:-}

ARG AGREEMENT
ENV AGREEMENT ${AGREEMENT:-no}

ENTRYPOINT [ "/usr/local/bin/forego" ]
CMD [ "start", "-r" ]
