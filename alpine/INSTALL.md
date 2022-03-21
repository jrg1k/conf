# Alipne Linux installation

Run `setup-alpine`.

Configure mirrors in `/etc/apk/repositories`.

## Disk setup

Add packages: `apk add e2fsprogs dosfstools btrfs-progs`
Load filesystem modules:
- `modprobe btrfs`
- `modprobe vfat`
- `modprobe ext4`

Partition:

1. 100M FAT partition
2. 4G ext4 partition
3. Remaining space formatted as btrfs

Create btrfs subvolumes:
- @home
- @var

Configure /etc/fstab:

```
UUID=000000000000000000000000000000000000   /media/sda2     ext4    rw,noatime                                              0 0
UUID=000000000000000000000000000000000000   /home           btrfs   rw,noatime,compress=zstd:3,space_cache=v2,subvol=@home  0 0
UUID=000000000000000000000000000000000000   /var            btrfs   rw,noatime,compress=zstd:3,space_cache=v2,subvol=@var   0 0
```

## Configure

Mount all: `mount -a`

Create cache directory `/media/sda2/cache`.


Configure lbu in `/etc/lbu/lbu.conf`.

Commit system state using `lbu ci`.

Sync package cache: `apk cache -v sync`.

Setup bootable device: `setup-bootable -v /media/cdrom /dev/sda1`
