# Arch Linux install

Always confere the [Arch Wiki](https://wiki.archlinux.org/) for up to date instructions on how to install and configure Arch Linux. This is an opinionated Arch Linux installation. It features full disk encryption, btrfs filesystem and more.

## Pre-install

Download the latest arch install iso from the
[download page](https://archlinux.org/download/).
Torrents are preffered due to increased security and reduced load on Arch infrastructure.

Now the image is ready to be burned to a USB-stick.
Plug the usb stick in and find its device name using lsblk.
Create the install media using dd:

```
dd if=archlinux-xxxx.xx.xx-x86_64.iso of=/dev/sdX bs=8M status=progress oflag=direct && sync
```

## Install

Follow the [Arch installation guide](https://wiki.archlinux.org/title/Installation_guide) and prepare for installation such as setting keyboard layout and connecting to the internet. 

## Setup filesystem

Partition layout:

```
/dev/sdX1 - - - 1G                  EFI System
/dev/sdX2 - - - remaining space     Linux filesystem
```

Format partitions:

1. `mkfs.fat -F32 /dev/sdX1`
2. `mkfs.btrfs -L ROOT /dev/sdX2`

Mount the main partition and create subvolumes:

```
mount -o noatime,compress=zstd /dev/sdX2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
umount /mnt
```

Mount the devices and subvolumes:

```
mount -o noatime,compress=zstd,subvol=@ /dev/mapper/cryptfs /mnt
mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var/log
mount -o noatime,compress=zstd,subvol=@home /dev/mapper/cryptfs /mnt/home
mount -o noatime,compress=zstd,subvol=@var_log /dev/mapper/cryptfs /mnt/var/log
mount -o noatime,umask=0007 /dev/sdX1 /mnt/boot
```

Generate sane mirrors:

```
reflector -p https -l 20 --score 20 --sort rate --save /etc/pacman.d/mirrorlist
```

## Installation and configuration

[Install essential packages](https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages) 
and [Configure the system](https://wiki.archlinux.org/title/Installation_guide#Configure_the_system).

Install [packages](pkglists) and [microcode](https://wiki.archlinux.org/title/Microcode).

Install a [bootloader](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader).
Add the proper device UUIDs to the bootloader configuration files. They can be obtained using `blkid -s UUID`.

Add system [configuration files](configs) as needed.

Enable services:

```
systemctl enable apparmor.service
systemctl enable auditd.service
systemctl enable chronyd.service
systemctl enable firewalld.service
systemctl enable fstrim.timer
systemctl enable NetworkManager.service
systemctl enable systemd-homed.service
systemctl enable systemd-resolved.service
```

Create temporary password for the root account using `passwd`.

Reboot.

## Post-install

Create admin user and add group wheel to the sudoers file:

```
homectl create <user> -c <real-name> --storage luks --member-of wheel
passwd username
# Uncomment "%wheel ALL=(ALL) ALL"
visudo
```

Lock the root accound:

```
passwd --lock root
```

Install more packages like a graphical environment.
