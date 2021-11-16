# Arch Linux install

You may use these instructions as an example but always check the
[ArchWiki](https://wiki.archlinux.org/) first and foremost.
This is an opinionated Arch Linux installation. It features full disk
encryption, btrfs filesystem, gnome desktop environment and more.

## Pre-install

Download the latest arch install iso from the
[download page](https://archlinux.org/download/).
Torrents are preffered due to increased security and reduced load on Arch infrastructure.

Verify using sha1:

```console
sha1sum <path-to-iso-image> | grep <provided-sha1-sum>
```

If the command outputs the signature it was successfull.

Verify using PGP:

Receive PGP-key using gpg:

```console
gpg --recv-keys <gpg-key-fingerprint>
```

Import local file:

```console
gpg --import <file-path>
```

Once the key has been imported download the pgp signature and cd to the download directory:

```console
gpg --verify-files <sig-file>
```

Now the image is ready to be burned to a USB-stick.
Plug the usb stick in and find its device name using lsblk.
Create the install media using dd:

```console
dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress
```

## Install

Set keyboard layout:

```console
loadkeys no
```

Check if efivars exist:

```console
ls /sys/firmware/efi/efivars
```

If using wifi connect to internet using [iwctl](https://wiki.archlinux.org/title/Iwd#iwctl).
Otherwise ethernet should just work.
Ping some site, for example archlinux.org to check connectivity.

Update system clock and check status:

```console
timedatectl set-ntp 1
timedatectl
```

Find and format disk using fdisk:

```console
fdisk -l
fdisk /dev/somedisk
```

Create partitions:

1. 1 GiB, EFI system partition
2. All space left, Linux filesystem

Encrypt main partition:

```console
cryptsetup luksFormat /dev/part2
cryptsetup open /dev/part2 cryptfs
```

Format partitions:

1. `mkfs.fat -F32 /dev/part1`
2. `mkfs.btrfs -L ARCH /dev/mapper/cryptfs`

Mount the main partition and create subvolumes:

```console
mount -o noatime,compress=zstd /dev/mapper/cryptfs /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
umount /mnt
```

Mount the devices and subvolumes:

```console
mount -o noatime,compress=zstd,subvol=@ /dev/mapper/cryptfs /mnt
mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/.snapshots
mkdir /mnt/var/log
mount -o noatime,compress=zstd,subvol=@home /dev/mapper/cryptfs /mnt/home
mount -o noatime,compress=zstd,subvol=@snapshots /dev/mapper/cryptfs /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@var_log /dev/mapper/cryptfs /mnt/var/log
mount /dev/part1 /mnt/boot
```

Install base system and chroot in:

```console
pacstrap /mnt base bash-completion neovim
genfstab -U /mnt >> /mnt/etc/fstab
# Edit fstab. Btrfs should have mount options noatime,compress=zstd,subvol=@subvol
vim /mnt/etc/fstab
arch-chroot /mnt
pacman -S base-devel linux linux-firmware btrfs-progs networkmanager iwd python python-pynvim man-db man-pages texinfo apparmor firewalld zram-generator (intel|amd)-ucode
```

Configure basic system configs:

```console
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
# Uncomment en_DK.UTF-8 UTF-8 in /etc/locale.gen
locale-gen
echo "LANG=en_DK.UTF-8" > /etc/locale.conf
echo "KEYMAP=no" > /etc/vconsole.conf
echo "machinename" > /etc/hostname
```

Configure matching entries in `/etc/hosts`

```console
127.0.0.1 localhost
::1 localhost
127.0.1.1 myhostname.localdomain myhostname
```

Configure `/etc/mkinitcpio.conf`:

```console
MODULES=(btrfs)
BINARIES=(/usr/bin/btrfs)
FILES=()
HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck)
```

Generate initramfs:

```console
mkinitcpio -P
```

Install systemd-boot:

```console
bootctl install
```

Create the bootloader config `/boot/loader/loader.conf`:

```console
default arch
timeout 5
console-mode max
editor no
```

Get the UUID of the main partition with `blkid` and append it to `/boot/loader/entries/arch.conf`:

```console
blkid | grep cryptdevice >> /boot/loader/entries/arch.conf
```

Then configure the config file:

```console
title Arch Linux
linux /vmlinuz-linux
initrd  /(intel|amd)-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=UUID_OF_LUKS_PARTITION=cryptfs root=/dev/mapper/cryptfs rootflags=subvol=@ rd.luks.options=discard lsm=lockdown,yama,apparmor rw
```

Configure NetworkManager backend `/etc/NetworkManager/conf.d/wifi_backend.conf`:

```console
[device]
wifi.backend=iwd
```

Configure swap by editing `/etc/systemd/zram-generator.conf`:

```console
[zram0]
zram-fraction = 1.0
max-zram-size = 8192
compression-algorithm = zstd
```

Enable services:

```console
systemctl enable systemd-timesyncd.service
systemctl enable NetworkManager.service
systemctl enable apparmor.service
systemctl enable fstrim.timer
systemctl enable firewalld.service
```

Set root password:

```console
passwd
```

Create admin user:

```console
useradd -m -G wheel username
passwd username
```

Allow users of group `wheel` to use sudo:

```console
visudo
```

Now reboot.

## Post-install

Install a some useful packages and configure some stuff:

```console
pacman -S xorg-server mesa xdg-desktop-portal xdg-desktop-portal-gtk pipewire flatpak noto-fonts ttf-fira-code ttf-dejavu ttf-liberation fish
pacman -S --asdeps pipewire-pulse
localectl set-x11-keymap no
```

Install a graphical environment:
[GNOME](https://wiki.archlinux.org/title/GNOME)

Run fish as interactive shell by modifying `/etc/bash.bashrc`:

```console
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
then
    exec fish
fi
```

Reboot and log in to the system.

