#!/usr/bin/env bash
# Install dependencies
set -x
set -euo pipefail

apt install -y iptables

# Most of this is from
# https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy

### set variables
# destinations you don't want routed through Tor
_non_tor="172.18.0.0/16"

### get the UID that tor runs as
_tor_uid=101

### Tor's TransPort
_trans_port="9040"
_dns_port="5353"

### flush iptables
iptables -F
iptables -t nat -F

### set iptables *nat to ignore tor user
iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN

### redirect all DNS output to tor's DNSPort
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5353

### set iptables *filter
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/8; do
   iptables -t nat -A OUTPUT -d $_clearnet -j RETURN
   iptables -A OUTPUT -d $_clearnet -j ACCEPT
done

### redirect all other output to tor's TransPort
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $_trans_port

### allow only tor output
iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT
iptables -A OUTPUT -j REJECT