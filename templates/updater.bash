#!/usr/bin/env bash

set -e -u -o pipefail

if [ -z "${EMAIL:-}" ]; then
  echo "contact email address for LetsEncrypt is not specified in environment value." 2>&1
  exit 1
fi

if [ "x${AGREEMENT:-}" != "xyes" ]; then
  echo "you should agree to LetsEncrypt's terms of services." 2>&1
  exit 1
fi

if [ -z "${CF_EMAIL}" ]; then
  echo "email address for cloudflare api accessing is not found." 2>&1
  exit 1
fi

if [ -z "${CF_KEY}" ]; then
  echo "api token for cloudflare api accessing is not found." 2>&1
  exit 1
fi

{{ range $host, $container := groupByMulti $ "Env.VIRTUAL_HOST" "," }}
{{ if (ne $host "") }}

datadir="/opt/data/{{ $host }}"
[ -d "${datadir}" ] || mkdir -p "${datadir}"

/usr/local/bin/letsencrypt \
  -c \
  -d "{{ $host }}" \
  -f /opt/app/config.sh \
  -t "dns-01" \
  -k "letsencrypt-cloudflare"

/opt/app/run generate

{{ end }}
{{ end }}
