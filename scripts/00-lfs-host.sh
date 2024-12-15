. config.sh

if [ ! -d "$CLOUD_IMAGE_DIR" ]; then
    echo $CLOUD_IMAGE_DIR unavailable >&2
    exit 1
fi

if [ ! -d "$WORKSPACE" ]; then
    echo $WORKSPACE unavailable >&2
    exit 1
fi

if [ ! -f "$CLOUD_IMAGE_DIR/$LFS_HOST_IMAGE" ]; then
    echo $LFS_HOST_IMAGE unavailable >&2
    exit 1
fi

lfs_host=lfs-host.qcow2
if [ ! -f "$WORKSPACE/$lfs_host" ]; then
    echo Copying lfs host image into workspace
    #cp $CLOUD_IMAGE_DIR/$LFS_HOST_IMAGE $WORKSPACE/lfs-host.qcow2
    qemu-img create -b $CLOUD_IMAGE_DIR/$LFS_HOST_IMAGE -f qcow2 -F qcow2 $WORKSPACE/$lfs_host 30G
fi

if virsh list --all | grep --quiet --invert-match lfs-host; then
    virt-install \
        --wait \
        --connect qemu:///session \
        --name lfs-host \
        --ram=2048 \
        --vcpus=2 \
        --import \
        --disk path=$WORKSPACE/$lfs_host,format=qcow2 \
        --os-variant=debian11 \
        --cloud-init user-data=files/user-data.yaml \
        --network default,model=e1000e 
        #--noautoconsole

    virsh --connect qemu:///session start lfs-host
fi

