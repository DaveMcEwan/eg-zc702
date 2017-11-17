
default: wrap

.PHONY: unwrap
unwrap:
	tail -c+65 < uramdisk.image.gz > initramfs.cpio.gz

.PHONY: unpack
unpack:
	zcat initramfs.cpio.gz | sudo sh -c 'cd initramfs && cpio -i'

.PHONY: pack
pack:
	sh -c 'cd initramfs && sudo find . | sudo cpio -H newc -o' | \
		gzip -9 > initramfs_new.cpio.gz

.PHONY: wrap
wrap: pack
	mkimage \
		-A arm \
		-T ramdisk \
		-O linux \
		-n 2016.2-mod \
		-d initramfs_new.cpio.gz \
		uramdisk_new.image.gz


# For this target to work you need to have ssh setup appropriately using
# ~/.ssh/config on the host.
# I.e. containing something like this:
#	Host zc702
#		Hostname 192.168.0.10
#		User root
#		StrictHostKeyChecking no
#		UserKnownHostsFile /dev/null
#		LogLevel QUIET
run:
.PHONY: xdevcfg
xdevcfg:
	scp pl.bit zc702:~/
	ssh zc702 -C "cat pl.bit > /dev/xdevcfg"
