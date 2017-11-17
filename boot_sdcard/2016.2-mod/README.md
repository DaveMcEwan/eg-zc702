2016.2-mod
==========

This is a modified version of Xilinx's released boot files located at:
`http://www.wiki.xilinx.com/Zynq+2016.2+Release`
The goal is a minimal linux environment with the following features:

- SSH access via Ethernet
- Static IP address `192.168.0.10`
- User:password `root:`
- Configure Programmable Logic (PL) with `cat something.bit > /dev/xdevcfg`

The simplest way to get started is simply to copy all the files from this
directory to the `boot` partition of the SD card.
This assumes you have already partitioned the SD card to contain:

- FAT, boot, 200M
- EXT4, the rest of the card

The file `pl.bit` is not required for booting.
This is supplied to be used as a test for the PL configuration.
If successful, the 8 LEDs should be in the pattern 0x55 rather than 0xFF.
Assuming you have `zc702` setup as an SSH alias you can run `make xdevcfg`.

The only files actually required to be on the SD card are:

- `BOOT.BIN` - Specially named first file loaded, containing First Stage
  Boot Loader
- `uImage` - Linux kernel zImage wrapped in U-Boot header
- `devicetree.dtb` - Linux Device Tree Blob
- `uramdisk.image.gz` - Root filesyste as a gzipped CPIO archive, wrapped in a
  U-Boot header.
  This is the only file which needs to be modified (I assume naively).


Modifying initramfs: short version
----------------------------------

The initramfs is already unpacked in this repository so just make your edits,
then run `make`, then copy `uramdisk_new.image.gz` to the boot partition of the
SD card overwriting `uramdisk.image.gz`.


Modifying initramfs: detailed version
-------------------------------------

- unwrap the U-Boot header
    - `tail -c+65 < uramdisk.image.gz > initramfs.cpio.gz`
    - Alternatively `make unwrap`.
- create working area
    - `mkdir initramfs`
- decompress/unpack
    - `zcat initramfs.cpio.gz | sudo sh -c 'cd initramfs && cpio -i'`
    - Alternatively `make unpack`.
- modify
    - Edit `/etc/network/interfaces` for static IP on `eth0`.
    - Add public SSH key to `/home/root/.ssh/authorized_keys` for passwordless
      SSH access.
    - Any other changes...
- repack/compress
    - `sh -c 'cd initramfs && sudo find . | sudo cpio -H newc -o' | gzip -9 > initramfs_new.cpio.gz`
    - Alternatively `make pack`.
- wrap with U-Boot header
    - `mkimage -A arm -T ramdisk -O linux -n 2016.2-mod -d initramfs_new.cpio.gz uramdisk_new.image.gz`
    - Alternatively `make wrap`.
- copy new initramfs to sdcard
    - `cp uramdisk_new.image.gz $SDCARD/uramdisk.image.gz`
