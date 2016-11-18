# Clustered multi-master PowerDNS
FROM ubuntu:xenial

MAINTAINER Will Rouesnel <w.rouesnel@gmail.com>

COPY tree-preinstall/ /

COPY *.asc /tmp/

RUN apt-key add /tmp/*.asc && rm -f /tmp/*.asc

RUN apt-get update && apt-get install -y pdns-server pdns-recursor pdns-backend-sqlite3 wget && \
    sqlite3 /var/lib/powerdns/powerdns.sqlite3 < /usr/share/doc/pdns-backend-sqlite3/schema.sqlite3.sql && \
    chown -R pdns:pdns /var/lib/powerdns && \
    rm -rf /etc/powerdns/pdns.d/* && rm -f bindbackend.conf && \
    wget -O /usr/local/bin/p2 https://github.com/wrouesnel/p2cli/releases/download/r4/p2 && \
    chmod +x /usr/local/bin/p2 && \
    apt-get remove -y --purge wget && apt-get autoremove -y
    
COPY tree-postinstall/ /

ENV API_KEY=changeme

ENTRYPOINT [ "/entrypoint.bsh" ]
