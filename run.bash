#!/bin/bash

SERVER_STARTER_FLAGS='--port 0.0.0.0:80 --port 0.0.0.0:443 --pid-file=/var/run/h2o/h2o.pid --status-file=/var/run/h2o/h2o_status'

case "${1}" in
    h2o)
        exec /usr/local/share/h2o/start_server $SERVER_STARTER_FLAGS -- /usr/local/bin/h2o -c /etc/h2o/h2o.conf
        ;;
    dockergen)
        exec docker-gen -watch -only-exposed -notify "/bin/bash /opt/app/run.bash letsencrypt" /opt/app/letsencrypt.tmpl /opt/app/letsencrypt.bash
        ;;
    letsencrypt)
        exec /bin/bash /opt/app/letsencrypt.bash
        ;;
esac

