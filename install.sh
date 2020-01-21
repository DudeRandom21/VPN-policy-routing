#!/bin/bash

echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter;
cp rules.v4 /etc/iptables/;
cp 01-network-manager-all.yaml /etc/netplan/;
cp rt_tables /etc/iproute2/;
