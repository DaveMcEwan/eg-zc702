
SELF := $(shell basename $(PWD))

DIR_BLD := build

default: sim

# Preprocess verilog with Icarus as Yosys doesn't feature `` delimiters.
$(DIR_BLD)/hdl/%.sv: hdl/%.sv
	mkdir -p $(DIR_BLD)/hdl
	iverilog -I hdl -E $^ -o $@

$(DIR_BLD)/tb/%.sv: tb/%.sv
	mkdir -p $(DIR_BLD)/tb
	iverilog -I hdl -E $^ -o $@

$(DIR_BLD)/tb_m.vvp: $(DIR_BLD)/tb/tb_m.sv
$(DIR_BLD)/tb_m.vvp: $(DIR_BLD)/hdl/pl_m.sv
	iverilog -g2012 -I hdl -s tb_m -o $@ $(DIR_BLD)/tb/*.sv $(DIR_BLD)/hdl/*.sv

build: $(DIR_BLD)/tb_m.vvp

$(DIR_BLD)/tb_m.vcd: $(DIR_BLD)/tb_m.vvp
	vvp $^

sim: $(DIR_BLD)/tb_m.vcd

wave: $(DIR_BLD)/tb_m.vcd
	gtkwave $^ &

.PHONY : clean
clean:
	-rm -rf build

# List all Make targets.
.PHONY : list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | \
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ \
			{if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

# https://sourceforge.net/p/iverilog/mailman/message/22289679/
#
# Simulate RTL that instantiates Xilinx primitives:
# iverilog -y $(XILINX)/Vivado/2017.3/data/verilog/src/unisims \
#	$(XILINX)/Vivado/2017.3/data/verilog/src/glbl.v \
#	<your_files>

# Simulate a placed/routed netlist:
# iverilog -y $(XILINX)/Vivado/2017.3/data/verilog/src/simprims \
#	$(XILINX)/Vivado/2017.3/data/verilog/src/glbl.v \
#	netlist.v testbench.v
