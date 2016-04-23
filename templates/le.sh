#!/bin/sh

set -e -u -o pipefail

if [ -z "${EMAIL:-}" ]; then
  echo "EMAIL environment variable for Let's Encrypt is not found." 2>&1
  exit 1
fi

if [ "x${AGREEMENT:-}" != "xyes" ]; then
  echo "you should agree to Terms of Services on Let's Encrypt." 2>&1
  exit 1
fi

{{ range $host, $container := groupByMulti $ "Env.VIRTUAL_HOST" "," }}
{{ if (ne $host "") }}
[ -d "/opt/data/{{ $host }}" ] || mkdir -p "/opt/data/{{ $host }}"

letsencrypt certonly \
  --webroot \
  --webroot-path "/opt/data/{{ $host }}" \
  --email $EMAIL \
  --domain "{{ $host }}" \
  --agree-tos \
  --non-interactive \
  --keep \
  ${EXTRA_ARGS:-} \
&& sh /opt/app/run generate
{{ end }}
{{ end }}

