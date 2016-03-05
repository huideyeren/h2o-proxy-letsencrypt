h2o-proxy-letsencrypt
=====================

  * A [h2o](https://h2o.examp1e.net/) reverse proxy for docker containers with fully automation of https encryption by Let's Encrypt certificate.

History
-------

The first version of this package is based on [zchee/h2o-proxy](https://github.com/zchee/h2o-proxy),
But that source code by I improved is very ugly, and very unuseful.

So I decide to rewrite, cleanup or improve of this package.

Requirements
------------

  * docker 1.9 or later (`ARG` support by docker is required)
  * make (run helper Makefile)
  * Cloudflare Account and API token (this package is using at `dns-01` challenge with cloudflare)

Build
-----

```bash
$ git clone https://github.com/nyarla/h2o-proxy-letsencrypt.git
$ cd h2o-proxy-letsencrypt
$ docker build --rm -t h2o-proxy-letsencrypt .
```

Usage
-----

```bash
# The first, you should launch webapp with `VIRTUAL_HOST` environment variables.
# for example:
$ git clone https://github.com/docker-training/webapp
$ cd webapp
$ docker build -t webapp .
$ docker run -d -e VIRTUAL_HOST=test.example.com webapp

# The second, run h2o-proxy-letsencrypt with some environment variables.
# for example:
$ docker run -d \
  --net=host -p 80:80 -p 443:443 \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  -v /opt/docker/h2o-proxy-letsencrypt:/opt/data \
  -e EMAIL='email-account-for-letsencrypt@example.com' \
  -e AGREEMENT='yes' \
  -e CF_EMAIL='email-account-registered-at-cloudflare@example.com' \
  -e CF_KEY='<cloudflare api key is here>' \
  h2o-proxy-letsencrypt:latest

# That's all. now we can access to `test.example.com` by https
$ curl -k https://localhost/
```

AUTHOR
------

Naoki OKAMURA a.k.a nyarla <nyarla@thotep.net>

COPYRIGHTS
----------

* `templates/h2o.conf`
  * this file is based on [zhcee/h2o-proxy#h2o.tmpl](https://github.com/zchee/h2o-proxy/blob/master/h2o.tmpl)
  * that file is written by [zchee](https://github.com/zchee), and licesed by [MIT](https://github.com/zchee/h2o-proxy/blob/master/LICENSE)
* `Dockerfile`
  * this file is written by me, but partial includes Dockerfile code from [lkwg82/h2o.docker](https://github.com/lkwg82/h2o.docker)
  * that file is written by [Lars K.W. Gohlke](https://github.com/lkwg82), and licensed by [GPLv3](https://github.com/lkwg82/h2o.docker/blob/master/LICENSE)

LICENSE
-------

  * License of except `Dockerfile` is under the MIT-license.
  * License of only `Dockerfile` is under the GPLv3.
