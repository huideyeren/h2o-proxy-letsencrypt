h2o-proxy-letsencrypt
=====================

  * A [h2o](https://h2o.examp1e.net)-based [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)-like reverse proxy for docker containers with full-auto [Let's Encrypt](https://letsencrypt.org/)

HISTORY
-------

  * Curren Version:  It's based on `alpine:edge` docker image and use `@testing` repository.
  * Second Version: It's based on [lkwg82/h2o.docker](https://github.com/lkwg82/h2o.docker)
  * First Version: It's based on [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy)

REQUIREMENTS
------------

  * Docker with `-e` flag  supports

BUILD
-----

```
$ git clone https://github.com/nyarla/h2o-proxy-letsencrypt.git
$ cd h2o-proxy-letsencrypt
$ docker build --rm -t h2o-proxy-letsencrypt
```

USAGE
-----

### 1. Start h2o-proxy-letsencrypt container

```bash
$ docker run -d \
  --net=host -p 80:80 -p 443:443 \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  -e EMAIL=<YOUR EMAIL IS HERE> \
  -e AGREEMET=<`yes` if you agree to Let's Encrypt Terms of Services> \
  h2o-proxy-letsencrypt:latest
```

### 2. Start your application container with `-e VIRTUAL_HOST=${YOUR DOMAIN}` flag

```bash
$ git clone https://github.com/docker-training/webapp
$ cd webapp
$ docker build -t webapp .
$ docker run -d -e VIRTUAL_HOST=<YOUR DOMAIN IS HERE> webapp
```

### 3. Access your application container

```
$ curl https://<YOUR DOMAIN>/
```

AUTHOR
------

Naoki OKAMURA a.k.a nyarla <nyarla@thotep.net>

COPYRIGHTS
----------

`templates/h2o.conf` is based on [zhcee/h2o-proxy#h2o.tmpl](https://github.com/zchee/h2o-proxy/blob/master/h2o.tmpl),
and original file is under the [MIT](https://github.com/zchee/h2o-proxy/blob/master/LICENSE) license.

LICENSE
-------

MIT (See `LICENSE` file.)
