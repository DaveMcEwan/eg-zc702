
SELF := $(shell basename $(PWD))

DIR_BLD := build

default: bitstream

# Preprocess verilog with Icarus as Yosys doesn't feature `` delimiters.
$(DIR_BLD)/hdl/%.sv: hdl/%.sv
	mkdir -p $(DIR_BLD)/hdl
	iverilog -I hdl -E $^ -o $@

# Additional SV files should be added here.
$(DIR_BLD)/pl_m.edif: $(DIR_BLD)/hdl/pl_m.sv
	yosys -p \
		"read_verilog -sv $(DIR_BLD)/hdl/pl_m.sv; \
		 synth_xilinx -top pl_m -edif $(DIR_BLD)/pl_m.edif"

synth: $(DIR_BLD)/pl_m.edif

bitstream: synth
	vivado -mode batch -source tcl/top.tcl

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

.PHONY : clean
clean:
	-rm -rf build
	-rm -rf .cache
	-rm -rf .Xil
	-rm -rf usage_statistics*
	-rm -rf vivado*.log
	-rm -rf vivado*.jou

# List all Make targets.
.PHONY : list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | \
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ \
			{if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
