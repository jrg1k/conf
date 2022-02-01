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
sudo dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress && sudo sync
```

## Install

Follow the [Arch installation guide](https://wiki.archlinux.org/title/Installation_guide) and prepare for installation such as setting keyboard layout and connecting to the internet. 

## Setup filesystem

Partition layout:

```
/dev/sdX1 - - - 1G                  EFI System
/dev/sdX2 - - - remaining space     Linux filesystem
```

Encrypt root partition:

```
cryptsetup luksFormat /dev/sdX2
cryptsetup open /dev/sdX2 cryptfs
```

Format partitions:

1. `mkfs.fat -F32 /dev/sdX1`
2. `mkfs.btrfs -L ROOT /dev/mapper/cryptfs`

Mount the main partition and create subvolumes:

```
mount -o noatime,compress=zstd /dev/mapper/cryptfs /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
umount /mnt
```

Mount the devices and subvolumes:

```
mount -o noatime,compress=zstd,subvol=@ /dev/mapper/cryptfs /mnt
mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/.snapshots
mkdir /mnt/var/log
mount -o noatime,compress=zstd,subvol=@home /dev/mapper/cryptfs /mnt/home
mount -o noatime,compress=zstd,subvol=@snapshots /dev/mapper/cryptfs /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@var_log /dev/mapper/cryptfs /mnt/var/log
mount -o noatime,umask=0007 /dev/sdX1 /mnt/boot
```

Generate sane mirrors:

```
reflector -p https -l 40 --score 40 --sort rate --save /etc/pacman.d/mirrorlist
```

## Installation and configuration

[Install essential packages](https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages) and [Configure the system](https://wiki.archlinux.org/title/Installation_guide#Configure_the_system).

Install [packages](pkglists) and [microcode](https://wiki.archlinux.org/title/Microcode). If using wireless connection install and configure [iwd](https://wiki.archlinux.org/title/Iwd).

Install a [bootloader](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader). Remember to add the proper device UUIDs to the bootloader configuration files. They can easily be obtained using `blkid -s UUID`.

Add system [configuration files](configs) as needed.

If using dracut copy the kernel and generate the initramfs:

```
cp /lib/modules/<kver>/vmlinuz /boot/vmlinuz-linux
dracut --hostonly --no-hostonly-cmdline --kver <kver> /boot/initramfs-linux.img
```

Alternatively add configuration files to do this [automatically](https://wiki.archlinux.org/title/Dracut#Generate_a_new_initramfs_on_kernel_upgrade) on kernel install and upgrade.

Enable services:

```
systemctl enable apparmor.service
systemctl enable auditd.service
systemctl enable chronyd.service
systemctl enable firewalld.service
systemctl enable fstrim.timer
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
```

Create admin user and add group wheel to the sudoers file:

```
useradd -m -G wheel username
passwd username
# Uncomment "%wheel ALL=(ALL) ALL"
EDITOR=nvim visudo
```

Lock the root accound:

```
passwd --lock root
```

Now reboot.

## Post-install

Set x11 keymap:

```
localectl set-x11-keymap us
```

Install more packages like a graphical environment.
