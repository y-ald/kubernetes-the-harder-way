#!/usr/bin/env sh

ifname="$1"
ip link set "$ifname" master kubr0
ip link set "$ifname" up