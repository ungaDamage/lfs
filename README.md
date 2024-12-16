me screwing around with cloud-init and/or linux from scratch

this is definitely trash

start by `./scripts/00-lfs-host.sh`

screw around in VM by `virsh console lfs-host`

start over by 

```bash
virsh shutdown lfs-host
virsh undefine lfs-host
rm workspace/*.qcow2
```
