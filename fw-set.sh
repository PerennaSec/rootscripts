#!/bin/bash

# Log Function
logit="-j LOG --log-prefix"


# Flush current iptables rules and set default policy to DROP
iptables -F
iptables -X
iptables -Z
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED,INVALID -j ACCEPT

# Allow traffic to and from Wireguard interface
iptables -A INPUT -i wg0 -j ACCEPT
iptables -A OUTPUT -o wg0 -j ACCEPT

iptables -A OUTPUT -p udp --dport 51820 ${logit} "[ACCEPT OUT] WG0: "
iptables -A OUTPUT -p udp --dport 51820 -j ACCEPT

# Allow Privoxy
iptables -A INPUT -p tcp --dport 8118 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8118 -j ACCEPT

# Router Solicitations
iptables -A INPUT -p 2 -j DROP

# Allow HTTP & HTTPS
iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner 392 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner 392 -j ACCEPT

iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner 301 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner 301 -j ACCEPT

# Allow DNS requests
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allow NTP lookups
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow SSH connections
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Allow ping requests
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# Allow traceroute
iptables -A OUTPUT -p udp --dport 33434:33524 ${logit} "[ACCEPT OUT] TRCR: "
iptables -A OUTPUT -p udp --dport 33434:33524 -j ACCEPT

# Allow whois requests
iptables -A OUTPUT -p tcp --dport 43 ${logit} "[ACCEPT OUT] WHOIS : "
iptables -A OUTPUT -p tcp --dport 43 -j ACCEPT

# Allow HKP
iptables -A OUTPUT -p tcp --dport 11371 ${logit} "[ACCEPT OUT] HKP: "
iptables -A OUTPUT -p tcp --dport 11371 -j ACCEPT

# Allow Git, Flatpak, Minecraft, 0AD, Tor, and I2P
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m owner --uid-owner 313 ${logit} "[ACCEPT OUT] FLATPAK: "
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m owner --uid-owner 313 -j ACCEPT

iptables -A OUTPUT -p tcp -m multiport --dports 9418,29418 ${logit} "[ACCEPT OUT] GIT: "
iptables -A OUTPUT -p tcp -m multiport --dports 9418,29418 -j ACCEPT

iptables -A OUTPUT -p tcp -m multiport --dport 25565,25566 -m owner --uid-owner 1000 ${logit} "[ACCEPT OUT] MINECRAFT : "
iptables -A OUTPUT -p tcp -m multiport --dports 25565,25566 -m owner --uid-owner 1000 -j ACCEPT

iptables -A OUTPUT -p udp -m multiport --dports 20595,20596 -m owner --uid-owner 1000 ${logit} "[ACCEPT OUT] 0AD: "
iptables -A OUTPUT -p udp -m multiport --dports 20595,20596 -m owner --uid-owner 1000 -j ACCEPT

iptables -A OUTPUT -p tcp -m multiport --dports 9050,9150 ${logit} "[ACCEPT OUT] TOR: "
iptables -A OUTPUT -p tcp -m multiport --dports 9050,9150 -j ACCEPT

iptables -A OUTPUT -p tcp -m multiport --dports 4444,4445 ${logit} "[ACCEPT OUT] I2P: "
iptables -A OUTPUT -p tcp -m multiport --dports 4444,4445 -j ACCEPT

# Allow QTWebKit
iptables -A OUTPUT      -d 77.86.229.90 ${logit} "[ACCEPT OUT] QTWebKit: "
iptables -A OUTPUT      -d 77.86.229.90 -j ACCEPT

# Allow RSync
iptables -A OUTPUT      -p tcp --dport 873 ${logit} "[ACCEPT OUT] RSYNC: "
iptables -A OUTPUT      -p tcp --dport 873 -j ACCEPT
iptables -A OUTPUT      -p udp --dport 873 ${logit} "[ACCEPT OUT] RSYNC: "
iptables -A OUTPUT      -p udp --dport 873 -j ACCEPT

# Allow qBittorrent
iptables -A OUTPUT -p tcp -m tcp --dport 6881:6999 ${logit} "[ACCEPT OUT] BITTORRENT: "
iptables -A OUTPUT -p tcp -m tcp --dport 6881:6999 -j ACCEPT

iptables -A OUTPUT -p udp -m udp --dport 6881:6999 ${logit} "[ACCEPT OUT] BITTORRENT: "
iptables -A OUTPUT -p udp -m udp --dport 6881:6999 -j ACCEPT

#iptables -A OUTPUT -p tcp -m tcp --dport 49152:65534 ${logit} "[ACCEPT OUT] BITTORRENT: "
#iptables -A OUTPUT -p tcp -m tcp --dport 49152:65534 -j ACCEPT

#iptables -A OUTPUT -p udp -m udp --dport 49152:65534 ${logit} "[ACCEPT OUT] BITTORRENT: "
#iptables -A OUTPUT -p udp -m udp --dport 49152:65534 -j ACCEPT

#iptables -A OUTPUT -p udp -m udp --dport 1337 ${logit} "[ACCEPT OUT] BITTORRENT: "
#iptables -A OUTPUT -p udp -m udp --dport 1337 -j ACCEPT

#iptables -A INPUT -p tcp -m tcp --dport 6881:6999 ${logit} "ACCEPT IN BITTORRENT: "
#iptables -A INPUT -p tcp -m tcp --dport 6881:6999 -j ACCEPT

# Allow Wireguard IP
#iptables -A OUTPUT -p udp -m udp --dport 3301 ${logit} "[ACCEPT OUT] WG: "
#iptables -A OUTPUT -p udp -m udp --dport 3301 -j ACCEPT

# Allow NMap
iptables -A OUTPUT -p tcp -m tcp --syn ${logit} "[ACCEPT OUT] NMAP SYN: " #SYN Scan
iptables -A OUTPUT -p tcp -m tcp --syn -j ACCEPT #SYN Scan


# Allow VirtualBox Interfaces
iptables -A INPUT -i vboxnet0 -j ACCEPT
iptables -A OUTPUT -o vboxnet0 -j ACCEPT

# Allow Spiderfoot
iptables -A INPUT -p tcp --sport 5001
iptables -A OUTPUT -p tcp --sport 5001

# Drop Packets Related to Windows Network Discovery (Enable if Windows is on the Network)
iptables -A INPUT      -p udp --dport 137 -j DROP      # netbios-ns
iptables -A INPUT      -p udp --dport 138 -j DROP      # netbios-dgm
iptables -A INPUT      -p udp --dport 67 -j DROP
iptables -A INPUT      -p udp --dport 68 -j DROP

# Allow Mail Functionality
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 465 -j ACCEPT

iptables -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -p tcp --dport 995 -j ACCEPT

iptables -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -A INPUT -p tcp --dport 993 -j ACCEPT

# Drop and log all other traffic
iptables -A INPUT -j LOG --log-prefix "[DROP] IN: "
iptables -A OUTPUT -j LOG --log-prefix "[REJECT] OUT: "
iptables -A INPUT -j DROP
iptables -A OUTPUT -j REJECT
iptables -A FORWARD -j DROP

# Save iptables rules
iptables-save > /etc/MY/fwrules
