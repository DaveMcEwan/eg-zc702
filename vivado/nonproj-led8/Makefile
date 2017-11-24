
SELF := $(shell basename $(PWD))

default: all

bitstream:
	vivado -mode batch -source tcl/top.tcl

.PHONY : clean
clean:
	-rm -rf build
	-rm -rf .cache
	-rm -rf .Xil
	-rm -rf usage_statistics*
	-rm -rf vivado*.log
	-rm -rf vivado*.jou

# For this target to work you need to have ssh setup appropriately using
# ~/.ssh/config on the host.
# I.e. containing something like this:
#	Host zc702
#		Hostname 192.168.0.10
#		User root
#		StrictHostKeyChecking no
#		UserKnownHostsFile /dev/null
#		LogLevel QUIET
.PHONY : transfer
transfer:
	scp build/$(SELF).bit zc702:~/

.PHONY : program
program:
	ssh zc702 -C "cat $(SELF).bit > /dev/xdevcfg"

all: bitstream
all: transfer
all: program
