#!/usr/bin/env bash
set -xe
dir=$(dirname "$0")

# Grab the helpers
source "$dir/helpers.sh"

# Parse the argument (VM ID)
vmid=$1
vmname=$(id_to_name "$vmid")
vmdir="$dir/$vmname"

# Assign resources
case "$vmname" in
  gateway|control*)
    vcpus=2
    memory=2G
    ;;
  worker*)
    vcpus=4
    memory=4G
    ;;
esac

# Compute the MAC address
mac="52:52:52:00:00:0$vmid"

# Launch the VM
qemu-system-x86_64 \
    -nographic \
    -machine q35,accel=kvm \
    -cpu host \
    -smp $vcpus \
    -m $memory \
    -bios /usr/share/qemu/OVMF.fd \
    -nic tap,script=tapup.sh,downscript=no,"mac=$mac" \
    -hda "$vmdir/disk.img" \
    -drive file="$vmdir/cidata.iso",driver=raw,if=virtio