h2o-proxy-letsencrypt
=====================

A automated h2o reverse proxy with letsencrypt for docker containers.

DESCRIPTION
-----------

`h2o-proxy-letsencrypt` is a [h2o](https://github.com/h2o/h2o) automatic reverse proxy with [letsencrypt](https://letsencrypt.org/) for docker containers.

This package is based at [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy),
But base image for container is using at [letsencrypt official docker images](https://quay.io/repository/letsencrypt/letsencrypt?tag=latest).

**NOTE**: **THIS PACKAGE IS NOT PRODUCTION READY. SO YOU SHOULD USE THIS PACKAEGE AT YOUR OWN RISK.**

REQUIREMENTS
------------

  * docker 1.9 or later (this packages needs `ARG` supports in Dockerfile for build container image)
  * make

DEPENDENCES
-----------

  * [quay.io/letsencrypt/letsencrypt:latest](https://quay.io/repository/letsencrypt/letsencrypt?tag=latest) (for base image)
  * [libuv](https://github.com/libuv/libuv) (for build `h2o`)
  * [wslay](https://github.com/tatsuhiro-t/wslay) (for build `h2o`)
  * [h2o](https://github.com/h2o/h2o)
  * [docker-gen](https://github.com/jwilder/docker-gen/) (for generates configuration files)
  * [forego](https://github.com/ddollar/forego) (for manages to processes)

USAGE
-----

```
# clone this repository
$ git clone https://github.com/nyarla/h2o-proxy-letsencrypt.git
$ cd h2o-proxy-letsencrypt

# build container (replace your EMAIL address for letsencrypt account)
$ make EMAIL=account@example.com AGREEMENT=yes build

# run container or enter the built container (for debug)
$ make run
$ make debug

# stop h2o-proxy-letsencrypt container
$ make stop

# run any container for you'd like to proxies by h2o-proxy-letsencrypt

# for example (witn golang)

# golang server code
$ cat main.go
package main

import (
        "net/http"
)

func main() {
        http.Handle(`/`, http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
                w.Header().Set(`Content-Type`, `text/plain; charset=utf-8`)
                w.WriteHeader(http.StatusOK)
                w.Write([]byte("hello, world!\n"))
        }))

        http.ListenAndServe(`:9000`, nil)
}

# you should replace your own $DOMAIN.
$ sudo docker run -e VIRTUAL_HOST=$DOMAIN -e VIRTUAL_PORT=9000 -d -v `pwd`:/data/:ro --name golang-example -p 9000 golang:1.5 go-wrapper run run /data/main.go
```

ANOTHER COPYRIGHTS
------------------

  * Dockerfile - this file is referenced at [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy)'s Dockerfile when this file is written. 
  * h2o.conf - imported from [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy).
  * h2o.tmpl - imported from [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy), and modified by me.

Source code of [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy) is under the [MIT](https://github.com/zchee/h2o-proxy/blob/master/LICENSE).

AUTHOR
------

Naoki OKAMURA (Nyarla) <nyarla@thotep.net>

LICENSE
-------

[MIT](https://github.com/nyarla/h2o-proxy-letsencrypt/blob/master/LICENSE)
