# openvpn-proxy

```
docker run --rm \
    --name openvpn-proxy \
    -v ./config/config.ovpn:/etc/openvpn/client/config.ovpn \
    -e OPENVPN_IP=10.9.1.84 \
    -e TCP_PORT_FORWARDINGS=80,443 \
    -p 0.0.0.0:80:80 \
    -p 0.0.0.0:443:443 \
    --device /dev/net/tun:/dev/net/tun \
    --cap-add=NET_ADMIN \
    -it \
    xiam/openvpn-proxy:latest
```
