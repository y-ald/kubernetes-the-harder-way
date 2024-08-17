### Testing the VM
First commit : Testing the VM
    
    sudo qemu-system-x86_64 \
    -nographic \
    -machine q35,accel=kvm \
    -cpu host \
    -smp 2 \
    -m 2G \
    -bios /usr/share/qemu/OVMF.fd \
    -nic user \
    -hda gateway/disk.img \
    -drive file=gateway/cidata.iso,driver=raw,if=virtio

