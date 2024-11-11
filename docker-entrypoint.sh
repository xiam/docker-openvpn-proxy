#!/bin/sh

set -e

IPTABLES_RULES_FILE=/etc/iptables/rules-save

OPENVPN_CONFIG_FILE=/etc/openvpn/client/config.ovpn

if [ ! -f "$OPENVPN_CONFIG_FILE" ]; then
	echo "Config file not found. Exiting..."
	exit 1
fi

if [ ! -f "$IPTABLES_RULES_FILE" ]; then
	if [ -z "$TCP_PORT_FORWARDINGS" ]; then
		echo "No port forwardings specified. Exiting..."
		exit 1
	fi
	if [ -z "$OPENVPN_IP" ]; then
		echo "No OpenVPN IP specified. Exiting..."
		exit 1
	fi
	# create the file if it doesn't exist
	touch $IPTABLES_RULES_FILE
	echo "*nat" > $IPTABLES_RULES_FILE
	TCP_PORTS=$(echo $TCP_PORT_FORWARDINGS | tr "," "\n")
	for PORT in $TCP_PORTS; do
		echo "-A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $OPENVPN_IP:$PORT" >> $IPTABLES_RULES_FILE
	done
	echo "-A POSTROUTING -p tcp -j MASQUERADE" >> $IPTABLES_RULES_FILE
	echo "COMMIT" >> $IPTABLES_RULES_FILE
fi

if [ -f "$IPTABLES_RULES_FILE" ]; then
	iptables-restore < $IPTABLES_RULES_FILE
fi

openvpn --config $OPENVPN_CONFIG_FILE
