#!/usr/bin/env bash

set -xe
dir=$(dirname "$0")

if [[ -n $USE_CILIUM ]]; then
  helm install -n kube-system cilium cilium/cilium \
    --set kubeProxyReplacement=true \
    --set k8sServiceHost=kubernetes \
    --set k8sServicePort=6443 \
    --set cgroup.automount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup
fi

helm install -n kube-system coredns coredns/coredns \
  --set service.clusterIP=10.32.0.10 \
  --set replicaCount=2

helm install -n kube-system nfs-provisioner nfs-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=192.168.1.1 \
  --set nfs.path="$(realpath "$dir")/nfs-pvs" \
  --set storageClass.defaultClass=true

helm install -n kube-system metallb metallb/metallb

cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: lb-pool
  namespace: kube-system
spec:
  addresses:
    - 192.168.1.30-192.168.1.254
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: lb-l2adv
  namespace: kube-system
spec:
  ipAddressPools:
    - lb-pool
  interfaces:
    - enp0s1
EOF

