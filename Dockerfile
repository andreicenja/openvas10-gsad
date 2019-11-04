FROM ubuntu:bionic
MAINTAINER Mohammad Razavi <mrazavi64@gmail.com>

RUN set -ex; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gnupg; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3C453D244AA450E0; \
    echo "deb http://ppa.launchpad.net/mrazavi/gvm/ubuntu bionic main" > /etc/apt/sources.list.d/mrazavi-ubuntu-gvm-bionic.list; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y gsad ; \
    sed -i 's|/var/log/gvm/gsad.log|/dev/stdout|g' /etc/gvm/gsad_log.conf; \
    rm -rf /var/lib/apt/lists/*

ENV GVMD_HOST="gvmd" \
    GVMD_PORT="9390"

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["gsad", "-f", "--listen=0.0.0.0", "--allow-header-host pokeagain.eea.eu.int", "--rport=80", "--port=443", "--gnutls-priorities=SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0", "--mlisten=$GVMD_HOST", "--mport=$GVMD_PORT"]
