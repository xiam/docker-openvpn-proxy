FROM alpine:3.20

RUN apk add --no-cache \
  iptables \
  openvpn

VOLUME /etc/openvpn

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
